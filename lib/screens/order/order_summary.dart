// import 'package:auctify/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class OrderSummary extends StatelessWidget {
//   const OrderSummary({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.scaffoldBg,
//         appBar: AppBar(
//           title: Text(
//             "Order Summary",
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w800,
//               color: AppColors.textPrimary,
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 18),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 30,
//                     vertical: 10,
//                   ),
//                   child: Container(
//                     height: 280,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         fit: BoxFit.fitHeight,
//                         image: NetworkImage(
//                           "https://cdn.pixabay.com/photo/2018/02/24/20/39/clock-3179167_1280.jpg",
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 18),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Product Name",
//                         style: GoogleFonts.archivo(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.category,
//                             color: AppColors.primary,
//                             size: 24,
//                           ),
//                           SizedBox(width: 5),
//                           Text(
//                             "Category",
//                             style: GoogleFonts.archivo(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.textSecondary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         "Price: ",
//                         style: GoogleFonts.archivo(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                       Text(
//                         "\$350",
//                         style: GoogleFonts.archivo(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w900,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:auctify/layout/layout.dart';
import 'package:auctify/models/auction_model.dart';
import 'package:auctify/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderSummaryScreen extends StatelessWidget {
  final String orderId;
  final AuctionModel auction;
  final Map<String, dynamic> shippingAddress;
  final String paymentMethod;
  final double price;

  const OrderSummaryScreen({
    super.key,
    required this.orderId,
    required this.auction,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text(
          "Order Summary",
          style: GoogleFonts.archivo(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===================== Auction Info =====================
            Text(
              "Auction Details",
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Auction Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                      image: auction.imageUrls.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(auction.imageUrls.first),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: auction.imageUrls.isEmpty
                        ? const Icon(Icons.gavel, size: 40, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  // Auction Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auction.title,
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Seller: ${auction.sellerName}",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Auction Type: ${auction.type}",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Price: \$${price.toStringAsFixed(2)}",
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
            ),
            const SizedBox(height: 24),

            // ===================== Shipping Info =====================
            Text(
              "Shipping Address",
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shippingAddress['name'] ?? '',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shippingAddress['phone'] ?? '',
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${shippingAddress['street']}, ${shippingAddress['city']}, ${shippingAddress['state']}, ${shippingAddress['zip']}, ${shippingAddress['country']}",
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ===================== Payment Info =====================
            Text(
              "Payment",
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order ID: $orderId",
                    style: GoogleFonts.lato(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Payment Method: ${paymentMethod.toUpperCase()}",
                    style: GoogleFonts.lato(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Payment Status: ${auction.paymentStatus ?? 'pending'}",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: auction.paymentStatus == 'paid'
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Order Placed: ${auction.soldAt != null ? auction.soldAt!.toDate().toLocal().toString().split('.')[0] : 'N/A'}",
                    style: GoogleFonts.lato(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ===================== Done Button =====================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Layout()),
                  );
                },
                child: Text(
                  "Home",
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
