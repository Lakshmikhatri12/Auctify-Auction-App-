// import 'dart:async';
// import 'package:auctify/controllers/auction_controller.dart';
// import 'package:auctify/controllers/bid_controller.dart';
// import 'package:auctify/models/auction_model.dart';
// import 'package:auctify/models/bid_model.dart';
// import 'package:auctify/screens/checkout/checkout.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AuctionDetailScreen extends StatefulWidget {
//   final String auctionId;
//   const AuctionDetailScreen({super.key, required this.auctionId});

//   @override
//   State<AuctionDetailScreen> createState() => _AuctionDetailScreenState();
// }

// class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
//   final AuctionController _auctionController = AuctionController();
//   final BidController _bidController = BidController();
//   final TextEditingController textBidController = TextEditingController();
//   final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

//   Timer? _timer;
//   Duration? _timeLeft;
//   int selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _auctionController.finalizeAuction(
//       widget.auctionId,
//     ); // ensure English auction is finalized
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     textBidController.dispose();
//     super.dispose();
//   }

//   void _startTimer(DateTime endTime, String auctionId) {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
//       final diff = endTime.difference(DateTime.now());
//       setState(() {
//         _timeLeft = diff.isNegative ? Duration.zero : diff;
//       });

//       if (diff.isNegative) {
//         _timer?.cancel();
//         await _auctionController.finalizeAuction(auctionId);
//       }
//     });
//   }

//   String _formatDuration(Duration duration) {
//     final hours = duration.inHours.toString().padLeft(2, '0');
//     final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
//     final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
//     return "$hours:$minutes:$seconds";
//   }

//   String timeAgo(DateTime dateTime) {
//     final diff = DateTime.now().difference(dateTime);
//     if (diff.inSeconds < 60) return "${diff.inSeconds}s ago";
//     if (diff.inMinutes < 60)
//       return "${diff.inMinutes} min${diff.inMinutes > 1 ? 's' : ''} ago";
//     if (diff.inHours < 24)
//       return "${diff.inHours} hr${diff.inHours > 1 ? 's' : ''} ago";
//     if (diff.inDays < 7)
//       return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago";
//     return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<AuctionModel>(
//       stream: _auctionController.streamAuction(widget.auctionId),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         final auction = snapshot.data!;
//         final isEnded = auction.status == 'ended' || auction.status == 'sold';
//         final isWinner = auction.winnerId == currentUserId;

//         // Start timer for English auctions
//         if (auction.type == 'english' && _timeLeft == null) {
//           _startTimer(auction.endTime.toDate(), auction.auctionId);
//         }

//         final productImages = auction.imageUrls;

//         return Scaffold(
//           backgroundColor: AppColors.scaffoldBg,
//           appBar: AppBar(
//             backgroundColor: AppColors.scaffoldBg,
//             elevation: 0,
//             title: Text(
//               auction.title,
//               style: GoogleFonts.lato(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             iconTheme: const IconThemeData(color: AppColors.textPrimary),
//           ),
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Product Images
//                 Container(
//                   height: 380,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(color: Colors.black12, blurRadius: 8),
//                     ],
//                     image: DecorationImage(
//                       fit: BoxFit.cover,
//                       image: NetworkImage(productImages[selectedIndex]),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 SizedBox(
//                   height: 70,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: productImages.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () => setState(() => selectedIndex = index),
//                         child: Container(
//                           margin: const EdgeInsets.only(right: 8),
//                           width: 70,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: selectedIndex == index
//                                   ? AppColors.primary
//                                   : Colors.transparent,
//                               width: 2,
//                             ),
//                             image: DecorationImage(
//                               fit: BoxFit.cover,
//                               image: NetworkImage(productImages[index]),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // Title & Current Bid / Price
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         auction.type == 'fixed'
//                             ? "\$${auction.startingBid.toStringAsFixed(2)}"
//                             : "\$${auction.currentBid?.toStringAsFixed(2) ?? auction.startingBid.toStringAsFixed(2)}",
//                         style: GoogleFonts.lato(
//                           fontSize: 24,
//                           fontWeight: FontWeight.w900,
//                           color: Colors.blue,
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             auction.title,
//                             style: GoogleFonts.archivo(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),
//                           Chip(
//                             label: Text(
//                               auction.category,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.inter(
//                                 fontSize: 12,
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                             backgroundColor: AppColors.primary.withOpacity(0.1),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         auction.description,
//                         style: GoogleFonts.lato(
//                           fontSize: 16,
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.location_on,
//                                 color: AppColors.primary,
//                               ),
//                               const SizedBox(width: 6),
//                               Text(
//                                 auction.location,
//                                 style: GoogleFonts.lato(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),

//                           if (auction.type == 'english' && _timeLeft != null)
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: AppColors.error.withOpacity(0.8),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 _timeLeft!.inSeconds > 0
//                                     ? "Ends In: ${_formatDuration(_timeLeft!)}"
//                                     : "Ended",
//                                 style: GoogleFonts.lato(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Seller Info
//                 Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   elevation: 0,
//                   color: AppColors.secondary.withOpacity(0.16),
//                   margin: EdgeInsets.zero,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 2,
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         FutureBuilder<DocumentSnapshot>(
//                           future: FirebaseFirestore.instance
//                               .collection('users')
//                               .doc(auction.sellerId)
//                               .get(),
//                           builder: (context, snapshot) {
//                             if (!snapshot.hasData) {
//                               return const CircleAvatar(
//                                 radius: 20,
//                                 child: Icon(Icons.person),
//                               );
//                             }
//                             final userData =
//                                 snapshot.data!.data() as Map<String, dynamic>?;
//                             final profileUrl =
//                                 userData?['profileImageUrl'] ?? "";
//                             return CircleAvatar(
//                               radius: 16,
//                               backgroundImage: profileUrl.isNotEmpty
//                                   ? NetworkImage(profileUrl)
//                                   : null,
//                               child: profileUrl.isEmpty
//                                   ? const Icon(Icons.person)
//                                   : null,
//                             );
//                           },
//                         ),
//                         const SizedBox(width: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               auction.sellerName,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.inter(
//                                 fontWeight: FontWeight.w800,
//                                 fontSize: 12,
//                                 color: AppColors.textPrimary,
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               "Seller",
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.inter(
//                                 fontSize: 12,
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 // Recent Bids (for English auction)
//                 if (auction.type != 'fixed') ...[
//                   Text(
//                     "Recent Bids",
//                     style: GoogleFonts.archivo(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   StreamBuilder<List<BidModel>>(
//                     stream: _bidController.getAuctionBids(auction.auctionId),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                         return const Text("No bids yet");
//                       }

//                       final allBids = snapshot.data!;
//                       final Map<String, BidModel> latestBids = {};
//                       for (var bid in allBids) {
//                         if (!latestBids.containsKey(bid.userId) ||
//                             bid.createdAt.toDate().isAfter(
//                               latestBids[bid.userId]!.createdAt.toDate(),
//                             )) {
//                           latestBids[bid.userId] = bid;
//                         }
//                       }

//                       final bids = latestBids.values.toList()
//                         ..sort((a, b) => b.amount.compareTo(a.amount));

//                       return SizedBox(
//                         height: 200,
//                         child: ListView.builder(
//                           itemCount: bids.length,
//                           itemBuilder: (context, index) {
//                             final bid = bids[index];
//                             return FutureBuilder<DocumentSnapshot>(
//                               future: FirebaseFirestore.instance
//                                   .collection('users')
//                                   .doc(bid.userId)
//                                   .get(),
//                               builder: (context, userSnapshot) {
//                                 if (!userSnapshot.hasData) {
//                                   return const ListTile(
//                                     leading: CircleAvatar(
//                                       child: Icon(Icons.person),
//                                     ),
//                                     title: Text("Loading..."),
//                                   );
//                                 }
//                                 final userData =
//                                     userSnapshot.data!.data()
//                                         as Map<String, dynamic>?;
//                                 final profileUrl =
//                                     userData?['profileImageUrl'] ?? "";
//                                 final userName = userData?['name'] ?? "User";

//                                 return ListTile(
//                                   leading: CircleAvatar(
//                                     backgroundImage: profileUrl.isNotEmpty
//                                         ? NetworkImage(profileUrl)
//                                         : null,
//                                     child: profileUrl.isEmpty
//                                         ? const Icon(Icons.person)
//                                         : null,
//                                   ),
//                                   title: Text(userName),
//                                   subtitle: Text(
//                                     "\$${bid.amount.toStringAsFixed(2)}",
//                                   ),
//                                   trailing: Text(
//                                     timeAgo(bid.createdAt.toDate()),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ],

//                 const SizedBox(height: 16),

//                 // Action Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (auction.type == 'fixed') {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 CheckoutScreen(auctionId: auction.auctionId),
//                           ),
//                         );
//                       } else if (auction.type == 'english') {
//                         if (!isEnded) {
//                           _showPlaceBidDialog(context, auction);
//                         } else if (isWinner) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   CheckoutScreen(auctionId: auction.auctionId),
//                             ),
//                           );
//                         }
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           (auction.type == 'english' && isEnded && !isWinner)
//                           ? Colors.grey
//                           : AppColors.accent,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text(
//                       auction.type == 'fixed'
//                           ? "Buy Now"
//                           : (!isEnded
//                                 ? "Place Bid"
//                                 : (isWinner ? "Pay Now" : "Ended")),
//                       style: GoogleFonts.lato(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showPlaceBidDialog(BuildContext context, AuctionModel auction) {
//     final user = FirebaseAuth.instance.currentUser;
//     final double currentBid = auction.currentBid ?? auction.startingBid;
//     final bool isSeller = user?.uid == auction.sellerId;
//     final bool isEnded = auction.endTime.toDate().isBefore(DateTime.now());

//     // Check if auction ended
//     if (isEnded) {
//       _showSnack(context, "Auction has ended", AppColors.primary);
//       return;
//     }

//     // Check if current user is seller
//     if (isSeller) {
//       _showSnack(
//         context,
//         "You cannot place a bid on your own auction",
//         AppColors.primary,
//       );
//       return;
//     }

//     // If checks pass, show dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: Row(
//             children: [
//               const Icon(Icons.gavel_rounded, color: AppColors.primary),
//               const SizedBox(width: 8),
//               Text(
//                 "Place Your Bid",
//                 style: GoogleFonts.lato(
//                   fontWeight: FontWeight.w800,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Current Bid: \$${currentBid.toStringAsFixed(2)}",
//                 style: GoogleFonts.lato(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: AppColors.primary,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: textBidController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: "Enter your bid",
//                   prefixIcon: const Icon(
//                     Icons.currency_rupee,
//                     color: AppColors.textSecondary,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             OutlinedButton(
//               onPressed: () => Navigator.pop(context),
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: const Color(0xFFE53935),
//                 side: const BorderSide(color: Color(0xFFE53935)),
//               ),
//               child: Text(
//                 "Cancel",
//                 style: GoogleFonts.lato(fontWeight: FontWeight.w600),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final newBid = double.tryParse(textBidController.text.trim());
//                 if (newBid == null)
//                   return _showSnack(
//                     context,
//                     "Enter a valid bid amount",
//                     AppColors.accent,
//                   );
//                 if (newBid <= currentBid)
//                   return _showSnack(
//                     context,
//                     "Bid must be higher than current bid",
//                     AppColors.accent,
//                   );

//                 try {
//                   await _bidController.placeBid(
//                     auctionId: auction.auctionId,
//                     bidAmount: newBid,
//                   );
//                   textBidController.clear();
//                   Navigator.pop(context);
//                   _showSnack(
//                     context,
//                     "Bid placed successfully!",
//                     AppColors.success,
//                   );
//                 } catch (e) {
//                   _showSnack(
//                     context,
//                     e.toString().replaceAll('Exception: ', ''),
//                     AppColors.accent,
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//               ),
//               child: Text(
//                 "Place Bid",
//                 style: GoogleFonts.lato(fontWeight: FontWeight.w600),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // void _showPlaceBidDialog(BuildContext context, AuctionModel auction) {
//   //   final double currentBid = auction.currentBid ?? auction.startingBid;
//   //   showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (_) {
//   //       return AlertDialog(
//   //         shape: RoundedRectangleBorder(
//   //           borderRadius: BorderRadius.circular(16),
//   //         ),
//   //         title: Row(
//   //           children: [
//   //             const Icon(Icons.gavel_rounded, color: AppColors.primary),
//   //             const SizedBox(width: 8),
//   //             Text(
//   //               "Place Your Bid",
//   //               style: GoogleFonts.lato(
//   //                 fontWeight: FontWeight.w800,
//   //                 fontSize: 16,
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //         content: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             Text(
//   //               "Current Bid: \$${currentBid.toStringAsFixed(2)}",
//   //               style: GoogleFonts.lato(
//   //                 fontWeight: FontWeight.w600,
//   //                 fontSize: 16,
//   //                 color: AppColors.primary,
//   //               ),
//   //             ),
//   //             const SizedBox(height: 12),
//   //             TextField(
//   //               controller: textBidController,
//   //               keyboardType: TextInputType.number,
//   //               decoration: InputDecoration(
//   //                 labelText: "Enter your bid",
//   //                 prefixIcon: const Icon(
//   //                   Icons.currency_rupee,
//   //                   color: AppColors.textSecondary,
//   //                 ),
//   //                 border: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(12),
//   //                 ),
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //         actions: [
//   //           OutlinedButton(
//   //             onPressed: () => Navigator.pop(context),
//   //             style: OutlinedButton.styleFrom(
//   //               foregroundColor: const Color(0xFFE53935),
//   //               side: const BorderSide(color: Color(0xFFE53935)),
//   //             ),
//   //             child: Text(
//   //               "Cancel",
//   //               style: GoogleFonts.lato(fontWeight: FontWeight.w600),
//   //             ),
//   //           ),
//   //           ElevatedButton(
//   //             onPressed: () async {
//   //               final newBid = double.tryParse(textBidController.text.trim());
//   //               if (newBid == null)
//   //                 return _showSnack(
//   //                   context,
//   //                   "Enter a valid bid amount",
//   //                   AppColors.accent,
//   //                 );
//   //               if (newBid <= currentBid)
//   //                 return _showSnack(
//   //                   context,
//   //                   "Bid must be higher than current bid",
//   //                   AppColors.accent,
//   //                 );

//   //               try {
//   //                 await _bidController.placeBid(
//   //                   auctionId: auction.auctionId,
//   //                   bidAmount: newBid,
//   //                 );
//   //                 textBidController.clear();
//   //                 Navigator.pop(context);
//   //                 _showSnack(
//   //                   context,
//   //                   "Bid placed successfully!",
//   //                   AppColors.success,
//   //                 );
//   //               } catch (e) {
//   //                 _showSnack(
//   //                   context,
//   //                   e.toString().replaceAll('Exception: ', ''),
//   //                   AppColors.accent,
//   //                 );
//   //               }
//   //             },
//   //             style: ElevatedButton.styleFrom(
//   //               backgroundColor: AppColors.primary,
//   //             ),
//   //             child: Text(
//   //               "Place Bid",
//   //               style: GoogleFonts.lato(fontWeight: FontWeight.w600),
//   //             ),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }

//   void _showSnack(BuildContext context, String msg, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           msg,
//           style: GoogleFonts.lato(fontWeight: FontWeight.w800),
//         ),
//         backgroundColor: color,
//       ),
//     );
//   }
// }
