import 'package:flutter/material.dart';

/// ===============================
/// APP INFO
/// ===============================
class AppConstants {
  static const String appName = "BidHive";
  static const String currency = "PKR";
}

/// ===============================
/// COLORS
/// ===============================
class AppColors {
  // Primary Theme
  static const Color primary = Color(0xFF7B3FE4);
  static const Color secondary = Color(0xFFFFC857);
  static const Color accent = Color(0xFFF857C3);

  // Backgrounds
  static const Color scaffoldBg = Color(0xFFF6F1FF);
  static const Color cardBg = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF2E2E2E);
  static const Color textSecondary = Color(0xFF6E6E6E);
  static const Color textLight = Color(0xFF9E9E9E);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);

  // Borders & Divider
  static const Color border = Color(0xFFE0E0E0);
}

/// ===============================
/// TEXT STYLES
/// ===============================
class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textLight,
  );

  static const TextStyle price = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

/// ===============================
/// SPACING & RADIUS
/// ===============================
class AppSizes {
  static const double paddingXS = 8;
  static const double paddingSM = 12;
  static const double paddingMD = 16;
  static const double paddingLG = 24;

  static const double radiusSM = 8;
  static const double radiusMD = 12;
  static const double radiusLG = 20;
}

/// ===============================
/// AUCTION TYPES
/// ===============================
class AuctionType {
  static const String fixed = "Fixed Auction";
  static const String english = "English Auction";
}

/// ===============================
/// AUCTION STATUS
/// ===============================
class AuctionStatus {
  static const String active = "Active";
  static const String pending = "Pending";
  static const String completed = "Completed";
  static const String won = "Won";
  static const String lost = "Lost";
}

/// ===============================
/// PAYMENT METHODS
/// ===============================
class PaymentMethods {
  static const String card = "Credit / Debit Card";
  static const String paypal = "PayPal";
  static const String bank = "Bank Transfer";
  static const String cod = "Cash on Delivery";
}

/// ===============================
/// API & FIRESTORE
/// ===============================
class ApiConstants {
  static const int timeout = 30;

  // Firestore Collections
  static const String users = "users";
  static const String auctions = "auctions";
  static const String bids = "bids";
  static const String payments = "payments";
}

/// ===============================
/// ASSETS
/// ===============================
class AppAssets {
  static const String logo = "assets/images/logo.png";
  static const String placeholder = "assets/images/placeholder.png";
  static const String success = "assets/images/success.png";
}

/// ===============================
/// COMMON STRINGS
/// ===============================
class AppStrings {
  static const String login = "Log In";
  static const String signup = "Sign Up";
  static const String placeBid = "Place Bid";
  static const String startAuction = "Start Auction";
  static const String paymentSuccess = "Payment Successful!";
  static const String noData = "No data available";
}

final List<String> categoriesList = [
  'Electronics',
  'Antiques',
  'Collectibles',
  'Vehicles',
  'Others',
];
