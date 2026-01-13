import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auctify/utils/constants.dart';

class AuctionWonScreen extends StatelessWidget {
  final String productName;
  final String productImage;
  final double finalPrice;
  final String bidTime;

  const AuctionWonScreen({
    super.key,
    required this.productName,
    required this.productImage,
    required this.finalPrice,
    required this.bidTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text("Congratulations"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            /// 🎉 Title
            Text(
              "🎉 Congratulations!",
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              "You won this auction",
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            /// 🖼 Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                productImage,
                height: 230,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 24),

            /// 📦 Product Details
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _infoRow(
                      "Final Price",
                      "\$${finalPrice.toStringAsFixed(2)}",
                    ),
                    const SizedBox(height: 6),
                    _infoRow("Winning Time", bidTime),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 💳 Pay Now
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Payment flow
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  "Pay Now",
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// 🏠 Return Home
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  side: BorderSide(color: AppColors.primary, width: 2),
                ),
                child: Text(
                  "Return Home",
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// ℹ️ Info Row
  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(fontSize: 14, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
