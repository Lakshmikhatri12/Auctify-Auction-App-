// import 'package:auctify/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({super.key});

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   String _selectedPaymentMethod = 'card';

//   final Map<String, TextEditingController> _addressControllers = {
//     'name': TextEditingController(),
//     'phone': TextEditingController(),
//     'street': TextEditingController(),
//     'city': TextEditingController(),
//     'state': TextEditingController(),
//     'zip': TextEditingController(),
//     'country': TextEditingController(),
//   };

//   @override
//   Widget build(BuildContext context) {
//     final double productPrice = 120.0;
//     final double deliveryCharges = 10.0;
//     final double tax = 5.0;
//     final double total = productPrice + deliveryCharges + tax;

//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: AppBar(title: const Text('Checkout'), elevation: 0),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ---------------- Product Summary ----------------
//             Text(
//               'Order Summary',
//               style: GoogleFonts.lato(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: 80,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Icon(
//                           Icons.gavel,
//                           size: 40,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Product Name Here',
//                               style: GoogleFonts.lato(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 6),

//                             Text(
//                               '\$${productPrice.toStringAsFixed(2)}',
//                               style: GoogleFonts.lato(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.deepPurpleAccent,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Divider(height: 24, color: Colors.grey),
//                   _priceRow('Delivery Charges', deliveryCharges),
//                   _priceRow('Tax', tax),
//                   const SizedBox(height: 12),
//                   _priceRow('Total', total, isTotal: true),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),

//             // ---------------- Shipping Address ----------------
//             Text(
//               'Shipping Address',
//               style: GoogleFonts.lato(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 12),
//             ..._addressControllers.entries.map((entry) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: TextField(
//                   controller: entry.value,
//                   decoration: InputDecoration(
//                     labelText: _labelForKey(entry.key),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 10,
//                     ),
//                   ),
//                   keyboardType: entry.key == 'phone' || entry.key == 'zip'
//                       ? TextInputType.number
//                       : TextInputType.text,
//                 ),
//               );
//             }).toList(),
//             const SizedBox(height: 24),

//             // ---------------- Payment Method ----------------
//             Text(
//               'Payment Method',
//               style: GoogleFonts.lato(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Container(
//               height: 48,
//               margin: const EdgeInsets.only(bottom: 10),

//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(
//                   width: 1,
//                   color: const Color.fromARGB(255, 209, 208, 208),
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Icon(size: 24, Icons.payment, color: Colors.blueAccent),
//                     const SizedBox(width: 24),

//                     Expanded(
//                       child: Text(
//                         "Stripe",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400,
//                           color: Color(0xFF171A1F),
//                         ),
//                       ),
//                     ),

//                     const Icon(Icons.arrow_forward_ios, size: 16),
//                   ],
//                 ),
//               ),
//             ),
//             RadioListTile(
//               title: const Text('Cash on Delivery'),
//               value: 'cod',
//               groupValue: _selectedPaymentMethod,
//               onChanged: (value) =>
//                   setState(() => _selectedPaymentMethod = value.toString()),
//             ),
//             const SizedBox(height: 24),

//             // ---------------- Place Order Button ----------------
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle place order click
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurpleAccent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   'Place Order',
//                   style: GoogleFonts.lato(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _priceRow(String label, double amount, {bool isTotal = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.lato(
//               fontSize: isTotal ? 16 : 14,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           Text(
//             '\$${amount.toStringAsFixed(2)}',
//             style: GoogleFonts.lato(
//               fontSize: isTotal ? 16 : 14,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               color: isTotal ? Colors.deepPurpleAccent : Colors.black,
//             ),
//           ),
//         ],
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
// import 'package:auctify/models/auction_model.dart';
// import 'package:auctify/screens/order/order_summary.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CheckoutScreen extends StatefulWidget {
//   final String auctionId; // pass the auction ID

//   const CheckoutScreen({super.key, required this.auctionId});

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   String _selectedPaymentMethod = 'card';

//   final Map<String, TextEditingController> _addressControllers = {
//     'name': TextEditingController(),
//     'phone': TextEditingController(),
//     'street': TextEditingController(),
//     'city': TextEditingController(),
//     'state': TextEditingController(),
//     'zip': TextEditingController(),
//     'country': TextEditingController(),
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: AppBar(title: const Text('Checkout'), elevation: 0),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('auctions')
//             .doc(widget.auctionId)
//             .get(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final auctionData = snapshot.data!.data() as Map<String, dynamic>?;

//           if (auctionData == null) {
//             return const Center(child: Text('Auction not found'));
//           }

//           final String title = auctionData['title'] ?? "Auction";
//           final double price = (auctionData['currentBid'] ?? 0).toDouble();
//           final List images = auctionData['imageUrls'] ?? [];
//           final String imageUrl = images.isNotEmpty ? images.first : "";

//           final double deliveryCharges = 10.0;
//           final double tax = 5.0;
//           final double total = price + deliveryCharges + tax;

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ---------------- Product Summary ----------------
//                 Text(
//                   'Order Summary',
//                   style: GoogleFonts.lato(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             width: 80,
//                             height: 80,
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade300,
//                               borderRadius: BorderRadius.circular(12),
//                               image: imageUrl.isNotEmpty
//                                   ? DecorationImage(
//                                       image: NetworkImage(imageUrl),
//                                       fit: BoxFit.cover,
//                                     )
//                                   : null,
//                             ),
//                             child: imageUrl.isEmpty
//                                 ? const Icon(
//                                     Icons.gavel,
//                                     size: 40,
//                                     color: Colors.grey,
//                                   )
//                                 : null,
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   title,
//                                   style: GoogleFonts.lato(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Text(
//                                   '\$${price.toStringAsFixed(2)}',
//                                   style: GoogleFonts.lato(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.deepPurpleAccent,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Divider(height: 24, color: Colors.grey),
//                       _priceRow('Delivery Charges', deliveryCharges),
//                       _priceRow('Tax', tax),
//                       const SizedBox(height: 12),
//                       _priceRow('Total', total, isTotal: true),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // ---------------- Shipping Address ----------------
//                 Text(
//                   'Shipping Address',
//                   style: GoogleFonts.lato(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ..._addressControllers.entries.map((entry) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: TextField(
//                       controller: entry.value,
//                       decoration: InputDecoration(
//                         labelText: _labelForKey(entry.key),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 10,
//                         ),
//                       ),
//                       keyboardType: entry.key == 'phone' || entry.key == 'zip'
//                           ? TextInputType.number
//                           : TextInputType.text,
//                     ),
//                   );
//                 }).toList(),
//                 const SizedBox(height: 24),

//                 // ---------------- Payment Method ----------------
//                 Text(
//                   'Payment Method',
//                   style: GoogleFonts.lato(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Container(
//                   height: 48,
//                   margin: const EdgeInsets.only(bottom: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(
//                       width: 1,
//                       color: const Color.fromARGB(255, 209, 208, 208),
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       // TODO: Open Stripe payment card input
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: [
//                           Icon(
//                             size: 24,
//                             Icons.payment,
//                             color: Colors.blueAccent,
//                           ),
//                           const SizedBox(width: 24),
//                           Expanded(
//                             child: Text(
//                               "Stripe",
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                                 color: Color(0xFF171A1F),
//                               ),
//                             ),
//                           ),
//                           const Icon(Icons.arrow_forward_ios, size: 16),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 RadioListTile(
//                   title: const Text('Cash on Delivery'),
//                   value: 'cod',
//                   groupValue: _selectedPaymentMethod,
//                   onChanged: (value) =>
//                       setState(() => _selectedPaymentMethod = value.toString()),
//                 ),
//                 const SizedBox(height: 24),

//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,

//                   child: ElevatedButton(

//                     onPressed: () async {
//                       // 1️⃣ Collect shipping address
//                       final shippingAddress = {
//                         'name': _addressControllers['name']!.text.trim(),
//                         'phone': _addressControllers['phone']!.text.trim(),
//                         'street': _addressControllers['street']!.text.trim(),
//                         'city': _addressControllers['city']!.text.trim(),
//                         'state': _addressControllers['state']!.text.trim(),
//                         'zip': _addressControllers['zip']!.text.trim(),
//                         'country': _addressControllers['country']!.text.trim(),
//                       };

//                       // Validate shipping fields
//                       if (shippingAddress.values.any((e) => e.isEmpty)) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Please fill all shipping fields"),
//                           ),
//                         );
//                         return;
//                       }

//                       try {
//                         final orderController = OrderController();

//                         // 2️⃣ Generate a unique order ID
//                         final orderId = FirebaseFirestore.instance
//                             .collection('orders')
//                             .doc()
//                             .id;

//                         // 3️⃣ Fetch auction details
//                         final auctionDoc = await FirebaseFirestore.instance
//                             .collection('auctions')
//                             .doc(widget.auctionId)
//                             .get();

//                         if (!auctionDoc.exists) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Auction not found")),
//                           );
//                           return;
//                         }

//                         final auctionData = auctionDoc.data()!;
//                         final sellerId = auctionData['sellerId'];
//                         final auctionModel = AuctionModel.fromFirestore(
//                           auctionData,
//                           widget.auctionId,
//                         );

//                         final buyerId = FirebaseAuth.instance.currentUser!.uid;
//                         // ✅ Define the current timestamp
//                         final Timestamp now = Timestamp.now();

//                         // 4️⃣ Place order using OrderController
//                         await orderController.placeOrder(
//                           orderId: orderId,
//                           auctionId: widget.auctionId,
//                           auctionType: auctionModel.type,
//                           buyerId: buyerId,
//                           sellerId: sellerId,
//                           price:
//                               auctionModel.currentBid ??
//                               auctionModel.startingBid,
//                           shippingAddress: shippingAddress,
//                         );

//                         // 5️⃣ Update auction as sold
//                         await FirebaseFirestore.instance
//                             .collection('auctions')
//                             .doc(widget.auctionId)
//                             .update({
//                               'sold': true,
//                               'buyerId': buyerId,
//                               'orderId': orderId,
//                               'status': 'sold',
//                               'soldAt': now,
//                               'paymentStatus': _selectedPaymentMethod == 'cod'
//                                   ? 'pending'
//                                   : 'paid',
//                               'paidAt': _selectedPaymentMethod == 'cod'
//                                   ? null
//                                   : now,
//                             });

//                         // 6️⃣ Notify seller
//                         await FirebaseFirestore.instance
//                             .collection('notifications')
//                             .add({
//                               'userId': sellerId,
//                               'type': 'order',
//                               'title': 'Auction Sold',
//                               'message':
//                                   'Your auction "${auctionModel.title}" has been sold for \$${(auctionModel.currentBid ?? auctionModel.startingBid).toStringAsFixed(2)}!',
//                               'read': false,
//                               'createdAt': Timestamp.now(),
//                             });

//                         // 7️⃣ Show success snackbar
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Order placed successfully!"),
//                           ),
//                         );

//                         // 8️⃣ Navigate to Order Summary screen
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => OrderSummaryScreen(
//                               orderId: orderId,
//                               auction: auctionModel,
//                               shippingAddress: shippingAddress,
//                               paymentMethod: _selectedPaymentMethod,
//                               price:
//                                   auctionModel.currentBid ??
//                                   auctionModel.startingBid,
//                             ),
//                           ),
//                         );
//                       } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("Error: ${e.toString()}")),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepPurpleAccent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text(
//                       'Place Order',
//                       style: GoogleFonts.lato(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _priceRow(String label, double amount, {bool isTotal = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.lato(
//               fontSize: isTotal ? 16 : 14,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           Text(
//             '\$${amount.toStringAsFixed(2)}',
//             style: GoogleFonts.lato(
//               fontSize: isTotal ? 16 : 14,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               color: isTotal ? Colors.deepPurpleAccent : Colors.black,
//             ),
//           ),
//         ],
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
import 'package:auctify/models/auction_model.dart';
import 'package:auctify/screens/order/order_summary.dart';
import 'package:auctify/utils/custom_appbar.dart';
import 'package:auctify/utils/notification_Icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class CheckoutScreen extends StatefulWidget {
  final String auctionId;

  const CheckoutScreen({super.key, required this.auctionId});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'card';

  final Map<String, TextEditingController> _addressControllers = {
    'email': TextEditingController(),
    'name': TextEditingController(),
    'phone': TextEditingController(),
    'street': TextEditingController(),
    'city': TextEditingController(),
    'state': TextEditingController(),
    'zip': TextEditingController(),
    'country': TextEditingController(),
  };

  Future<void> sendOrderEmail({
    required String recipientEmail,
    required String buyerName,
    required String productName,
    required double price,
  }) async {
    // ⚠️ Use Gmail App Password if 2FA is enabled
    final smtpServer = gmail(
      'lakshmipooja724@gmail.com',
      'ueyv loxn gzhn jeom',
    );

    final message = Message()
      ..from = Address('your_email@gmail.com', 'Auctify')
      ..recipients.add(recipientEmail)
      ..subject = 'Your Order Confirmation for $productName'
      ..text =
          '''
Hi $buyerName,

Thank you for your purchase!

Product: $productName
Price: \$${price.toStringAsFixed(2)}

Your order will be processed shortly.

- Auctify Team
  ''';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "CheckOut",
        actions: [NotificationIcon(), SizedBox(width: 5)],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('auctions')
            .doc(widget.auctionId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final auctionData = snapshot.data!.data() as Map<String, dynamic>?;

          if (auctionData == null) {
            return const Center(child: Text('Auction not found'));
          }

          final bool isSold = auctionData['sold'] ?? false;
          final String title = auctionData['title'] ?? "Auction";
          final double price = (auctionData['currentBid'] ?? 0).toDouble();
          final List images = auctionData['imageUrls'] ?? [];
          final String imageUrl = images.isNotEmpty ? images.first : "";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- Product Summary ----------------
                Text(
                  'Order Summary',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                                image: imageUrl.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: imageUrl.isEmpty
                                  ? const Icon(
                                      Icons.gavel,
                                      size: 40,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\$${price.toStringAsFixed(2)}',
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, color: Colors.grey),

                        //  _priceRow('Delivery Charges', deliveryCharges),
                        // _priceRow('Tax', tax),
                        const SizedBox(height: 12),
                        _priceRow('Total', price, isTotal: true),
                        const SizedBox(height: 12),
                        Text(
                          'Note: Delivery will be arranged directly between you and the seller.',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ---------------- Shipping Address ----------------
                Text(
                  'Shipping Address',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Email Field (Explicitly placed first)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextField(
                    controller: _addressControllers['email'],
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),

                ..._addressControllers.entries
                    .where((e) => e.key != 'email')
                    .map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            labelText: _labelForKey(entry.key),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          keyboardType:
                              entry.key == 'phone' || entry.key == 'zip'
                              ? TextInputType.number
                              : TextInputType.text,
                          enabled: !isSold, // disable if sold
                        ),
                      );
                    })
                    .toList(),
                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isSold
                        ? null
                        : () async {
                            // 1️⃣ Collect shipping address

                            final shippingAddress = {
                              'email': _addressControllers['email']!.text
                                  .trim(),
                              'name': _addressControllers['name']!.text.trim(),
                              'phone': _addressControllers['phone']!.text
                                  .trim(),
                              'street': _addressControllers['street']!.text
                                  .trim(),
                              'city': _addressControllers['city']!.text.trim(),
                              'state': _addressControllers['state']!.text
                                  .trim(),
                              'zip': _addressControllers['zip']!.text.trim(),
                              'country': _addressControllers['country']!.text
                                  .trim(),
                            };

                            // Validate shipping fields
                            if (shippingAddress.values.any((e) => e.isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please fill all shipping fields",
                                  ),
                                ),
                              );
                              return;
                            }

                            // Validate Email
                            final emailRegex = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            );
                            if (!emailRegex.hasMatch(
                              shippingAddress['email']!,
                            )) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter a valid email address",
                                  ),
                                ),
                              );
                              return;
                            }

                            try {
                              final orderController = OrderController();

                              // Generate unique order ID
                              final orderId = FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc()
                                  .id;

                              // Fetch auction details
                              final auctionDoc = await FirebaseFirestore
                                  .instance
                                  .collection('auctions')
                                  .doc(widget.auctionId)
                                  .get();

                              if (!auctionDoc.exists ||
                                  (auctionDoc.data()?['sold'] ?? false)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Auction already sold"),
                                  ),
                                );
                                return;
                              }

                              final auctionData = auctionDoc.data()!;
                              final sellerId = auctionData['sellerId'];
                              final auctionModel = AuctionModel.fromFirestore(
                                auctionData,
                                widget.auctionId,
                              );

                              final buyerId =
                                  FirebaseAuth.instance.currentUser!.uid;
                              final Timestamp now = Timestamp.now();

                              // Determine payment status
                              final paymentStatus =
                                  _selectedPaymentMethod == 'cod'
                                  ? 'pending'
                                  : 'paid';

                              // Place order
                              await orderController.placeOrder(
                                orderId: orderId,
                                auctionId: widget.auctionId,
                                auctionType: auctionModel.type,
                                buyerId: buyerId,
                                sellerId: sellerId,
                                price:
                                    auctionModel.currentBid ??
                                    auctionModel.startingBid,
                                shippingAddress: shippingAddress,
                                paymentStatus: paymentStatus,
                                email: shippingAddress['email']!,
                                productName: auctionModel.title,
                              );

                              // Update auction as sold
                              await FirebaseFirestore.instance
                                  .collection('auctions')
                                  .doc(widget.auctionId)
                                  .update({
                                    'sold': true,
                                    'buyerId': buyerId,
                                    'orderId': orderId,
                                    'status': 'sold',
                                    'soldAt': now,
                                    'paymentStatus':
                                        paymentStatus, // ✅ match order
                                    'paidAt': _selectedPaymentMethod == 'cod'
                                        ? null
                                        : now,
                                  });

                              // Notify seller
                              await FirebaseFirestore.instance
                                  .collection('notifications')
                                  .add({
                                    'userId': sellerId,
                                    'type': 'order',
                                    'title': 'Auction Sold',
                                    'message':
                                        'Your auction "${auctionModel.title}" has been sold for \$${(auctionModel.currentBid ?? auctionModel.startingBid).toStringAsFixed(2)}!',
                                    'read': false,
                                    'createdAt': Timestamp.now(),
                                  });

                              // Success snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Order placed successfully!"),
                                ),
                              );
                              // Send confirmation email
                              await sendOrderEmail(
                                recipientEmail: shippingAddress['email']!,
                                buyerName: shippingAddress['name']!,
                                productName: auctionModel.title,
                                price:
                                    auctionModel.currentBid ??
                                    auctionModel.startingBid,
                              );

                              // Navigate to Order Summary
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderSummaryScreen(
                                    orderId: orderId,
                                    auction: auctionModel,
                                    shippingAddress: shippingAddress,
                                    paymentMethod: _selectedPaymentMethod,
                                    price:
                                        auctionModel.currentBid ??
                                        auctionModel.startingBid,
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error: ${e.toString()}"),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSold
                          ? Colors.grey
                          : Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isSold ? 'Sold Out' : 'Place Order',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _priceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: GoogleFonts.lato(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.deepPurpleAccent : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _labelForKey(String key) {
    switch (key) {
      case 'email':
        return 'Email Address';
      case 'name':
        return 'Full Name';
      case 'phone':
        return 'Phone Number';
      case 'street':
        return 'Street';
      case 'city':
        return 'City';
      case 'state':
        return 'State';
      case 'zip':
        return 'ZIP Code';
      case 'country':
        return 'Country';
      default:
        return key;
    }
  }
}
