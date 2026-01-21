// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:auctify/utils/constants.dart';

// class PaymentScreen extends StatefulWidget {
//   final String productName;
//   final String productImage;
//   final double amount;

//   const PaymentScreen({
//     super.key,
//     required this.productName,
//     required this.productImage,
//     required this.amount,
//   });

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   bool isChecked = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: AppBar(title: const Text("Payment"), centerTitle: true),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// 🔒 Secure Payment
//             Row(
//               children: [
//                 const Icon(Icons.lock, size: 18, color: AppColors.success),
//                 const SizedBox(width: 6),
//                 Text(
//                   "Secure Payment",
//                   style: GoogleFonts.lato(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.success,
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             /// 📦 Order Summary
//             _orderSummary(),

//             const SizedBox(height: 24),

//             /// 📍 Delivery Address
//             Text(
//               "Address Detail",
//               style: GoogleFonts.lato(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 12),
//             _addressSection(),

//             const SizedBox(height: 24),

//             /// 💳 Payment Method
//             Text(
//               "Payment Method",
//               style: GoogleFonts.lato(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 12),

//             _paymentMethodTile(
//               context: context,
//               icon: Icons.credit_card,
//               title: "Credit / Debit Card",
//               subtitle: "Visa, MasterCard, Amex",
//               onTap: () => _showCardDialog(context),
//             ),

//             const SizedBox(height: 10),

//             _paymentMethodTile(
//               context: context,
//               icon: Icons.account_balance_wallet_outlined,
//               title: "Wallet",
//               subtitle: "Pay using wallet balance",
//               onTap: () {},
//             ),

//             const SizedBox(height: 10),

//             Card(
//               child: ListTile(
//                 leading: Icon(
//                   Icons.payments_outlined,
//                   color: AppColors.primary,
//                 ),
//                 title: Text(
//                   "Cash On Delevery(COD)",
//                   style: GoogleFonts.lato(
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 subtitle: Text(
//                   "Pay when item is delivered",
//                   style: GoogleFonts.lato(
//                     fontSize: 13,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//                 trailing: Checkbox(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadiusGeometry.circular(12),
//                   ),
//                   activeColor: AppColors.primary,
//                   value: isChecked,
//                   onChanged: (value) {
//                     setState(() {
//                       isChecked = value!;
//                     });
//                   },
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             /// 💰 Pay Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.accent,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 child: Text(
//                   "Pay \$${widget.amount.toStringAsFixed(2)}",
//                   style: GoogleFonts.lato(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 📦 Order Summary Card
//   Widget _orderSummary() {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 310,
//               width: double.infinity,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   widget.productImage,
//                   height: 300,
//                   width: 200,
//                   fit: BoxFit.fitHeight,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 14),
//             Text(
//               widget.productName,
//               style: GoogleFonts.lato(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "Winning Bid",
//               style: GoogleFonts.lato(
//                 fontSize: 14,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               "\$${widget.amount.toStringAsFixed(2)}",
//               style: GoogleFonts.lato(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 📍 Address Section
//   Widget _addressSection() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: AppColors.primary),
//                   borderRadius: BorderRadius.circular(12),
//                 ),

//                 hintText: "John Doe",
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: AppColors.primary),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 hintText: "Delivery Address",
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: AppColors.primary),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 hintText: "John Doe",
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextFormField(
//               keyboardType: TextInputType.numberWithOptions(),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: AppColors.primary),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 hintText: "+92 300 1234567",
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: AppColors.primary),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 hintText: "City",
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: AppColors.primary),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 hintText: "Postal Code",
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 💳 Payment Method Tile
//   Widget _paymentMethodTile({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: ListTile(
//         onTap: onTap,
//         leading: Icon(icon, color: AppColors.primary),
//         title: Text(
//           title,
//           style: GoogleFonts.lato(
//             fontWeight: FontWeight.w600,
//             color: AppColors.textPrimary,
//           ),
//         ),
//         subtitle: Text(
//           subtitle,
//           style: GoogleFonts.lato(fontSize: 13, color: AppColors.textSecondary),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       ),
//     );
//   }

//   /// 💳 Card Payment Dialog
//   void _showCardDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: const Text("Enter Card Details"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _dialogField("Card Number", "1234 5678 9012 3456"),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(child: _dialogField("Expiry", "MM/YY")),
//                   const SizedBox(width: 10),
//                   Expanded(child: _dialogField("CVV", "***")),
//                 ],
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Confirm"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _dialogField(String label, String hint) {
//     return TextField(
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }

import 'package:auctify/controllers/payment_controller.dart';
import 'package:auctify/utils/custom_appbar.dart';
import 'package:auctify/utils/notification_Icon.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentScreen extends StatefulWidget {
  final String orderId;
  final String auctionId;
  final String sellerId;
  final double amount;

  const PaymentScreen({
    Key? key,
    required this.orderId,
    required this.auctionId,
    required this.sellerId,
    required this.amount,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final PaymentController _paymentController = PaymentController();

  // Shipping address fields
  final Map<String, String> _shippingAddress = {
    'name': '',
    'phone': '',
    'street': '',
    'city': '',
    'state': '',
    'zip': '',
    'country': '',
  };

  String _selectedPaymentMethod = 'card';
  bool _isLoading = false;

  void _payNow() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      final paymentId = DateTime.now().millisecondsSinceEpoch
          .toString(); // simple unique ID
      await _paymentController.makePayment(
        paymentId: paymentId,
        orderId: widget.orderId,
        auctionId: widget.auctionId,
        buyerId: FirebaseFirestore
            .instance
            .app
            .options
            .appId, // optional: replace with current user ID
        sellerId: widget.sellerId,
        amount: widget.amount,
        method: _selectedPaymentMethod,
        transactionId: paymentId,
      );

      // Save shipping address in the order
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .update({'shippingAddress': _shippingAddress});

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payment successful!')));

      // Navigate to order confirmation or home
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTextField(
    String label,
    String key, {
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      keyboardType: type,
      decoration: InputDecoration(labelText: label),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Required' : null,
      onSaved: (value) => _shippingAddress[key] = value!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Payment",

        actions: [NotificationIcon(), SizedBox(width: 5)],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Summary'),
                    const SizedBox(height: 8),
                    Text('Amount: \$${widget.amount.toStringAsFixed(2)}'),
                    const Divider(height: 32),

                    Text('Shipping Address'),
                    const SizedBox(height: 8),
                    _buildTextField('Full Name', 'name'),
                    _buildTextField(
                      'Phone Number',
                      'phone',
                      type: TextInputType.phone,
                    ),
                    _buildTextField('Street', 'street'),
                    _buildTextField('City', 'city'),
                    _buildTextField('State', 'state'),
                    _buildTextField(
                      'ZIP Code',
                      'zip',
                      type: TextInputType.number,
                    ),
                    _buildTextField('Country', 'country'),
                    const Divider(height: 32),

                    Text('Payment Method'),
                    RadioListTile(
                      title: const Text('Card'),
                      value: 'card',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) => setState(
                        () => _selectedPaymentMethod = value.toString(),
                      ),
                    ),
                    RadioListTile(
                      title: const Text('Cash on Delivery'),
                      value: 'cod',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) => setState(
                        () => _selectedPaymentMethod = value.toString(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _payNow,
                        child: const Text('Pay Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
