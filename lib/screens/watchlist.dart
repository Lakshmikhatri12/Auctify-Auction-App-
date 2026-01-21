import 'package:auctify/models/auction_model.dart';
import 'package:auctify/screens/auction/auction_detail.dart';
import 'package:auctify/services/auction_service.dart';
import 'package:auctify/services/user_service.dart';
import 'package:auctify/utils/auctionCard.dart';
import 'package:auctify/utils/constants.dart';
import 'package:auctify/utils/custom_appbar.dart';
import 'package:auctify/utils/notification_Icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WatchList extends StatelessWidget {
  WatchList({super.key});

  final UserService _userService = UserService();
  final AuctionService _auctionService = AuctionService();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,

          actions: const [
            Icon(Icons.notifications_outlined, color: AppColors.primary),
            SizedBox(width: 12),
          ],
        ),
        // backgroundColor: AppColors.scaffoldBg, // Removed to use Theme defaults
        body: StreamBuilder<List<String>>(
          stream: _userService.streamWishlistIds(currentUserId),
          builder: (context, wishlistSnapshot) {
            if (wishlistSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final wishlistIds = wishlistSnapshot.data ?? [];

            if (wishlistIds.isEmpty) {
              return _buildEmptyState();
            }

            // 🔥 FETCH ALL AUCTIONS AT ONCE
            return FutureBuilder<List<AuctionModel?>>(
              future: Future.wait(
                wishlistIds.map((id) => _auctionService.getAuctionById(id)),
              ),
              builder: (context, auctionSnapshot) {
                if (auctionSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  // ✅ SINGLE LOADER
                  return const Center(child: CircularProgressIndicator());
                }

                final auctions = auctionSnapshot.data!
                    .whereType<AuctionModel>()
                    .toList();

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  itemCount: auctions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 284,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final auction = auctions[index];

                    return Stack(
                      children: [
                        AuctionCard(
                          auctionModel: auction,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AuctionDetailScreen(
                                  auctionId: auction.auctionId,
                                ),
                              ),
                            );
                          },
                        ),

                        // ❤️ REMOVE FROM WATCHLIST
                        Positioned(
                          top: 10,
                          left: 10,
                          child: GestureDetector(
                            onTap: () async {
                              await _userService.toggleWishlist(
                                currentUserId,
                                auction.auctionId,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Removed from WatchList"),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.primary.withOpacity(
                                0.2,
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            "Your wishlist is empty",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tap the heart icon on any auction to save it here.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
