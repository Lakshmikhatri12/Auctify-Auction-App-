// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../models/auction_model.dart';
// import '../utils/constants.dart';

// class AuctionCard extends StatelessWidget {
//   final AuctionModel auctionModel;
//   final double width;
//   final VoidCallback? onTap;
//   final String? statusLabel; // Optional status label like "SOLD" or "ENDED"

//   const AuctionCard({
//     super.key,
//     required this.auctionModel,
//     this.width = double.infinity,
//     this.onTap,
//     this.statusLabel,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Determine if auction is inactive (sold or ended)
//     bool isInactive = auctionModel.status != 'active';

//     return Stack(
//       children: [
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             width: width,
//             decoration: BoxDecoration(
//               color: AppColors.cardBg,
//               border: Border.all(
//                 width: 1,
//                 color: const Color.fromARGB(255, 222, 223, 224),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// IMAGE
//                 Container(
//                   height: 160,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       fit: BoxFit.cover,
//                       colorFilter: isInactive
//                           ? ColorFilter.mode(
//                               Colors.grey.withOpacity(0.6),
//                               BlendMode.saturation,
//                             )
//                           : null,
//                       image: NetworkImage(
//                         auctionModel.imageUrls.isNotEmpty
//                             ? auctionModel.imageUrls.first
//                             : 'https://via.placeholder.com/150',
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 /// TITLE
//                 Padding(
//                   padding: const EdgeInsets.only(left: 4),
//                   child: Text(
//                     auctionModel.title,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.archivo(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w800,
//                       color: isInactive ? Colors.grey : AppColors.textPrimary,
//                     ),
//                   ),
//                 ),

//                 /// PRICE (FIXED + ENGLISH)
//                 Padding(
//                   padding: const EdgeInsets.only(left: 4),
//                   child: Text(
//                     _getAuctionPriceText(auctionModel),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.w800,
//                       fontSize: 12,
//                       color: isInactive ? Colors.grey : Colors.blue,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 4),

//                 /// DESCRIPTION
//                 Padding(
//                   padding: const EdgeInsets.only(left: 4),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(4),
//                       color: AppColors.secondary.withOpacity(0.16),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 4,
//                         horizontal: 8,
//                       ),
//                       child: Text(
//                         "Seller: ${auctionModel.sellerName}",
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: GoogleFonts.inter(
//                           fontSize: 12,
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 6),

//                 /// BUTTON
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 4,
//                     vertical: 4,
//                   ),
//                   child: Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(4),
//                       color: AppColors.primary,
//                     ),
//                     child: const Center(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 6),
//                         child: Text(
//                           "View",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         /// OPTIONAL STATUS LABEL (e.g., SOLD / ENDED)
//         if (isInactive && statusLabel != null)
//           Positioned(
//             top: 8,
//             right: 8,
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.7),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 statusLabel!,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   String _getAuctionPriceText(AuctionModel auction) {
//     if (auction.type == 'english') {
//       final price = auction.currentBid ?? auction.startingBid;
//       return 'Price:  \$${price.toStringAsFixed(0)}';
//     } else {
//       return 'Price:  \$${auction.startingBid.toStringAsFixed(0)}';
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/auction_model.dart';
import '../utils/constants.dart';

class AuctionCard extends StatelessWidget {
  final AuctionModel auctionModel;
  final double width;
  final VoidCallback? onTap;

  const AuctionCard({
    super.key,
    required this.auctionModel,
    this.width = double.infinity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if auction is inactive (sold or ended)
    bool isInactive = auctionModel.status != 'active';

    // Compute status label
    String statusLabel = '';
    if (auctionModel.status == 'sold') {
      statusLabel = 'SOLD';
    } else if (auctionModel.status == 'ended') {
      statusLabel = 'ENDED';
    }

    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: width,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              border: Border.all(
                width: 1,
                color: const Color.fromARGB(255, 222, 223, 224),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMAGE
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        auctionModel.imageUrls.isNotEmpty
                            ? auctionModel.imageUrls.first
                            : 'https://via.placeholder.com/150',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// TITLE
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    auctionModel.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.archivo(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                /// PRICE (FIXED + ENGLISH)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    _getAuctionPriceText(auctionModel),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                /// DESCRIPTION
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.secondary.withOpacity(0.16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Text(
                        "Seller: ${auctionModel.sellerName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                /// BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.primary,
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          "View",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// STATUS CHIP (SOLD / ENDED)
        if (isInactive && statusLabel.isNotEmpty)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              decoration: BoxDecoration(
                color: statusLabel == 'SOLD'
                    ? AppColors.error
                    : AppColors.warning, // Red for sold, orange for ended
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _getAuctionPriceText(AuctionModel auction) {
    if (auction.type == 'english') {
      final price = auction.currentBid ?? auction.startingBid;
      return 'Price:  \$${price.toStringAsFixed(0)}';
    } else {
      return 'Price:  \$${auction.startingBid.toStringAsFixed(0)}';
    }
  }
}
