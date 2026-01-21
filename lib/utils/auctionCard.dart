import 'package:cloud_firestore/cloud_firestore.dart';
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
    Color statusColor = Colors.transparent;

    if (auctionModel.status == 'sold') {
      statusLabel = 'SOLD';
      statusColor = AppColors.error;
    } else if (auctionModel.status == 'ended') {
      statusLabel = 'ENDED';
      statusColor = AppColors.warning;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE SECTION
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radiusMD),
                    topRight: Radius.circular(AppSizes.radiusMD),
                  ),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: isInactive
                            ? ColorFilter.mode(
                                Colors.grey.withOpacity(0.8),
                                BlendMode.saturation,
                              )
                            : null,
                        image: NetworkImage(
                          auctionModel.imageUrls.isNotEmpty
                              ? auctionModel.imageUrls.first
                              : 'https://via.placeholder.com/150',
                        ),
                      ),
                    ),
                  ),
                ),

                // Status Badge (Sold/Ended)
                if (statusLabel.isNotEmpty)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        statusLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            /// CONTENT SECTION
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    auctionModel.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      // Using a modern clean font
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      color: isInactive
                          ? AppColors.textLight
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Price
                  Text(
                    _getAuctionPriceText(auctionModel),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isInactive
                          ? AppColors.textLight
                          : AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 8),

                  // Seller Info Row
                  Row(
                    children: [
                      // FutureBuilder to fetch profile image
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(auctionModel.sellerId)
                            .get(),
                        builder: (context, snapshot) {
                          String? profileImageUrl;
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.exists) {
                            final data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            profileImageUrl = data['profileImageUrl'];
                          }

                          if (profileImageUrl != null &&
                              profileImageUrl.isNotEmpty) {
                            return CircleAvatar(
                              radius: 10,
                              backgroundImage: NetworkImage(profileImageUrl),
                              backgroundColor: AppColors.secondary.withOpacity(
                                0.2,
                              ),
                            );
                          } else {
                            // Fallback to initials
                            return CircleAvatar(
                              radius: 10,
                              backgroundColor: AppColors.secondary.withOpacity(
                                0.2,
                              ),
                              child: Text(
                                auctionModel.sellerName.isNotEmpty
                                    ? auctionModel.sellerName[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          auctionModel.sellerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAuctionPriceText(AuctionModel auction) {
    if (auction.type == 'english') {
      final price = auction.currentBid ?? auction.startingBid;
      return '\$${price.toStringAsFixed(0)}';
    } else {
      return '\$${auction.startingBid.toStringAsFixed(0)}';
    }
  }
}
