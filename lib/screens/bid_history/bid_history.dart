import 'package:auctify/utils/constants.dart';
import 'package:auctify/utils/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BidHistory extends StatelessWidget {
  const BidHistory({super.key});

  // Example dynamic data
  final List<Map<String, dynamic>> bidList = const [
    {
      "productName": "Vintage Pocket Watch",
      "productImage":
          "https://cdn.pixabay.com/photo/2017/02/03/22/41/pocket-watch-2036309_1280.jpg",
      "winnerName": "John Doe",
      "winnerBid": 300,
      "auctionEndTime": "Jan 2, 2026, 10:00 AM",
      "status": "won",
    },
    {
      "productName": "Antique Vase",
      "productImage":
          "https://cdn.pixabay.com/photo/2018/02/16/02/03/pocket-watch-3156771_1280.jpg",
      "bidderName": "You",
      "bid": 150,
      "time": "10 mins ago",
      "status": "lost",
    },
    {
      "productName": "Classic Car Model",
      "productImage":
          "https://cdn.pixabay.com/photo/2018/02/16/02/03/pocket-watch-3156771_1280.jpg",
      "bidderName": "You",
      "bid": 450,
      "time": "30 mins ago",
      "status": "lost",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Separate winners and other bids
    final winners = bidList.where((bid) => bid['status'] == 'won').toList();
    final otherBids = bidList.where((bid) => bid['status'] != 'won').toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: CustomAppBar(
        title: "Bid History",
        actions: const [
          Icon(Icons.search, color: AppColors.primary),
          SizedBox(width: 8),
          Icon(Icons.notifications_outlined, color: AppColors.primary),
          SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ListView(
          children: [
            // Winner cards at top
            ...winners.map(
              (winner) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _winnerCard(
                  productImage: winner['productImage'],
                  productName: winner['productName'],
                  winnerName: winner['winnerName'],
                  finalPrice: winner['winnerBid'].toDouble(),
                  auctionEndTime: winner['auctionEndTime'],
                ),
              ),
            ),
            // Other bid history cards
            ...otherBids.map(
              (bid) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _bidCard(
                  productImage: bid['productImage'],
                  productName: bid['productName'],
                  bidderName: bid['bidderName'],
                  bidAmount: bid['bid'].toDouble(),
                  bidTime: bid['time'],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Winner Card
  Widget _winnerCard({
    required String productImage,
    required String productName,
    required String winnerName,
    required double finalPrice,
    required String auctionEndTime,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFDDCFE6), // soft purple
              Color(0xFFF6D6E8), // light pink
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _imageBox(imageUrl: productImage, height: 100, width: 100),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Winner: $winnerName",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Final Price: \$${finalPrice.toStringAsFixed(2)}",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Auction Ended: $auctionEndTime",
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: AppColors.textSecondary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Normal Bid Card
  Widget _bidCard({
    required String productImage,
    required String productName,
    required String bidderName,
    required double bidAmount,
    required String bidTime,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: _imageBox(imageUrl: productImage, height: 60, width: 60),
        title: Text(
          productName,
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          "Bidder: $bidderName • Bid: \$${bidAmount.toStringAsFixed(2)}",
          style: GoogleFonts.lato(fontSize: 14, color: AppColors.textSecondary),
        ),
        trailing: Text(
          bidTime,
          style: GoogleFonts.lato(
            fontSize: 12,
            color: AppColors.textSecondary.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}

/// 🖼 Image Widget
Widget _imageBox({
  required String imageUrl,
  required double height,
  required double width,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.network(
      imageUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
    ),
  );
}
