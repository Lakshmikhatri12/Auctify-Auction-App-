import 'package:auctify/utils/constants.dart';
import 'package:auctify/utils/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WatchList extends StatefulWidget {
  const WatchList({super.key});

  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  // Example watchlist data
  final List<Map<String, dynamic>> watchList = [
    {
      "productName": "Vintage Pocket Watch",
      "productImage":
          "https://cdn.pixabay.com/photo/2017/02/03/22/41/pocket-watch-2036309_1280.jpg",
      "auctionUser": "John Doe",
      "auctionUserAvatar": "https://randomuser.me/api/portraits/men/32.jpg",
      "yourBid": 300,
      "highestBid": 350,
      "auctionType": "english",
      "timer": "02:23:10",
    },
    {
      "productName": "Antique Vase",
      "productImage":
          "https://cdn.pixabay.com/photo/2018/02/16/02/03/pocket-watch-3156771_1280.jpg",
      "auctionUser": "Alice Smith",
      "auctionUserAvatar": "https://randomuser.me/api/portraits/women/44.jpg",
      "yourBid": 150,
      "highestBid": 200,
      "auctionType": "fixed",
    },
    {
      "productName": "Classic Car Model",
      "productImage":
          "https://cdn.pixabay.com/photo/2018/02/16/02/03/pocket-watch-3156771_1280.jpg",
      "auctionUser": "Michael Johnson",
      "auctionUserAvatar": "https://randomuser.me/api/portraits/men/65.jpg",
      "yourBid": 450,
      "highestBid": 500,
      "auctionType": "english",
      "timer": "00:45:12",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "WatchList"),
      backgroundColor: AppColors.scaffoldBg,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView.separated(
          itemCount: watchList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = watchList[index];
            return _watchListCard(item);
          },
        ),
      ),
    );
  }

  /// 🖼 Image Box
  Widget _imageBox(String? imageUrl, {double height = 80, double width = 80}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl ?? 'https://via.placeholder.com/150',
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: AppColors.scaffoldBg,
            child: Icon(
              Icons.person,
              color: AppColors.textSecondary,
              size: height * 0.5,
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            width: width,
            color: AppColors.scaffoldBg,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Watchlist Card
  Widget _watchListCard(Map<String, dynamic> item) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            _imageBox(item['productImage']),

            const SizedBox(width: 14),

            // Product & User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['productName'] ?? 'Unknown Product',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.scaffoldBg,
                        backgroundImage: NetworkImage(
                          item['auctionUserAvatar'] ??
                              'https://via.placeholder.com/150',
                        ),
                        onBackgroundImageError: (exception, stackTrace) {
                          // Handle image error silently
                        },
                        child: item['auctionUserAvatar'] == null
                            ? Icon(
                                Icons.person,
                                size: 12,
                                color: AppColors.textSecondary,
                              )
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item['auctionUser'] ?? 'Unknown User',
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Your Bid: \$${(item['yourBid'] ?? 0).toStringAsFixed(2)}",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    "Highest Bid: \$${(item['highestBid'] ?? 0).toStringAsFixed(2)}",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Timer for English Auction
            if (item['auctionType'] == "english")
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item['timer'] ?? '--:--:--',
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
