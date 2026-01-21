// import 'package:auctify/controllers/bid_controller.dart';
// import 'package:auctify/models/bid_model.dart';
// import 'package:auctify/screens/auction/auction_detail_screen.dart';
// import 'package:auctify/screens/payment/payment.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:auctify/utils/custom_appbar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class MyBidsScreen extends StatelessWidget {
//   MyBidsScreen({super.key});

//   final BidController _bidController = BidController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: CustomAppBar(
//         title: "My Bids",
//         actions: const [
//           Icon(Icons.search, color: AppColors.primary),
//           SizedBox(width: 8),
//           Icon(Icons.notifications_outlined, color: AppColors.primary),
//           SizedBox(width: 12),
//         ],
//       ),
//       body: StreamBuilder<List<BidModel>>(
//         stream: _bidController.getMyBidsStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No bids yet"));
//           }

//           final bids = snapshot.data!;
//           final currentUserId = FirebaseAuth.instance.currentUser!.uid;

//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: ListView.separated(
//               padding: const EdgeInsets.only(top: 12, bottom: 20),
//               itemCount: bids.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 12),
//               itemBuilder: (context, index) {
//                 final bid = bids[index];

//                 return FutureBuilder<DocumentSnapshot>(
//                   future: FirebaseFirestore.instance
//                       .collection('auctions')
//                       .doc(bid.auctionId)
//                       .get(),
//                   builder: (context, auctionSnapshot) {
//                     if (!auctionSnapshot.hasData) return const SizedBox();

//                     final auction =
//                         auctionSnapshot.data!.data() as Map<String, dynamic>?;

//                     if (auction == null) return const SizedBox();

//                     // Fetch all auction details
//                     final String title = auction['title'] ?? "Auction";
//                     final List images = auction['imageUrls'] ?? [];
//                     final String image = images.isNotEmpty ? images.first : "";
//                     final double currentBid = (auction['currentBid'] ?? 0)
//                         .toDouble();

//                     final bool isLeading = bid.amount >= currentBid;

//                     final String auctionStatus = auction['status'] ?? 'active';
//                     final String? winnerId = auction['winnerId'];
//                     final String? paymentStatus = auction['paymentStatus'];

//                     return _bidCard(
//                       context: context,
//                       productName: title,
//                       productImage: image,
//                       bidAmount: bid.amount,
//                       currentHighest: currentBid,
//                       bidTime: _timeAgo(bid.createdAt),
//                       isLeading: isLeading,
//                       auctionId: bid.auctionId,
//                       auctionStatus: auctionStatus,
//                       winnerId: winnerId,
//                       paymentStatus: paymentStatus,
//                       currentUserId: currentUserId,
//                     );
//                   },
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   /// 🧾 Bid Card
//   Widget _bidCard({
//     required BuildContext context,
//     required String productName,
//     required String productImage,
//     required double bidAmount,
//     required double currentHighest,
//     required String bidTime,
//     required bool isLeading,
//     required String auctionId,
//     required String auctionStatus,
//     required String? winnerId,
//     required String? paymentStatus,
//     required String currentUserId,
//   }) {
//     final Color statusColor = isLeading ? AppColors.success : AppColors.error;
//     final String statusText = isLeading ? "Leading" : "Outbid";

//     final bool showPayButton =
//         auctionStatus == 'sold' &&
//         winnerId == currentUserId &&
//         paymentStatus == 'pending';

//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(14),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => AuctionDetailScreen(auctionId: auctionId),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               _imageBox(imageUrl: productImage, height: 80, width: 80),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       productName,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.lato(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "Your Bid:",
//                           style: GoogleFonts.lato(
//                             fontSize: 14,
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         Text(
//                           "\$${bidAmount.toStringAsFixed(2)}",
//                           style: GoogleFonts.archivo(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.accent,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "Current Highest:",
//                           style: GoogleFonts.lato(
//                             fontSize: 14,
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         Text(
//                           "\$${currentHighest.toStringAsFixed(2)}",
//                           style: GoogleFonts.archivo(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: statusColor, width: 1),
//                       color: statusColor.withOpacity(0.1),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 5,
//                         horizontal: 10,
//                       ),
//                       child: Text(
//                         statusText,
//                         style: GoogleFonts.lato(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: statusColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     bidTime,
//                     style: GoogleFonts.lato(
//                       fontSize: 12,
//                       color: AppColors.textSecondary.withOpacity(0.7),
//                     ),
//                   ),
//                   if (showPayButton)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => PaymentScreen(
//                                 productName: productName,
//                                 productImage: productImage,
//                                 amount: bidAmount,
//                               ),
//                             ),
//                           );
//                         },
//                         child: const Text("Pay Now"),
//                       ),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// ⏱ Time Ago
//   String _timeAgo(Timestamp timestamp) {
//     final now = DateTime.now();
//     final time = timestamp.toDate();
//     final diff = now.difference(time);

//     if (diff.inMinutes < 1) return "Just now";
//     if (diff.inMinutes < 60) return "${diff.inMinutes} mins ago";
//     if (diff.inHours < 24) return "${diff.inHours} hrs ago";
//     return "${diff.inDays} days ago";
//   }
// }

// /// 🖼 Image Box
// Widget _imageBox({
//   required String imageUrl,
//   required double height,
//   required double width,
// }) {
//   return ClipRRect(
//     borderRadius: BorderRadius.circular(12),
//     child: imageUrl.isNotEmpty
//         ? Image.network(
//             imageUrl,
//             height: height,
//             width: width,
//             fit: BoxFit.cover,
//           )
//         : Container(
//             height: height,
//             width: width,
//             color: Colors.grey.shade300,
//             child: const Icon(Icons.gavel, size: 32),
//           ),
//   );
// }

// import 'package:auctify/controllers/bid_controller.dart';
// import 'package:auctify/models/bid_model.dart';
// import 'package:auctify/screens/auction/auction_detail_screen.dart';
// import 'package:auctify/screens/payment/payment.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:auctify/utils/custom_appbar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class MyBidsScreen extends StatelessWidget {
//   MyBidsScreen({super.key});

//   final BidController _bidController = BidController();

//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = FirebaseAuth.instance.currentUser!.uid;

//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: CustomAppBar(
//         title: "My Bids",
//         actions: const [
//           Icon(Icons.search, color: AppColors.primary),
//           SizedBox(width: 8),
//           Icon(Icons.notifications_outlined, color: AppColors.primary),
//           SizedBox(width: 12),
//         ],
//       ),
//       body: StreamBuilder<List<BidModel>>(
//         stream: _bidController.getMyBidsStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No bids yet"));
//           }

//           final bids = snapshot.data!;

//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: ListView.separated(
//               padding: const EdgeInsets.only(top: 12, bottom: 20),
//               itemCount: bids.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 12),
//               itemBuilder: (context, index) {
//                 final bid = bids[index];

//                 return FutureBuilder<DocumentSnapshot>(
//                   future: FirebaseFirestore.instance
//                       .collection('auctions')
//                       .doc(bid.auctionId)
//                       .get(),
//                   builder: (context, auctionSnapshot) {
//                     if (!auctionSnapshot.hasData) return const SizedBox();

//                     final auctionData =
//                         auctionSnapshot.data!.data() as Map<String, dynamic>?;
//                     if (auctionData == null) return const SizedBox();

//                     final String title = auctionData['title'] ?? "Auction";
//                     final List images = auctionData['imageUrls'] ?? [];
//                     final String image = images.isNotEmpty ? images.first : "";
//                     final double currentBid = (auctionData['currentBid'] ?? 0)
//                         .toDouble();
//                     final String auctionType = auctionData['type'] ?? 'english';
//                     final String auctionStatus =
//                         auctionData['status'] ?? 'active';
//                     final String? winnerId = auctionData['winnerId'];
//                     final String? paymentStatus = auctionData['paymentStatus'];

//                     // ---------------- SAFE TIMESTAMP PARSING ----------------
//                     DateTime? parseDateTime(dynamic value) {
//                       if (value == null) return null;
//                       if (value is Timestamp) return value.toDate();
//                       if (value is String) return DateTime.tryParse(value);
//                       return null;
//                     }

//                     final endTime = parseDateTime(auctionData['endTime']);
//                     final startTime = parseDateTime(auctionData['startTime']);

//                     // ---------------- BID STATUS ----------------
//                     String statusText;
//                     Color statusColor;
//                     final now = DateTime.now();

//                     if (auctionType == 'fixed') {
//                       statusText = "Fixed Price";
//                       statusColor = AppColors.primary;
//                     } else if (endTime != null && now.isAfter(endTime)) {
//                       // Auction ended
//                       if (winnerId == currentUserId) {
//                         statusText = "Won";
//                         statusColor = AppColors.success;
//                       } else {
//                         statusText = "Ended";
//                         statusColor = Colors.grey;
//                       }
//                     } else {
//                       // Auction ongoing
//                       if (bid.amount >= currentBid) {
//                         statusText = "Leading";
//                         statusColor = AppColors.success;
//                       } else {
//                         statusText = "Outbid";
//                         statusColor = AppColors.error;
//                       }
//                     }

//                     // ---------------- TIME LEFT ----------------
//                     String bidTime = "";
//                     if (auctionType != 'fixed' && endTime != null) {
//                       final diff = endTime.difference(now);
//                       if (diff.isNegative) {
//                         bidTime = "Ended";
//                       } else if (diff.inDays > 0) {
//                         bidTime = "${diff.inDays}d ${diff.inHours % 24}h left";
//                       } else if (diff.inHours > 0) {
//                         bidTime =
//                             "${diff.inHours}h ${diff.inMinutes % 60}m left";
//                       } else if (diff.inMinutes > 0) {
//                         bidTime =
//                             "${diff.inMinutes}m ${diff.inSeconds % 60}s left";
//                       } else {
//                         bidTime = "${diff.inSeconds}s left";
//                       }
//                     }

//                     final bool showPayButton =
//                         auctionStatus == 'sold' &&
//                         winnerId == currentUserId &&
//                         paymentStatus == 'pending';

//                     return _bidCard(
//                       context: context,
//                       productName: title,
//                       productImage: image,
//                       bidAmount: bid.amount,
//                       currentHighest: currentBid,
//                       bidTime: bidTime,
//                       statusText: statusText,
//                       statusColor: statusColor,
//                       auctionId: bid.auctionId,
//                       showPayButton: showPayButton,
//                     );
//                   },
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _bidCard({
//     required BuildContext context,
//     required String productName,
//     required String productImage,
//     required double bidAmount,
//     required double currentHighest,
//     required String bidTime,
//     required String statusText,
//     required Color statusColor,
//     required String auctionId,
//     required bool showPayButton,
//   }) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(14),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => AuctionDetailScreen(auctionId: auctionId),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               _imageBox(imageUrl: productImage, height: 80, width: 80),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       productName,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.lato(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).textTheme.titleMedium?.color,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "Your Bid:",
//                           style: GoogleFonts.lato(
//                             fontSize: 14,
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         Text(
//                           "\$${bidAmount.toStringAsFixed(2)}",
//                           style: GoogleFonts.archivo(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.accent,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "Current Highest:",
//                           style: GoogleFonts.lato(
//                             fontSize: 14,
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         Text(
//                           "\$${currentHighest.toStringAsFixed(2)}",
//                           style: GoogleFonts.archivo(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: statusColor, width: 1),
//                       color: statusColor.withOpacity(0.1),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 5,
//                         horizontal: 10,
//                       ),
//                       child: Text(
//                         statusText,
//                         style: GoogleFonts.lato(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: statusColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     bidTime,
//                     style: GoogleFonts.lato(
//                       fontSize: 12,
//                       color: AppColors.textSecondary.withOpacity(0.7),
//                     ),
//                   ),
//                   if (showPayButton)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(
//                           //     builder: (context) => PaymentScreen(
//                           //       productName: productName,
//                           //       productImage: productImage,
//                           //       amount: bidAmount,
//                           //     ),
//                           //   ),
//                           // );
//                         },
//                         child: const Text("Pay Now"),
//                       ),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _imageBox({
//   required String imageUrl,
//   required double height,
//   required double width,
// }) {
//   return ClipRRect(
//     borderRadius: BorderRadius.circular(12),
//     child: imageUrl.isNotEmpty
//         ? Image.network(
//             imageUrl,
//             height: height,
//             width: width,
//             fit: BoxFit.cover,
//           )
//         : Container(
//             height: height,
//             width: width,
//             color: Colors.grey.shade300,
//             child: const Icon(Icons.gavel, size: 32),
//           ),
//   );
// }

// import 'package:auctify/controllers/bid_controller.dart';
// import 'package:auctify/models/bid_model.dart';
// import 'package:auctify/screens/auction/auction_detail_screen.dart';
// import 'package:auctify/screens/payment/payment.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:auctify/utils/custom_appbar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class MyBidsScreen extends StatelessWidget {
//   MyBidsScreen({super.key});

//   final BidController _bidController = BidController();

//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = FirebaseAuth.instance.currentUser!.uid;

//     return Scaffold(
//       // backgroundColor: AppColors.scaffoldBg, // Removed to use Theme defaults
//       appBar: CustomAppBar(
//         title: "My Bids",
//         actions: const [
//           Icon(Icons.search, color: AppColors.primary),
//           SizedBox(width: 8),
//           Icon(Icons.notifications_outlined, color: AppColors.primary),
//           SizedBox(width: 12),
//         ],
//       ),
//       body: StreamBuilder<List<BidModel>>(
//         stream: _bidController.getMyBidsStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No bids yet"));
//           }

//           final bids = snapshot.data!;

//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: ListView.separated(
//               padding: const EdgeInsets.only(top: 12, bottom: 20),
//               itemCount: bids.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 12),
//               itemBuilder: (context, index) {
//                 final bid = bids[index];

//                 return FutureBuilder<DocumentSnapshot>(
//                   future: () async {
//                     final doc = await FirebaseFirestore.instance
//                         .collection('auctions')
//                         .doc(bid.auctionId)
//                         .get();

//                     // ✅ Check if auction ended and set winner
//                     await _bidController.checkAndSetWinner(bid.auctionId);

//                     return doc;
//                   }(),
//                   builder: (context, auctionSnapshot) {
//                     if (!auctionSnapshot.hasData) return const SizedBox();

//                     final auctionData =
//                         auctionSnapshot.data!.data() as Map<String, dynamic>?;
//                     if (auctionData == null) return const SizedBox();

//                     final String title = auctionData['title'] ?? "Auction";
//                     final List images = auctionData['imageUrls'] ?? [];
//                     final String image = images.isNotEmpty ? images.first : "";
//                     final double currentBid = (auctionData['currentBid'] ?? 0)
//                         .toDouble();
//                     final String auctionStatus =
//                         auctionData['status'] ?? 'active';
//                     final String? winnerId = auctionData['winnerId'];
//                     final String? paymentStatus = auctionData['paymentStatus'];

//                     // ---------------- TIME LEFT ----------------
//                     String bidTime = "";
//                     final endTime = auctionData['endTime'] as Timestamp?;
//                     if (endTime != null) {
//                       final diff = endTime.toDate().difference(DateTime.now());
//                       bidTime = diff.isNegative
//                           ? ""
//                           : diff.inDays > 0
//                           ? "${diff.inDays}d ${diff.inHours % 24}h left"
//                           : diff.inHours > 0
//                           ? "${diff.inHours}h ${diff.inMinutes % 60}m left"
//                           : diff.inMinutes > 0
//                           ? "${diff.inMinutes}m ${diff.inSeconds % 60}s left"
//                           : "${diff.inSeconds}s left";
//                     }

//                     final bool showPayButton =
//                         auctionStatus == 'sold' &&
//                         winnerId == currentUserId &&
//                         paymentStatus == 'pending';

//                     // Status text & color
//                     String statusText;
//                     Color statusColor;

//                     if (winnerId != null && winnerId == currentUserId) {
//                       statusText = "Won";
//                       statusColor = AppColors.accent;
//                     } else if (auctionStatus == "sold") {
//                       statusText = "Ended";
//                       statusColor = Colors.grey;
//                     } else if (bid.amount >= currentBid) {
//                       statusText = "Leading";
//                       statusColor = AppColors.success;
//                     } else {
//                       statusText = "Outbid";
//                       statusColor = AppColors.error;
//                     }

//                     return _bidCard(
//                       context: context,
//                       productName: title,
//                       productImage: image,
//                       bidAmount: bid.amount,
//                       currentHighest: currentBid,
//                       bidTime: bidTime,
//                       statusText: statusText,
//                       statusColor: statusColor,
//                       auctionId: bid.auctionId,
//                       showPayButton: showPayButton,
//                     );
//                   },
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _bidCard({
//     required BuildContext context,
//     required String productName,
//     required String productImage,
//     required double bidAmount,
//     required double currentHighest,
//     required String bidTime,
//     required String statusText,
//     required Color statusColor,
//     required String auctionId,
//     required bool showPayButton,
//   }) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(14),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => AuctionDetailScreen(auctionId: auctionId),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               _imageBox(imageUrl: productImage, height: 80, width: 80),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       productName,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.lato(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "Your Bid: ",
//                           style: GoogleFonts.lato(
//                             fontSize: 14,
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                         Text(
//                           "\$${bidAmount.toStringAsFixed(2)}",
//                           style: GoogleFonts.archivo(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.accent,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "Current Highest: ",
//                           style: GoogleFonts.lato(
//                             fontSize: 14,
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                         Text(
//                           "\$${currentHighest.toStringAsFixed(2)}",
//                           style: GoogleFonts.archivo(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: statusColor, width: 1),
//                       color: statusColor.withOpacity(0.1),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 5,
//                         horizontal: 10,
//                       ),
//                       child: Text(
//                         statusText,
//                         style: GoogleFonts.lato(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: statusColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     bidTime,
//                     style: GoogleFonts.lato(
//                       fontSize: 12,
//                       color: AppColors.textSecondary.withOpacity(0.7),
//                     ),
//                   ),
//                   if (showPayButton)
//                     TextButton(
//                       onPressed: () {
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (context) => PaymentScreen(
//                         //       productName: productName,
//                         //       productImage: productImage,
//                         //       amount: bidAmount,
//                         //     ),
//                         //   ),
//                         // );
//                       },
//                       child: const Text(
//                         "Pay Now",
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w800,
//                           color: Colors.deepPurpleAccent,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _imageBox({
//   required String imageUrl,
//   required double height,
//   required double width,
// }) {
//   return ClipRRect(
//     borderRadius: BorderRadius.circular(12),
//     child: imageUrl.isNotEmpty
//         ? Image.network(
//             imageUrl,
//             height: height,
//             width: width,
//             fit: BoxFit.cover,
//           )
//         : Container(
//             height: height,
//             width: width,
//             color: Colors.grey.shade300,
//             child: const Icon(Icons.gavel, size: 32),
//           ),
//   );
// }

// import 'package:auctify/controllers/bid_controller.dart';
// import 'package:auctify/models/bid_model.dart';
// import 'package:auctify/screens/auction/auction_detail_screen.dart';
// import 'package:auctify/screens/checkout/checkout.dart';
// import 'package:auctify/screens/payment/payment.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:auctify/utils/custom_appbar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class MyBidsScreen extends StatelessWidget {
//   MyBidsScreen({super.key});

//   final BidController _bidController = BidController();

//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = FirebaseAuth.instance.currentUser!.uid;

//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: CustomAppBar(
//         title: "My Bids",
//         actions: const [
//           Icon(Icons.search, color: AppColors.primary),
//           SizedBox(width: 8),
//           Icon(Icons.notifications_outlined, color: AppColors.primary),
//           SizedBox(width: 12),
//         ],
//       ),
//       body: StreamBuilder<List<BidModel>>(
//         stream: _bidController.getMyBidsStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No bids yet"));
//           }

//           final bids = snapshot.data!;

//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: ListView.separated(
//               padding: const EdgeInsets.only(top: 12, bottom: 20),
//               itemCount: bids.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 12),
//               itemBuilder: (context, index) {
//                 final bid = bids[index];

//                 return FutureBuilder<DocumentSnapshot>(
//                   future: () async {
//                     final doc = await FirebaseFirestore.instance
//                         .collection('auctions')
//                         .doc(bid.auctionId)
//                         .get();

//                     // Check if auction ended and set winner
//                     await _bidController.checkAndSetWinner(bid.auctionId);

//                     return doc;
//                   }(),
//                   builder: (context, auctionSnapshot) {
//                     if (!auctionSnapshot.hasData) return const SizedBox();

//                     final auctionData =
//                         auctionSnapshot.data!.data() as Map<String, dynamic>?;

//                     if (auctionData == null) return const SizedBox();

//                     final String title = auctionData['title'] ?? "Auction";
//                     final List images = auctionData['imageUrls'] ?? [];
//                     final String image = images.isNotEmpty ? images.first : "";
//                     final double currentBid = (auctionData['currentBid'] ?? 0)
//                         .toDouble();
//                     final String auctionStatus =
//                         auctionData['status'] ?? 'active';
//                     final String? winnerId = auctionData['winnerId'];
//                     final String? paymentStatus = auctionData['paymentStatus'];
//                     final String sellerId = auctionData['sellerId'] ?? '';

//                     // ---------------- TIME LEFT ----------------
//                     String bidTime = "";
//                     final endTime = auctionData['endTime'] as Timestamp?;
//                     if (endTime != null) {
//                       final diff = endTime.toDate().difference(DateTime.now());
//                       bidTime = diff.isNegative
//                           ? ""
//                           : diff.inDays > 0
//                           ? "${diff.inDays}d ${diff.inHours % 24}h left"
//                           : diff.inHours > 0
//                           ? "${diff.inHours}h ${diff.inMinutes % 60}m left"
//                           : diff.inMinutes > 0
//                           ? "${diff.inMinutes}m ${diff.inSeconds % 60}s left"
//                           : "${diff.inSeconds}s left";
//                     }

//                     final bool showPayButton =
//                         auctionStatus == 'sold' &&
//                         winnerId == currentUserId &&
//                         paymentStatus == 'pending';

//                     // Status text & color
//                     String statusText;
//                     Color statusColor;

//                     if (winnerId != null && winnerId == currentUserId) {
//                       statusText = "Won";
//                       statusColor = AppColors.accent;
//                     } else if (auctionStatus == "sold") {
//                       statusText = "Ended";
//                       statusColor = Colors.grey;
//                     } else if (bid.amount >= currentBid) {
//                       statusText = "Leading";
//                       statusColor = AppColors.success;
//                     } else {
//                       statusText = "Outbid";
//                       statusColor = AppColors.error;
//                     }

//                     return _bidCard(
//                       context: context,
//                       productName: title,
//                       productImage: image,
//                       bidAmount: bid.amount,
//                       currentHighest: currentBid,
//                       bidTime: bidTime,
//                       statusText: statusText,
//                       statusColor: statusColor,
//                       auctionId: bid.auctionId,
//                       sellerId: sellerId,
//                       showPayButton: showPayButton,
//                     );
//                   },
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _bidCard({
//     required BuildContext context,
//     required String productName,
//     required String productImage,
//     required double bidAmount,
//     required double currentHighest,
//     required String bidTime,
//     required String statusText,
//     required Color statusColor,
//     required String auctionId,
//     required String sellerId,
//     required bool showPayButton,
//     String? winnerId,
//     String? paymentStatus,
//   }) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(14),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => AuctionDetailScreen(auctionId: auctionId),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               _imageBox(imageUrl: productImage, height: 80, width: 80),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       productName,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.lato(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "Your Bid: ",
//                           style: GoogleFonts.lato(
//                             fontSize: 14,
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                         Text(
//                           "\$${bidAmount.toStringAsFixed(2)}",
//                           style: GoogleFonts.archivo(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.accent,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "Current Highest: ",
//                           style: GoogleFonts.lato(
//                             fontSize: 14,
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                         Text(
//                           "\$${currentHighest.toStringAsFixed(2)}",
//                           style: GoogleFonts.archivo(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: statusColor, width: 1),
//                       color: statusColor.withOpacity(0.1),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 5,
//                         horizontal: 10,
//                       ),
//                       child: Text(
//                         statusText,
//                         style: GoogleFonts.lato(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: statusColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     bidTime,
//                     style: GoogleFonts.lato(
//                       fontSize: 12,
//                       color: AppColors.textSecondary.withOpacity(0.7),
//                     ),
//                   ),
//                   if (winnerId != null)
//                     paymentStatus == 'pending'
//                         ? TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       CheckoutScreen(auctionId: auctionId),
//                                 ),
//                               );
//                             },
//                             child: const Text(
//                               "Pay Now",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w800,
//                                 color: Colors.deepPurpleAccent,
//                               ),
//                             ),
//                           )
//                         : Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.green.shade100,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: const Text(
//                               "Paid",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ),
//                   // if (showPayButton)
//                   //   TextButton(
//                   //     onPressed: () {
//                   //       Navigator.push(
//                   //         context,
//                   //         MaterialPageRoute(
//                   //           builder: (context) =>
//                   //               CheckoutScreen(auctionId: auctionId),
//                   //         ),
//                   //       );
//                   //     },
//                   //     child: const Text(
//                   //       "Pay Now",
//                   //       style: TextStyle(
//                   //         fontSize: 14,
//                   //         fontWeight: FontWeight.w800,
//                   //         color: Colors.deepPurpleAccent,
//                   //       ),
//                   //     ),
//                   //   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _imageBox({
//   required String imageUrl,
//   required double height,
//   required double width,
// }) {
//   return ClipRRect(
//     borderRadius: BorderRadius.circular(12),
//     child: imageUrl.isNotEmpty
//         ? Image.network(
//             imageUrl,
//             height: height,
//             width: width,
//             fit: BoxFit.cover,
//           )
//         : Container(
//             height: height,
//             width: width,
//             color: Colors.grey.shade300,
//             child: const Icon(Icons.gavel, size: 32),
//           ),
//   );
// }

import 'package:auctify/controllers/bid_controller.dart';
import 'package:auctify/models/bid_model.dart';
import 'package:auctify/screens/auction/auction_detail.dart';
import 'package:auctify/screens/checkout/checkout.dart';
import 'package:auctify/utils/constants.dart';
import 'package:auctify/utils/custom_appbar.dart';
import 'package:auctify/utils/notification_Icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyBidsScreen extends StatelessWidget {
  MyBidsScreen({super.key});

  final BidController _bidController = BidController();

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: CustomAppBar(
        title: "My Bids",
        actions: const [NotificationIcon(), SizedBox(width: 5)],
      ),
      body: StreamBuilder<List<BidModel>>(
        stream: _bidController.getMyBidsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No bids yet"));
          }

          final bids = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 12, bottom: 20),
              itemCount: bids.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final bid = bids[index];

                return FutureBuilder<DocumentSnapshot>(
                  future: () async {
                    final doc = await FirebaseFirestore.instance
                        .collection('auctions')
                        .doc(bid.auctionId)
                        .get();

                    // Check if auction ended and set winner
                    await _bidController.checkAndSetWinner(bid.auctionId);

                    return doc;
                  }(),
                  builder: (context, auctionSnapshot) {
                    if (!auctionSnapshot.hasData) return const SizedBox();

                    final auctionData =
                        auctionSnapshot.data!.data() as Map<String, dynamic>?;

                    if (auctionData == null) return const SizedBox();

                    final String title = auctionData['title'] ?? "Auction";
                    final List images = auctionData['imageUrls'] ?? [];
                    final String image = images.isNotEmpty ? images.first : "";
                    final double currentBid = (auctionData['currentBid'] ?? 0)
                        .toDouble();
                    final String auctionStatus =
                        auctionData['status'] ?? 'active';
                    final String? winnerId = auctionData['winnerId'];
                    final String? paymentStatus = auctionData['paymentStatus'];
                    final String sellerId = auctionData['sellerId'] ?? '';

                    // ---------------- TIME LEFT ----------------
                    String bidTime = "";
                    final endTime = auctionData['endTime'] as Timestamp?;
                    if (endTime != null) {
                      final diff = endTime.toDate().difference(DateTime.now());
                      bidTime = diff.isNegative
                          ? ""
                          : diff.inDays > 0
                          ? "${diff.inDays}d ${diff.inHours % 24}h left"
                          : diff.inHours > 0
                          ? "${diff.inHours}h ${diff.inMinutes % 60}m left"
                          : diff.inMinutes > 0
                          ? "${diff.inMinutes}m ${diff.inSeconds % 60}s left"
                          : "${diff.inSeconds}s left";
                    }

                    final bool showPayButton =
                        auctionStatus == 'sold' &&
                        winnerId == currentUserId &&
                        paymentStatus == 'pending';

                    // Status text & color
                    String statusText;
                    Color statusColor;

                    if (winnerId != null && winnerId == currentUserId) {
                      statusText = "Won";
                      statusColor = AppColors.accent;
                    } else if (auctionStatus == "sold") {
                      statusText = "Ended";
                      statusColor = Colors.grey;
                    } else if (bid.amount >= currentBid) {
                      statusText = "Leading";
                      statusColor = AppColors.success;
                    } else {
                      statusText = "Outbid";
                      statusColor = AppColors.error;
                    }

                    return _bidCard(
                      context: context,
                      productName: title,
                      productImage: image,
                      bidAmount: bid.amount,
                      currentHighest: currentBid,
                      bidTime: bidTime,
                      statusText: statusText,
                      statusColor: statusColor,
                      auctionId: bid.auctionId,
                      sellerId: sellerId,
                      showPayButton: showPayButton,
                      winnerId: winnerId,
                      paymentStatus: paymentStatus,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _bidCard({
    required BuildContext context,
    required String productName,
    required String productImage,
    required double bidAmount,
    required double currentHighest,
    required String bidTime,
    required String statusText,
    required Color statusColor,
    required String auctionId,
    required String sellerId,
    required bool showPayButton,
    String? winnerId,
    String? paymentStatus,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AuctionDetailScreen(auctionId: auctionId),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _imageBox(imageUrl: productImage, height: 80, width: 80),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Your Bid: ",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          "\$${bidAmount.toStringAsFixed(2)}",
                          style: GoogleFonts.archivo(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Current Highest: ",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          "\$${currentHighest.toStringAsFixed(2)}",
                          style: GoogleFonts.archivo(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: statusColor, width: 1),
                      color: statusColor.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Text(
                        statusText,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bidTime,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                  ),
                  if (winnerId != null)
                    paymentStatus == 'pending'
                        ? TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CheckoutScreen(auctionId: auctionId),
                                ),
                              );
                            },
                            child: const Text(
                              "Pay Now",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Paid",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.green,
                              ),
                            ),
                          ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _imageBox({
  required String imageUrl,
  required double height,
  required double width,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: imageUrl.isNotEmpty
        ? Image.network(
            imageUrl,
            height: height,
            width: width,
            fit: BoxFit.cover,
          )
        : Container(
            height: height,
            width: width,
            color: Colors.grey.shade300,
            child: const Icon(Icons.gavel, size: 32),
          ),
  );
}
