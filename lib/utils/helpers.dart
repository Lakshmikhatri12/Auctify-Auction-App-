import 'package:intl/intl.dart';

// Format date nicely
String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
  return formatter.format(date);
}

// Check if email is valid
bool isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

// Calculate time remaining for auction
String timeRemaining(DateTime endTime) {
  final Duration diff = endTime.difference(DateTime.now());
  if (diff.isNegative) return "Auction ended";
  return "${diff.inHours}h ${diff.inMinutes % 60}m ${diff.inSeconds % 60}s";
}
