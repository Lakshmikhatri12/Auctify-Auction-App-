import 'package:auctify/controllers/order_controller.dart';
import 'package:auctify/layout/layout.dart';
import 'package:auctify/models/auction_model.dart';
import 'package:auctify/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderSummaryScreen extends StatefulWidget {
  final String orderId;
  final AuctionModel auction;
  final Map<String, dynamic> shippingAddress;
  final String paymentMethod;
  final double price;
  final bool isSeller;
  final String initialStatus;

  const OrderSummaryScreen({
    super.key,
    required this.orderId,
    required this.auction,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.price,
    this.isSeller = false,
    this.initialStatus = 'placed',
  });

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late String _currentStatus;
  final OrderController _orderController = OrderController();

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.initialStatus;
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _currentStatus = newStatus;
    });
    _orderController.updateOrderStatus(widget.orderId, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.isSeller) {
              Navigator.pop(context);
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Layout()),
                (route) => false,
              );
            }
          },
        ),
        title: Text(
          widget.isSeller ? "Order Details" : "Order Placed",
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // -------- Buyer Success Section --------
            if (!widget.isSeller) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Thank You for Your Order!",
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Order #${widget.orderId}",
                style: GoogleFonts.lato(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 30),
            ],

            // -------- Order Timeline --------
            _buildTimeline(context, _currentStatus),
            const SizedBox(height: 30),

            // -------- Seller Status Control --------
            if (widget.isSeller) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Update Order Status",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _currentStatus,
                      items: ['placed', 'confirmed', 'shipped', 'delivered']
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) _updateStatus(val);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],

            // -------- Order Details Card --------
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Summary",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 30),

                  // Item Row
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: widget.auction.imageUrls.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(
                                    widget.auction.imageUrls.first,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.auction.title,
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Sold by ${widget.auction.sellerName}",
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "\$${widget.price.toStringAsFixed(2)}",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 30),

                  // Shipping Info
                  Text(
                    "Shipping Address",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${widget.shippingAddress['name']}\n"
                    "${widget.shippingAddress['street']}, ${widget.shippingAddress['city']}\n"
                    "${widget.shippingAddress['state']}, ${widget.shippingAddress['zip']}\n"
                    "${widget.shippingAddress['country']}",
                    style: GoogleFonts.lato(height: 1.4),
                  ),

                  const Divider(height: 30),

                  // Final Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Final Auction Price",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${widget.price.toStringAsFixed(2)}",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Delivery and payment will be handled directly through in-app chat.",
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // -------- Buyer Action --------
            if (!widget.isSeller)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Layout()),
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Continue Shopping",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // -------- Timeline Widgets --------

  Widget _buildTimeline(BuildContext context, String status) {
    int step =
        [
          'placed',
          'confirmed',
          'shipped',
          'delivered',
        ].indexOf(status.toLowerCase()) +
        1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _step("Placed", step >= 1),
        _line(step > 1),
        _step("Confirmed", step >= 2),
        _line(step > 2),
        _step("Shipped", step >= 3),
        _line(step > 3),
        _step("Delivered", step >= 4),
      ],
    );
  }

  Widget _step(String label, bool active) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: active ? AppColors.primary : Colors.grey.shade300,
          child: active
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 10,
            color: active ? AppColors.primary : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _line(bool active) {
    return Container(
      width: 28,
      height: 2,
      color: active ? AppColors.primary : Colors.grey.shade300,
      margin: const EdgeInsets.only(bottom: 22),
    );
  }
}

// import 'package:auctify/controllers/order_controller.dart';
// import 'package:auctify/layout/layout.dart';
// import 'package:auctify/models/auction_model.dart';
// import 'package:auctify/screens/order/order_history.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class OrderSummaryScreen extends StatefulWidget {
//   final String orderId;
//   final AuctionModel auction;
//   final Map<String, dynamic> shippingAddress;
//   final String paymentMethod;
//   final double price;
//   final bool isSeller;
//   final String initialStatus;

//   const OrderSummaryScreen({
//     super.key,
//     required this.orderId,
//     required this.auction,
//     required this.shippingAddress,
//     required this.paymentMethod,
//     required this.price,
//     this.isSeller = false,
//     this.initialStatus = 'placed',
//   });

//   @override
//   State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
// }

// class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
//   late String _currentStatus;
//   final OrderController _orderController = OrderController();

//   @override
//   void initState() {
//     super.initState();
//     _currentStatus = widget.initialStatus;
//   }

//   void _updateStatus(String newStatus) {
//     setState(() {
//       _currentStatus = newStatus;
//     });
//     _orderController.updateOrderStatus(widget.orderId, newStatus);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final deliveryCharges = 10.0;
//     final tax = 5.0;
//     final total = widget.price + deliveryCharges + tax;

//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             if (widget.isSeller) {
//               Navigator.pop(context);
//             } else {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (context) => const Layout()),
//                 (route) => false,
//               );
//             }
//           },
//         ),
//         title: Text(
//           widget.isSeller ? "Order Details" : "Order Placed",
//           style: GoogleFonts.lato(
//             fontWeight: FontWeight.bold,
//             color: theme.textTheme.titleLarge?.color,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           children: [
//             // ---------------- Success Icon (Buyer Only) ----------------
//             if (!widget.isSeller) ...[
//               const SizedBox(height: 20),
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.check_circle,
//                   color: Colors.green,
//                   size: 60,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 "Thank You for Your Order!",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.lato(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: theme.textTheme.titleLarge?.color,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Order #${widget.orderId}",
//                 style: GoogleFonts.lato(fontSize: 14, color: Colors.grey),
//               ),
//               const SizedBox(height: 30),
//             ] else ...[
//               const SizedBox(height: 20),
//             ],

//             // ---------------- Timeline ----------------
//             _buildTimeline(context, _currentStatus), // Updated dynamically
//             const SizedBox(height: 30),

//             // ---------------- Seller Controls ----------------
//             if (widget.isSeller) ...[
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: theme.cardTheme.color,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.primary.withOpacity(0.3)),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Update Status",
//                       style: GoogleFonts.lato(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: theme.primaryColor,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     DropdownButtonFormField<String>(
//                       value: _currentStatus,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                       ),
//                       items: ['placed', 'confirmed', 'shipped', 'delivered']
//                           .map(
//                             (status) => DropdownMenuItem(
//                               value: status,
//                               child: Text(status.toUpperCase()),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (val) {
//                         if (val != null) _updateStatus(val);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),
//             ],

//             // ---------------- Receipt Card ----------------
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: theme.cardTheme.color,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Order Details",
//                         style: GoogleFonts.lato(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: theme.textTheme.titleMedium?.color,
//                         ),
//                       ),
//                       if (widget.isSeller)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: AppColors.primary.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             "Sale",
//                             style: GoogleFonts.lato(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                   const Divider(height: 30),

//                   // Item Info
//                   Row(
//                     children: [
//                       Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.grey.shade200,
//                           image: widget.auction.imageUrls.isNotEmpty
//                               ? DecorationImage(
//                                   image: NetworkImage(
//                                     widget.auction.imageUrls.first,
//                                   ),
//                                   fit: BoxFit.cover,
//                                 )
//                               : null,
//                         ),
//                       ),
//                       const SizedBox(width: 14),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.auction.title,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.lato(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: theme.textTheme.titleMedium?.color,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "Sold by ${widget.auction.sellerName}",
//                               style: GoogleFonts.lato(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Text(
//                         "\$${widget.price.toStringAsFixed(2)}",
//                         style: GoogleFonts.lato(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: theme.textTheme.titleMedium?.color,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   // Shipping Info
//                   Text(
//                     "Shipping To",
//                     style: GoogleFonts.lato(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Container(
//                     width: double.infinity,
//                     padding: widget.isSeller
//                         ? const EdgeInsets.all(12)
//                         : EdgeInsets.zero,
//                     decoration: widget.isSeller
//                         ? BoxDecoration(
//                             color: Colors.orange.withOpacity(0.05),
//                             border: Border.all(
//                               color: Colors.orange.withOpacity(0.3),
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                           )
//                         : null,
//                     child: Text(
//                       "${widget.shippingAddress['name']}\n"
//                       "${widget.shippingAddress['street']}, ${widget.shippingAddress['city']}\n"
//                       "${widget.shippingAddress['state']}, ${widget.shippingAddress['zip']}\n"
//                       "${widget.shippingAddress['country']}",
//                       style: GoogleFonts.lato(
//                         fontSize: 14,
//                         height: 1.4,
//                         color: theme.textTheme.bodyMedium?.color,
//                       ),
//                     ),
//                   ),
//                   const Divider(height: 30),

//                   // // Payment Info
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //   children: [
//                   //     Text(
//                   //       "Payment Method",
//                   //       style: GoogleFonts.lato(
//                   //         fontSize: 14,
//                   //         fontWeight: FontWeight.bold,
//                   //         color: Colors.grey.shade600,
//                   //       ),
//                   //     ),
//                   //     Text(
//                   //       widget.paymentMethod == 'cod'
//                   //           ? 'Cash on Delivery'
//                   //           : 'Paid Online',
//                   //       style: GoogleFonts.lato(
//                   //         fontSize: 14,
//                   //         fontWeight: FontWeight.w600,
//                   //         color: theme.textTheme.bodyMedium?.color,
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//                   const SizedBox(height: 12),

//                   // Totals
//                   _buildPriceRow("Subtotal", widget.price, theme),

//                   const Divider(height: 24),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Total",
//                         style: GoogleFonts.lato(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: theme.textTheme.titleLarge?.color,
//                         ),
//                       ),
//                       Text(
//                         "\$${total.toStringAsFixed(2)}",
//                         style: GoogleFonts.lato(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.deepPurpleAccent,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),

//             // ---------------- Action Buttons (Buyer Only) ----------------
//             if (!widget.isSeller) ...[
//               const SizedBox(height: 16),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(builder: (context) => const Layout()),
//                       (route) => false,
//                     );
//                   },
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: theme.primaryColor),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: Text(
//                     "Continue Shopping",
//                     style: GoogleFonts.lato(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: theme.primaryColor,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPriceRow(String label, double amount, ThemeData theme) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600),
//           ),
//           Text(
//             "\$${amount.toStringAsFixed(2)}",
//             style: GoogleFonts.lato(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: theme.textTheme.bodyMedium?.color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimeline(BuildContext context, String status) {
//     final theme = Theme.of(context);

//     // Status Logic
//     int currentStep = 0;
//     switch (status.toLowerCase()) {
//       case 'placed':
//         currentStep = 1;
//         break;
//       case 'confirmed':
//         currentStep = 2;
//         break;
//       case 'shipped':
//         currentStep = 3;
//         break;
//       case 'delivered':
//         currentStep = 4;
//         break;
//       default:
//         currentStep = 1;
//     }

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _buildTimelineStep(
//           context,
//           "Placed",
//           currentStep >= 1,
//           currentStep > 1,
//         ),
//         _buildTimelineLine(context, currentStep > 1),
//         _buildTimelineStep(
//           context,
//           "Confirmed",
//           currentStep >= 2,
//           currentStep > 2,
//         ),
//         _buildTimelineLine(context, currentStep > 2),
//         _buildTimelineStep(
//           context,
//           "Shipped",
//           currentStep >= 3,
//           currentStep > 3,
//         ),
//         _buildTimelineLine(context, currentStep > 3),
//         _buildTimelineStep(
//           context,
//           "Delivered",
//           currentStep >= 4,
//           currentStep > 4,
//         ),
//       ],
//     );
//   }

//   Widget _buildTimelineStep(
//     BuildContext context,
//     String label,
//     bool isActive,
//     bool isCompleted,
//   ) {
//     final theme = Theme.of(context);
//     return Column(
//       children: [
//         Container(
//           width: 30,
//           height: 30,
//           decoration: BoxDecoration(
//             color: isActive
//                 ? theme.primaryColor
//                 : (isCompleted ? theme.primaryColor : Colors.grey.shade300),
//             shape: BoxShape.circle,
//             border: isActive
//                 ? Border.all(color: theme.primaryColor, width: 2)
//                 : null,
//           ),
//           child: Center(
//             child: isCompleted
//                 ? const Icon(Icons.check, size: 16, color: Colors.white)
//                 : const SizedBox(),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: GoogleFonts.lato(
//             fontSize: 10,
//             color: isActive ? theme.primaryColor : Colors.grey,
//             fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTimelineLine(BuildContext context, bool isActive) {
//     return Container(
//       width: 30,
//       height: 2,
//       color: isActive ? Theme.of(context).primaryColor : Colors.grey.shade300,
//       margin: const EdgeInsets.symmetric(
//         horizontal: 4,
//         vertical: 15,
//       ).copyWith(bottom: 25), // Adjust based on text height
//     );
//   }
// }

// // import 'package:auctify/controllers/order_controller.dart';
// // import 'package:auctify/controllers/user_controller.dart';
// // import 'package:auctify/layout/layout.dart';
// // import 'package:auctify/models/auction_model.dart';
// // import 'package:auctify/screens/order/order_history.dart';
// // import 'package:auctify/screens/raise_dispute_screen.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // class OrderSummaryScreen extends StatefulWidget {
// //   final String orderId;
// //   final AuctionModel auction;
// //   final Map<String, dynamic> shippingAddress;
// //   final String paymentMethod;
// //   final double price;
// //   final bool isSeller;
// //   final String initialStatus;

// //   const OrderSummaryScreen({
// //     super.key,
// //     required this.orderId,
// //     required this.auction,
// //     required this.shippingAddress,
// //     required this.paymentMethod,
// //     required this.price,
// //     this.isSeller = false,
// //     this.initialStatus = 'placed',
// //   });

// //   @override
// //   State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
// // }

// // class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
// //   late String _currentStatus;
// //   final OrderController _orderController = OrderController();
// //   final UserController _userController = UserController();

// //   // Dispute info
// //   String? disputeStatus;
// //   String? disputeId;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _currentStatus = widget.initialStatus;

// //     // Load dispute if exists
// //     FirebaseFirestore.instance
// //         .collection('disputes')
// //         .where('orderId', isEqualTo: widget.orderId)
// //         .limit(1)
// //         .get()
// //         .then((snapshot) {
// //           if (snapshot.docs.isNotEmpty) {
// //             setState(() {
// //               disputeId = snapshot.docs.first.id;
// //               disputeStatus = snapshot.docs.first['status'];
// //             });
// //           }
// //         });
// //   }

// //   void _updateStatus(String newStatus) {
// //     setState(() {
// //       _currentStatus = newStatus;
// //     });
// //     _orderController.updateOrderStatus(widget.orderId, newStatus);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final theme = Theme.of(context);
// //     final deliveryCharges = 10.0;
// //     final tax = 5.0;
// //     final total = widget.price + deliveryCharges + tax;

// //     return Scaffold(
// //       backgroundColor: theme.scaffoldBackgroundColor,
// //       appBar: AppBar(
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back),
// //           onPressed: () {
// //             if (widget.isSeller) {
// //               Navigator.pop(context);
// //             } else {
// //               Navigator.pushAndRemoveUntil(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => const Layout()),
// //                 (route) => false,
// //               );
// //             }
// //           },
// //         ),
// //         title: Text(
// //           widget.isSeller ? "Order Details" : "Order Placed",
// //           style: GoogleFonts.lato(
// //             fontWeight: FontWeight.bold,
// //             color: theme.textTheme.titleLarge?.color,
// //           ),
// //         ),
// //         centerTitle: true,
// //         elevation: 0,
// //         backgroundColor: Colors.transparent,
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //         child: Column(
// //           children: [
// //             // ---------------- Success Icon (Buyer Only) ----------------
// //             if (!widget.isSeller) ...[
// //               const SizedBox(height: 20),
// //               Container(
// //                 padding: const EdgeInsets.all(20),
// //                 decoration: BoxDecoration(
// //                   color: Colors.green.withOpacity(0.1),
// //                   shape: BoxShape.circle,
// //                 ),
// //                 child: const Icon(
// //                   Icons.check_circle,
// //                   color: Colors.green,
// //                   size: 60,
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //               Text(
// //                 "Thank You for Your Order!",
// //                 textAlign: TextAlign.center,
// //                 style: GoogleFonts.lato(
// //                   fontSize: 24,
// //                   fontWeight: FontWeight.bold,
// //                   color: theme.textTheme.titleLarge?.color,
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               Text(
// //                 "Order #${widget.orderId}",
// //                 style: GoogleFonts.lato(fontSize: 14, color: Colors.grey),
// //               ),
// //               const SizedBox(height: 30),
// //             ] else ...[
// //               const SizedBox(height: 20),
// //             ],

// //             // ---------------- Timeline ----------------
// //             _buildTimeline(context, _currentStatus),
// //             const SizedBox(height: 30),

// //             // ---------------- Seller Controls ----------------
// //             if (widget.isSeller) ...[
// //               Container(
// //                 width: double.infinity,
// //                 padding: const EdgeInsets.all(16),
// //                 decoration: BoxDecoration(
// //                   color: theme.cardTheme.color,
// //                   borderRadius: BorderRadius.circular(12),
// //                   border: Border.all(
// //                     color: theme.primaryColor.withOpacity(0.3),
// //                   ),
// //                 ),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       "Update Status",
// //                       style: GoogleFonts.lato(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                         color: theme.primaryColor,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 12),
// //                     DropdownButtonFormField<String>(
// //                       value: _currentStatus,
// //                       decoration: const InputDecoration(
// //                         border: OutlineInputBorder(),
// //                         contentPadding: EdgeInsets.symmetric(
// //                           horizontal: 12,
// //                           vertical: 8,
// //                         ),
// //                       ),
// //                       items: ['placed', 'confirmed', 'shipped', 'delivered']
// //                           .map(
// //                             (status) => DropdownMenuItem(
// //                               value: status,
// //                               child: Text(status.toUpperCase()),
// //                             ),
// //                           )
// //                           .toList(),
// //                       onChanged: (val) {
// //                         if (val != null) _updateStatus(val);
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 30),
// //             ],

// //             // ---------------- Receipt Card ----------------
// //             _buildReceiptCard(theme, deliveryCharges, tax, total),

// //             const SizedBox(height: 30),

// //             // ---------------- Action Buttons (Buyer Only) ----------------
// //             // Buyer-only actions
// //             if (!widget.isSeller) ...[
// //               if (_currentStatus == 'shipped' || _currentStatus == 'delivered')
// //                 SizedBox(
// //                   width: double.infinity,
// //                   height: 50,
// //                   child: ElevatedButton.icon(
// //                     icon: const Icon(Icons.report_problem),
// //                     label: Text(
// //                       disputeStatus == null
// //                           ? "Report an Issue"
// //                           : "View Dispute",
// //                       style: const TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.redAccent,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                     onPressed: () async {
// //                       final currentUser = await _userController
// //                           .getCurrentUser();
// //                       if (currentUser == null) {
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           const SnackBar(
// //                             content: Text(
// //                               "You must be logged in to raise a dispute.",
// //                             ),
// //                           ),
// //                         );
// //                         return;
// //                       }

// //                       if (disputeStatus == null) {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (_) => RaiseDisputeScreen(
// //                               orderId: widget.orderId,
// //                               buyerId: currentUser.uid, // ✅ current user
// //                               sellerId: widget
// //                                   .auction
// //                                   .sellerId, // make sure AuctionModel has sellerId
// //                             ),
// //                           ),
// //                         );
// //                       } else {
// //                         showDialog(
// //                           context: context,
// //                           builder: (_) => AlertDialog(
// //                             title: const Text("Dispute Status"),
// //                             content: Text(
// //                               "Your dispute is currently: $disputeStatus",
// //                             ),
// //                             actions: [
// //                               TextButton(
// //                                 onPressed: () => Navigator.pop(context),
// //                                 child: const Text("Close"),
// //                               ),
// //                             ],
// //                           ),
// //                         );
// //                       }
// //                     },
// //                   ),
// //                 ),
// //               const SizedBox(height: 16),

// //               // Continue Shopping
// //               SizedBox(
// //                 width: double.infinity,
// //                 height: 50,
// //                 child: OutlinedButton(
// //                   onPressed: () {
// //                     Navigator.pushAndRemoveUntil(
// //                       context,
// //                       MaterialPageRoute(builder: (context) => const Layout()),
// //                       (route) => false,
// //                     );
// //                   },
// //                   style: OutlinedButton.styleFrom(
// //                     side: BorderSide(color: theme.primaryColor),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                   ),
// //                   child: Text(
// //                     "Continue Shopping",
// //                     style: GoogleFonts.lato(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: theme.primaryColor,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //             const SizedBox(height: 30),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ------------------- Helper Methods -------------------

// //   Widget _buildReceiptCard(
// //     ThemeData theme,
// //     double delivery,
// //     double tax,
// //     double total,
// //   ) {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: theme.cardTheme.color,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Text(
// //                 "Order Details",
// //                 style: GoogleFonts.lato(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: theme.textTheme.titleMedium?.color,
// //                 ),
// //               ),
// //               if (widget.isSeller)
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 8,
// //                     vertical: 4,
// //                   ),
// //                   decoration: BoxDecoration(
// //                     color: Colors.deepPurpleAccent.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: Text(
// //                     "Sale",
// //                     style: GoogleFonts.lato(
// //                       fontSize: 12,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.deepPurpleAccent,
// //                     ),
// //                   ),
// //                 ),
// //             ],
// //           ),
// //           const Divider(height: 30),
// //           Row(
// //             children: [
// //               Container(
// //                 width: 60,
// //                 height: 60,
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(8),
// //                   color: Colors.grey.shade200,
// //                   image: widget.auction.imageUrls.isNotEmpty
// //                       ? DecorationImage(
// //                           image: NetworkImage(widget.auction.imageUrls.first),
// //                           fit: BoxFit.cover,
// //                         )
// //                       : null,
// //                 ),
// //               ),
// //               const SizedBox(width: 14),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       widget.auction.title,
// //                       maxLines: 2,
// //                       overflow: TextOverflow.ellipsis,
// //                       style: GoogleFonts.lato(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w600,
// //                         color: theme.textTheme.titleMedium?.color,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       "Sold by ${widget.auction.sellerName}",
// //                       style: GoogleFonts.lato(fontSize: 12, color: Colors.grey),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               Text(
// //                 "\$${widget.price.toStringAsFixed(2)}",
// //                 style: GoogleFonts.lato(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                   color: theme.textTheme.titleMedium?.color,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 20),
// //           Text(
// //             "Shipping To",
// //             style: GoogleFonts.lato(
// //               fontSize: 14,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.grey.shade600,
// //             ),
// //           ),
// //           const SizedBox(height: 6),
// //           Container(
// //             width: double.infinity,
// //             padding: widget.isSeller
// //                 ? const EdgeInsets.all(12)
// //                 : EdgeInsets.zero,
// //             decoration: widget.isSeller
// //                 ? BoxDecoration(
// //                     color: Colors.orange.withOpacity(0.05),
// //                     border: Border.all(color: Colors.orange.withOpacity(0.3)),
// //                     borderRadius: BorderRadius.circular(8),
// //                   )
// //                 : null,
// //             child: Text(
// //               "${widget.shippingAddress['name']}\n"
// //               "${widget.shippingAddress['street']}, ${widget.shippingAddress['city']}\n"
// //               "${widget.shippingAddress['state']}, ${widget.shippingAddress['zip']}\n"
// //               "${widget.shippingAddress['country']}",
// //               style: GoogleFonts.lato(
// //                 fontSize: 14,
// //                 height: 1.4,
// //                 color: theme.textTheme.bodyMedium?.color,
// //               ),
// //             ),
// //           ),
// //           const Divider(height: 30),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Text(
// //                 "Payment Method",
// //                 style: GoogleFonts.lato(
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.grey.shade600,
// //                 ),
// //               ),
// //               Text(
// //                 widget.paymentMethod == 'cod'
// //                     ? 'Cash on Delivery'
// //                     : 'Paid Online',
// //                 style: GoogleFonts.lato(
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.w600,
// //                   color: theme.textTheme.bodyMedium?.color,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 12),
// //           _buildPriceRow("Subtotal", widget.price, theme),
// //           _buildPriceRow("Delivery", delivery, theme),
// //           _buildPriceRow("Tax", tax, theme),
// //           const Divider(height: 24),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Text(
// //                 "Total",
// //                 style: GoogleFonts.lato(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: theme.textTheme.titleLarge?.color,
// //                 ),
// //               ),
// //               Text(
// //                 "\$${total.toStringAsFixed(2)}",
// //                 style: GoogleFonts.lato(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.deepPurpleAccent,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildPriceRow(String label, double amount, ThemeData theme) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 4),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text(
// //             label,
// //             style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600),
// //           ),
// //           Text(
// //             "\$${amount.toStringAsFixed(2)}",
// //             style: GoogleFonts.lato(
// //               fontSize: 14,
// //               fontWeight: FontWeight.w500,
// //               color: theme.textTheme.bodyMedium?.color,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ---------------- Timeline ----------------
// //   Widget _buildTimeline(BuildContext context, String status) {
// //     final theme = Theme.of(context);
// //     int currentStep = 0;
// //     switch (status.toLowerCase()) {
// //       case 'placed':
// //         currentStep = 1;
// //         break;
// //       case 'confirmed':
// //         currentStep = 2;
// //         break;
// //       case 'shipped':
// //         currentStep = 3;
// //         break;
// //       case 'delivered':
// //         currentStep = 4;
// //         break;
// //       default:
// //         currentStep = 1;
// //     }

// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         _buildTimelineStep(
// //           context,
// //           "Placed",
// //           currentStep >= 1,
// //           currentStep > 1,
// //         ),
// //         _buildTimelineLine(context, currentStep > 1),
// //         _buildTimelineStep(
// //           context,
// //           "Confirmed",
// //           currentStep >= 2,
// //           currentStep > 2,
// //         ),
// //         _buildTimelineLine(context, currentStep > 2),
// //         _buildTimelineStep(
// //           context,
// //           "Shipped",
// //           currentStep >= 3,
// //           currentStep > 3,
// //         ),
// //         _buildTimelineLine(context, currentStep > 3),
// //         _buildTimelineStep(
// //           context,
// //           "Delivered",
// //           currentStep >= 4,
// //           currentStep > 4,
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildTimelineStep(
// //     BuildContext context,
// //     String label,
// //     bool isActive,
// //     bool isCompleted,
// //   ) {
// //     final theme = Theme.of(context);
// //     return Column(
// //       children: [
// //         Container(
// //           width: 30,
// //           height: 30,
// //           decoration: BoxDecoration(
// //             color: isActive
// //                 ? theme.primaryColor
// //                 : (isCompleted ? theme.primaryColor : Colors.grey.shade300),
// //             shape: BoxShape.circle,
// //             border: isActive
// //                 ? Border.all(color: theme.primaryColor, width: 2)
// //                 : null,
// //           ),
// //           child: Center(
// //             child: isCompleted
// //                 ? const Icon(Icons.check, size: 16, color: Colors.white)
// //                 : const SizedBox(),
// //           ),
// //         ),
// //         const SizedBox(height: 4),
// //         Text(
// //           label,
// //           style: GoogleFonts.lato(
// //             fontSize: 10,
// //             color: isActive ? theme.primaryColor : Colors.grey,
// //             fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildTimelineLine(BuildContext context, bool isActive) {
// //     return Container(
// //       width: 30,
// //       height: 2,
// //       color: isActive ? Theme.of(context).primaryColor : Colors.grey.shade300,
// //       margin: const EdgeInsets.symmetric(
// //         horizontal: 4,
// //         vertical: 15,
// //       ).copyWith(bottom: 25),
// //     );
// //   }
// // }

// // // // ------------------- Placeholder RaiseDisputeScreen -------------------
// // // // You will implement this separately with reason, description, and image upload
// // // class RaiseDisputeScreen extends StatelessWidget {
// // //   final String orderId;
// // //   final String buyerId;
// // //   final String sellerId;

// // //   const RaiseDisputeScreen({
// // //     super.key,
// // //     required this.orderId,
// // //     required this.buyerId,
// // //     required this.sellerId,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text("Raise Dispute")),
// // //       body: const Center(child: Text("Dispute form goes here")),
// // //     );
// // //   }
// // // }
