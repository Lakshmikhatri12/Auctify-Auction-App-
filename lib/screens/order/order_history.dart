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

// import 'package:auctify/controllers/order_controller.dart';
// import 'package:auctify/models/order_model.dart';
// import 'package:auctify/models/auction_model.dart';
// import 'package:auctify/screens/order/order_summary.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class OrderHistoryScreen extends StatelessWidget {
//   final OrderController _orderController = OrderController();

//   OrderHistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Order History'),
//           elevation: 0,
//           bottom: TabBar(
//             indicatorSize: TabBarIndicatorSize.tab,
//             indicatorColor: AppColors.primary,
//             labelStyle: GoogleFonts.archivo(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//             labelColor: AppColors.primary,
//             unselectedLabelColor: AppColors.textSecondary,
//             tabs: const [
//               Tab(text: 'I Placed'),
//               Tab(text: 'I Received'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _buyerOrders(context, currentUserId),
//             _sellerOrders(context, currentUserId),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ---------------- BUYER ORDERS ----------------
//   Widget _buyerOrders(BuildContext context, String currentUserId) {
//     return StreamBuilder<List<OrderModel>>(
//       stream: _orderController.getBuyerOrders(currentUserId),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final orders = snapshot.data!;
//         if (orders.isEmpty) {
//           return Center(
//             child: Text(
//               'You haven\'t placed any orders yet.',
//               style: GoogleFonts.lato(fontSize: 16),
//             ),
//           );
//         }

//         return ListView.separated(
//           padding: const EdgeInsets.all(16),
//           itemCount: orders.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 16),
//           itemBuilder: (_, index) => _buyerOrderCard(context, orders[index]),
//         );
//       },
//     );
//   }

//   /// ---------------- SELLER ORDERS ----------------
//   Widget _sellerOrders(BuildContext context, String currentUserId) {
//     return StreamBuilder<List<OrderModel>>(
//       stream: _orderController.getSellerOrders(currentUserId),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final orders = snapshot.data!;
//         if (orders.isEmpty) {
//           return Center(
//             child: Text(
//               'No orders received yet.',
//               style: GoogleFonts.lato(fontSize: 16),
//             ),
//           );
//         }

//         return ListView.separated(
//           padding: const EdgeInsets.all(16),
//           itemCount: orders.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 16),
//           itemBuilder: (_, index) => _sellerOrderCard(context, orders[index]),
//         );
//       },
//     );
//   }

//   /// ---------------- BUYER CARD ----------------
//   Widget _buyerOrderCard(BuildContext context, OrderModel order) {
//     return FutureBuilder<AuctionModel>(
//       future: _fetchAuction(order.auctionId),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const SizedBox(
//             height: 140,
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }
//         final auction = snapshot.data!;
//         return _buildCard(
//           context: context,
//           order: order,
//           auction: auction,
//           userLabel: 'Seller',
//           userName: auction.sellerName,
//         );
//       },
//     );
//   }

//   /// ---------------- SELLER CARD ----------------
//   Widget _sellerOrderCard(BuildContext context, OrderModel order) {
//     return FutureBuilder<AuctionModel>(
//       future: _fetchAuction(order.auctionId),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const SizedBox(
//             height: 140,
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }
//         final auction = snapshot.data!;
//         return _buildCard(
//           context: context,
//           order: order,
//           auction: auction,
//           userLabel: 'Buyer',
//           userName: order.buyerId,
//         );
//       },
//     );
//   }

//   /// ---------------- REUSABLE CARD BUILDER ----------------
//   Widget _buildCard({
//     required BuildContext context,
//     required OrderModel order,
//     required AuctionModel auction,
//     required String userLabel,
//     required String userName,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => OrderSummaryScreen(
//               orderId: order.orderId,
//               auction: auction,
//               shippingAddress: order.shippingAddress,
//               paymentMethod: order.paymentStatus == 'paid' ? 'card' : 'cod',
//               price: order.price,
//             ),
//           ),
//         );
//       },
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 4,
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.horizontal(
//                 left: Radius.circular(12),
//               ),
//               child: auction.imageUrls.isNotEmpty
//                   ? Image.network(
//                       auction.imageUrls.first,
//                       width: 120,
//                       height: 120,
//                       fit: BoxFit.cover,
//                     )
//                   : Container(
//                       width: 120,
//                       height: 120,
//                       color: Colors.grey[300],
//                       child: const Icon(Icons.image, size: 50),
//                     ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       auction.title,
//                       style: GoogleFonts.lato(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       '$userLabel: $userName',
//                       style: GoogleFonts.lato(fontSize: 14),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       'Price: \$${order.price.toStringAsFixed(2)}',
//                       style: GoogleFonts.lato(
//                         fontSize: 14,
//                         color: Colors.deepPurpleAccent,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         _statusChip(order.orderStatus, Colors.green),
//                         const SizedBox(width: 6),
//                         _statusChip(order.paymentStatus, Colors.blue),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _statusChip(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withAlpha(
//           38,
//         ), // replacement for deprecated withOpacity(0.15)
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         text,
//         style: GoogleFonts.lato(
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//           color: color,
//         ),
//       ),
//     );
//   }

//   /// ---------------- FETCH AUCTION ----------------
//   Future<AuctionModel> _fetchAuction(String auctionId) async {
//     final doc = await FirebaseFirestore.instance
//         .collection('auctions')
//         .doc(auctionId)
//         .get();
//     return AuctionModel.fromFirestore(doc.data()!, doc.id);
//   }
// }

import 'package:auctify/controllers/order_controller.dart';
import 'package:auctify/models/auction_model.dart';
import 'package:auctify/models/order_model.dart';
import 'package:auctify/screens/order/order_summary.dart';
import 'package:auctify/utils/constants.dart';
import 'package:auctify/utils/custom_appbar.dart';
import 'package:auctify/utils/notification_Icon.dart';
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
        appBar: CustomAppBar(
          title: "Order History",
          actions: const [NotificationIcon(), SizedBox(width: 5)],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.primary,
            labelStyle: GoogleFonts.archivo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            labelColor: AppColors.primary,
            unselectedLabelColor: Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withOpacity(0.6),
            tabs: const [
              Tab(text: 'My Purchases'),
              Tab(text: 'My Sales'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ordersTab(context, currentUserId, isSeller: false),
            _ordersTab(context, currentUserId, isSeller: true),
          ],
        ),
      ),
    );
  }

  /// ---------------- ORDERS TAB (BUYER/SELLER) ----------------
  Widget _ordersTab(
    BuildContext context,
    String currentUserId, {
    required bool isSeller,
  }) {
    final Stream<List<OrderModel>> ordersStream = isSeller
        ? _orderController.getSellerOrders(currentUserId)
        : _orderController.getBuyerOrders(currentUserId);

    return StreamBuilder<List<OrderModel>>(
      stream: ordersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data ?? [];
        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSeller ? Icons.sell_outlined : Icons.shopping_bag_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  isSeller
                      ? 'No orders received yet.'
                      : 'You haven\'t placed any orders yet.',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        // Collect all auction IDs
        final auctionIds = orders.map((o) => o.auctionId).toList();

        // Batch fetch auctions
        return FutureBuilder<Map<String, AuctionModel>>(
          future: _fetchAuctions(auctionIds),
          builder: (context, auctionSnapshot) {
            if (!auctionSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final auctionsMap = auctionSnapshot.data!;

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, index) {
                final order = orders[index];
                final auction = auctionsMap[order.auctionId];

                if (auction == null) return const SizedBox.shrink();

                return _buildPremiumOrderCard(
                  context: context,
                  order: order,
                  auction: auction,
                  isSeller: isSeller,
                );
              },
            );
          },
        );
      },
    );
  }

  /// ---------------- PREMIUM ORDER CARD ----------------
  Widget _buildPremiumOrderCard({
    required BuildContext context,
    required OrderModel order,
    required AuctionModel auction,
    required bool isSeller,
  }) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color;
    final textColor = theme.textTheme.titleMedium?.color;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderSummaryScreen(
              orderId: order.orderId,
              auction: auction,
              shippingAddress: order.shippingAddress,
              paymentMethod: order.paymentStatus == 'paid' ? 'card' : 'cod',
              price: order.price,
              isSeller: isSeller,
              initialStatus: order.orderStatus,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // --- Header: Order Status & Date ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statusBadge(order.orderStatus),
                  Text(
                    _formatDate(order.createdAt),
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // --- Body: Image & Details ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: auction.imageUrls.isNotEmpty
                        ? Image.network(
                            auction.imageUrls.first,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 90,
                            height: 90,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auction.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isSeller
                              ? 'Buyer: ${order.buyerId}' // TODO: Fetch buyer name if needed
                              : 'Seller: ${auction.sellerName}',
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${order.price.toStringAsFixed(2)}',
                          style: GoogleFonts.archivo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- Footer: Seller Actions or Info ---
            if (isSeller) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Update Status:",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    _buildStatusDropdown(context, order),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context, OrderModel order) {
    const statuses = ['placed', 'confirmed', 'shipped', 'delivered'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: statuses.contains(order.orderStatus)
              ? order.orderStatus
              : null,
          hint: Text(order.orderStatus),
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
          borderRadius: BorderRadius.circular(12),
          items: statuses.map((String status) {
            return DropdownMenuItem<String>(
              value: status,
              child: _statusBadge(status, isSmall: true),
            );
          }).toList(),
          onChanged: (String? newStatus) {
            if (newStatus != null && newStatus != order.orderStatus) {
              _orderController.updateOrderStatus(order.orderId, newStatus);
            }
          },
        ),
      ),
    );
  }

  Widget _statusBadge(String status, {bool isSmall = false}) {
    Color color;
    String label = status.toUpperCase();

    switch (status.toLowerCase()) {
      case 'placed':
        color = Colors.blue;
        break;
      case 'confirmed':
        color = Colors.orange;
        break;
      case 'shipped':
        color = Colors.purple;
        break;
      case 'delivered':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    // For dropdown (isSmall), we return just text or a smaller row
    if (isSmall) {
      return Text(
        label,
        style: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.lato(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }

  /// ---------------- BATCH FETCH AUCTIONS ----------------
  Future<Map<String, AuctionModel>> _fetchAuctions(
    List<String> auctionIds,
  ) async {
    if (auctionIds.isEmpty) return {};

    // Firestore whereIn supports max 10 items per query, so batch if needed
    const int batchSize = 10;
    Map<String, AuctionModel> auctionsMap = {};

    for (var i = 0; i < auctionIds.length; i += batchSize) {
      final batchIds = auctionIds.sublist(
        i,
        (i + batchSize).clamp(0, auctionIds.length),
      );
      final snapshot = await FirebaseFirestore.instance
          .collection('auctions')
          .where(FieldPath.documentId, whereIn: batchIds)
          .get();

      for (var doc in snapshot.docs) {
        auctionsMap[doc.id] = AuctionModel.fromFirestore(doc.data(), doc.id);
      }
    }

    return auctionsMap;
  }
}
