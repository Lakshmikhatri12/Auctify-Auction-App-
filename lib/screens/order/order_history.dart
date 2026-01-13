// import 'package:auctify/controllers/order_controller.dart';
// import 'package:auctify/models/order_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class OrderHistoryScreen extends StatelessWidget {
//   final bool isSeller; // true if showing seller orders, false for buyer
//   final OrderController _orderController = OrderController();

//   OrderHistoryScreen({super.key, this.isSeller = false});

//   @override
//   Widget build(BuildContext context) {
//     final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

//     // Choose stream based on user type
//     final Stream<List<OrderModel>> ordersStream = isSeller
//         ? _orderController.getSellerOrders(currentUserId)
//         : _orderController.getBuyerOrders(currentUserId);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(isSeller ? 'My Sold Auctions' : 'My Orders'),
//         elevation: 0,
//       ),
//       body: StreamBuilder<List<OrderModel>>(
//         stream: ordersStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Text(
//                 isSeller ? 'No auctions sold yet.' : 'No orders yet.',
//                 style: GoogleFonts.lato(fontSize: 16),
//               ),
//             );
//           }

//           final orders = snapshot.data!;

//           return ListView.separated(
//             padding: const EdgeInsets.all(16),
//             itemCount: orders.length,
//             separatorBuilder: (_, __) => const SizedBox(height: 12),
//             itemBuilder: (_, index) {
//               final order = orders[index];
//               return _orderCard(order);
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _orderCard(OrderModel order) {
//     final shippingAddress = order.shippingAddress.entries
//         .map((e) => '${_labelForKey(e.key)}: ${e.value}')
//         .join('\n');

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Order ID: ${order.orderId}',
//               style: GoogleFonts.lato(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),
//             Text('Auction ID: ${order.auctionId}', style: GoogleFonts.lato()),
//             const SizedBox(height: 6),
//             Text(
//               'Price: \$${order.price.toStringAsFixed(2)}',
//               style: GoogleFonts.lato(color: Colors.deepPurpleAccent),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               'Order Status: ${order.orderStatus}',
//               style: GoogleFonts.lato(),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               'Payment Status: ${order.paymentStatus}',
//               style: GoogleFonts.lato(),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               'Shipping Address:',
//               style: GoogleFonts.lato(fontWeight: FontWeight.bold),
//             ),
//             Text(shippingAddress, style: GoogleFonts.lato()),
//           ],
//         ),
//       ),
//     );
//   }

//   String _labelForKey(String key) {
//     switch (key) {
//       case 'name':
//         return 'Full Name';
//       case 'phone':
//         return 'Phone Number';
//       case 'street':
//         return 'Street';
//       case 'city':
//         return 'City';
//       case 'state':
//         return 'State';
//       case 'zip':
//         return 'ZIP Code';
//       case 'country':
//         return 'Country';
//       default:
//         return key;
//     }
//   }
// }

import 'package:auctify/controllers/order_controller.dart';
import 'package:auctify/models/order_model.dart';
import 'package:auctify/models/auction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderHistoryScreen extends StatelessWidget {
  final OrderController _orderController = OrderController();

  OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order History'),
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'I Placed'),
              Tab(text: 'I Received'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buyerOrders(currentUserId), _sellerOrders(currentUserId)],
        ),
      ),
    );
  }

  Widget _buyerOrders(String currentUserId) {
    return StreamBuilder<List<OrderModel>>(
      stream: _orderController.getBuyerOrders(currentUserId),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final orders = snapshot.data!;
        if (orders.isEmpty)
          return Center(
            child: Text(
              'You haven\'t placed any orders yet.',
              style: GoogleFonts.lato(fontSize: 16),
            ),
          );

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, index) => _buyerOrderCard(orders[index]),
        );
      },
    );
  }

  Widget _sellerOrders(String currentUserId) {
    return StreamBuilder<List<OrderModel>>(
      stream: _orderController.getSellerOrders(currentUserId),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final orders = snapshot.data!;
        if (orders.isEmpty)
          return Center(
            child: Text(
              'No orders received yet.',
              style: GoogleFonts.lato(fontSize: 16),
            ),
          );

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, index) => _sellerOrderCard(orders[index]),
        );
      },
    );
  }

  /// ---------------- BUYER CARD ----------------
  Widget _buyerOrderCard(OrderModel order) {
    return FutureBuilder<AuctionModel>(
      future: _fetchAuction(order.auctionId),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const SizedBox(
            height: 140,
            child: Center(child: CircularProgressIndicator()),
          );
        final auction = snapshot.data!;
        return _buildCard(
          title: auction.title,
          userLabel: 'Seller',
          userName: auction.sellerName,
          price: order.price,
          images: auction.imageUrls,
          orderStatus: order.orderStatus,
          paymentStatus: order.paymentStatus,
        );
      },
    );
  }

  /// ---------------- SELLER CARD ----------------
  Widget _sellerOrderCard(OrderModel order) {
    return FutureBuilder<AuctionModel>(
      future: _fetchAuction(order.auctionId),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const SizedBox(
            height: 140,
            child: Center(child: CircularProgressIndicator()),
          );
        final auction = snapshot.data!;
        return _buildCard(
          title: auction.title,
          userLabel: 'Buyer',
          userName: order.buyerId,
          price: order.price,
          images: auction.imageUrls,
          orderStatus: order.orderStatus,
          paymentStatus: order.paymentStatus,
        );
      },
    );
  }

  /// ---------------- REUSABLE CARD BUILDER ----------------
  Widget _buildCard({
    required String title,
    required String userLabel,
    required String userName,
    required double price,
    required List<String> images,
    required String orderStatus,
    required String paymentStatus,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child: images.isNotEmpty
                ? Image.network(
                    images.first,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 50),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$userLabel: $userName',
                    style: GoogleFonts.lato(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Price: \$${price.toStringAsFixed(2)}',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _statusChip(orderStatus, Colors.green),
                      const SizedBox(width: 6),
                      _statusChip(paymentStatus, Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  /// ---------------- FETCH AUCTION ----------------
  Future<AuctionModel> _fetchAuction(String auctionId) async {
    final doc = await FirebaseFirestore.instance
        .collection('auctions')
        .doc(auctionId)
        .get();
    return AuctionModel.fromFirestore(doc.data()!, doc.id);
  }
}
