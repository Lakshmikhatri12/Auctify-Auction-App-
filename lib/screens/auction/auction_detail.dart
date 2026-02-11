// import 'dart:async';
// import 'package:auctify/controllers/auction_controller.dart';
// import 'package:auctify/controllers/bid_controller.dart';
// import 'package:auctify/models/auction_model.dart';
// import 'package:auctify/models/bid_model.dart';
// import 'package:auctify/screens/checkout/checkout.dart';
// import 'package:auctify/screens/chat/chat_screen.dart';
// import 'package:auctify/screens/watchlist.dart';
// import 'package:auctify/services/user_service.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AuctionDetailScreen extends StatefulWidget {
//   final String auctionId;
//   const AuctionDetailScreen({super.key, required this.auctionId, required AuctionModel auction});

//   @override
//   State<AuctionDetailScreen> createState() => _AuctionDetailScreenState();
// }

// class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
//   final UserService _userService = UserService();

//   final AuctionController _auctionController = AuctionController();
//   final BidController _bidController = BidController();
//   final TextEditingController textBidController = TextEditingController();
//   final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

//   Timer? _timer;
//   Duration? _timeLeft;
//   int selectedIndex = 0;
//   bool isWishlisted = false;
//   bool loading = true;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _auctionController.finalizeAuction(
//   //     widget.auctionId,
//   //   ); // ensure English auction is finalized
//   // }

//   @override
//   void initState() {
//     super.initState();
//     _checkWishlist();
//   }

//   Future<void> _checkWishlist() async {
//     final result = await _userService.isWishlisted(
//       currentUserId,
//       widget.auctionId,
//     );
//     setState(() {
//       isWishlisted = result;
//       loading = false;
//     });
//   }

//   Future<void> _toggleWishlist() async {
//     await _userService.toggleWishlist(currentUserId, widget.auctionId);

//     setState(() {
//       isWishlisted = !isWishlisted;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: AppColors.primary,
//         content: Text(
//           isWishlisted ? "Added to WatchList" : "Removed from WatchList",
//         ),
//       ),
//     );
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
//         final productImages = auction.imageUrls;

//         // Start timer for English auctions
//         if (auction.type == 'english' && _timeLeft == null) {
//           _startTimer(auction.endTime.toDate(), auction.auctionId);
//         }

//         return Scaffold(
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           body: CustomScrollView(
//             slivers: [
//               _buildSliverAppBar(auction, productImages),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20.0,
//                     vertical: 10,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildImageThumbnails(productImages),
//                       const SizedBox(height: 25),
//                       _buildTitleAndPrice(auction),
//                       const SizedBox(height: 20),
//                       _buildDescription(auction),
//                       const SizedBox(height: 25),
//                       _buildSellerCard(auction),
//                       SizedBox(height: auction.type == 'fixed' ? 100 : 25),
//                       if (auction.type != 'fixed') ...[
//                         _buildBidsSection(auction),
//                         const SizedBox(height: 100),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           bottomSheet: _buildBottomActionBar(auction, isEnded, isWinner),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ChatScreen(
//                     receiverId: auction.sellerId,
//                     receiverName: auction.sellerName,
//                   ),
//                 ),
//               );
//             },
//             backgroundColor: Colors.blue,
//             child: const Icon(Icons.message_outlined, color: Colors.white),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSliverAppBar(AuctionModel auction, List<String> productImages) {
//     return SliverAppBar(
//       expandedHeight: 400.0,
//       pinned: true,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       elevation: 0,
//       leading: Container(
//         margin: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
//           shape: BoxShape.circle,
//         ),
//         child: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             color: Theme.of(context).iconTheme.color,
//             size: 20,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       actions: [
//         Container(
//           margin: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
//             shape: BoxShape.circle,
//           ),
//           child: IconButton(
//             icon: Icon(
//               isWishlisted ? Icons.favorite : Icons.favorite_border,
//               color: isWishlisted
//                   ? AppColors.primary
//                   : Theme.of(context).iconTheme.color,
//             ),
//             onPressed: _toggleWishlist,
//           ),
//         ),
//       ],
//       flexibleSpace: FlexibleSpaceBar(
//         background: Hero(
//           tag: auction.auctionId,
//           child: Image.network(productImages[selectedIndex], fit: BoxFit.cover),
//         ),
//       ),
//     );
//   }

//   Widget _buildImageThumbnails(List<String> productImages) {
//     return SizedBox(
//       height: 70,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: productImages.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 12),
//         itemBuilder: (context, index) {
//           final isSelected = selectedIndex == index;
//           return GestureDetector(
//             onTap: () => setState(() => selectedIndex = index),
//             child: Container(
//               width: 70,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: isSelected
//                       ? Theme.of(context).primaryColor
//                       : Colors.transparent,
//                   width: 2,
//                 ),
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: NetworkImage(productImages[index]),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTitleAndPrice(AuctionModel auction) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Text(
//                 auction.title,
//                 style: GoogleFonts.plusJakartaSans(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).textTheme.titleLarge?.color,
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).primaryColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 auction.category,
//                 style: GoogleFonts.inter(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Text(
//               auction.type == 'fixed'
//                   ? "\$${auction.startingBid.toStringAsFixed(2)}"
//                   : "\$${auction.currentBid?.toStringAsFixed(2) ?? auction.startingBid.toStringAsFixed(2)}",
//               style: GoogleFonts.plusJakartaSans(
//                 fontSize: 32,
//                 fontWeight: FontWeight.w800,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             const Spacer(),
//             if (auction.type == 'english' && _timeLeft != null)
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.red.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.timer_outlined,
//                       size: 16,
//                       color: Colors.red,
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       _timeLeft!.inSeconds > 0
//                           ? _formatDuration(_timeLeft!)
//                           : "Ended",
//                       style: GoogleFonts.inter(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             Icon(
//               Icons.location_on_outlined,
//               size: 16,
//               color: Theme.of(context).textTheme.bodySmall?.color,
//             ),
//             const SizedBox(width: 4),
//             Text(
//               auction.location,
//               style: GoogleFonts.inter(
//                 fontSize: 14,
//                 color: Theme.of(context).textTheme.bodySmall?.color,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildDescription(AuctionModel auction) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Description",
//           style: GoogleFonts.plusJakartaSans(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).textTheme.titleMedium?.color,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           auction.description,
//           style: GoogleFonts.inter(
//             fontSize: 15,
//             height: 1.5,
//             color: Theme.of(context).textTheme.bodyMedium?.color,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSellerCard(AuctionModel auction) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardTheme.color,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           FutureBuilder<DocumentSnapshot>(
//             future: FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(auction.sellerId)
//                 .get(),
//             builder: (context, snapshot) {
//               final userData = snapshot.data?.data() as Map<String, dynamic>?;
//               final profileUrl = userData?['profileImageUrl'] ?? "";
//               return CircleAvatar(
//                 radius: 24,
//                 backgroundImage: profileUrl.isNotEmpty
//                     ? NetworkImage(profileUrl)
//                     : null,
//                 backgroundColor: Theme.of(
//                   context,
//                 ).primaryColor.withOpacity(0.1),
//                 child: profileUrl.isEmpty
//                     ? Icon(Icons.person, color: Theme.of(context).primaryColor)
//                     : null,
//               );
//             },
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   auction.sellerName,
//                   style: GoogleFonts.plusJakartaSans(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Theme.of(context).textTheme.titleLarge?.color,
//                   ),
//                 ),
//                 Text(
//                   "Seller",
//                   style: GoogleFonts.inter(
//                     fontSize: 12,
//                     color: Theme.of(context).textTheme.bodySmall?.color,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBidsSection(AuctionModel auction) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Recent Bids",
//               style: GoogleFonts.plusJakartaSans(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).textTheme.titleMedium?.color,
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(
//                 //     builder: (context) => BidHistoryScreen(
//                 //       auctionId: auction.auctionId,
//                 //     ),
//                 //   ),
//                 // );
//               },
//               child: Text(
//                 "View All",
//                 style: GoogleFonts.inter(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ),
//             ),
//           ],
//         ),

//         StreamBuilder<List<BidModel>>(
//           stream: _bidController.getAuctionBids(auction.auctionId),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Text(
//                 "No bids yet. Be the first!",
//                 style: GoogleFonts.inter(
//                   color: Theme.of(context).textTheme.bodySmall?.color,
//                 ),
//               );
//             }

//             final allBids = snapshot.data!;
//             final Map<String, BidModel> latestBids = {};
//             for (var bid in allBids) {
//               if (!latestBids.containsKey(bid.userId) ||
//                   bid.createdAt.toDate().isAfter(
//                     latestBids[bid.userId]!.createdAt.toDate(),
//                   )) {
//                 latestBids[bid.userId] = bid;
//               }
//             }

//             final bids = latestBids.values.toList()
//               ..sort((a, b) => b.amount.compareTo(a.amount));

//             return ListView.separated(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: bids.length > 5 ? 5 : bids.length, // Show top 5
//               separatorBuilder: (_, __) => const SizedBox(height: 8),
//               itemBuilder: (context, index) {
//                 final bid = bids[index];
//                 return FutureBuilder<DocumentSnapshot>(
//                   future: FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(bid.userId)
//                       .get(),
//                   builder: (context, userSnapshot) {
//                     final userData =
//                         userSnapshot.data?.data() as Map<String, dynamic>?;
//                     final profileUrl = userData?['profileImageUrl'] ?? "";
//                     final userName = userData?['name'] ?? "User";

//                     return Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).cardTheme.color,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Theme.of(
//                             context,
//                           ).dividerColor.withOpacity(0.1),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 16,
//                             backgroundImage: profileUrl.isNotEmpty
//                                 ? NetworkImage(profileUrl)
//                                 : null,
//                             child: profileUrl.isEmpty
//                                 ? const Icon(Icons.person, size: 16)
//                                 : null,
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               userName,
//                               style: GoogleFonts.inter(
//                                 fontWeight: FontWeight.w600,
//                                 color: Theme.of(
//                                   context,
//                                 ).textTheme.bodyLarge?.color,
//                               ),
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 "\$${bid.amount.toStringAsFixed(2)}",
//                                 style: GoogleFonts.inter(
//                                   fontWeight: FontWeight.bold,
//                                   color: Theme.of(context).primaryColor,
//                                 ),
//                               ),
//                               Text(
//                                 timeAgo(bid.createdAt.toDate()),
//                                 style: GoogleFonts.inter(
//                                   fontSize: 10,
//                                   color: Theme.of(
//                                     context,
//                                   ).textTheme.bodySmall?.color,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildBottomActionBar(
//     AuctionModel auction,
//     bool isEnded,
//     bool isWinner,
//   ) {
//     if (auction.type == 'english' && isEnded && !isWinner)
//       return const SizedBox.shrink();

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardTheme.color,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 20,
//             offset: const Offset(0, -5),
//           ),
//         ],
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: SafeArea(
//         child: SizedBox(
//           width: double.infinity,
//           height: 56,
//           child: ElevatedButton(
//             onPressed: () {
//               if (auction.type == 'fixed') {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         CheckoutScreen(auctionId: auction.auctionId),
//                   ),
//                 );
//               } else if (auction.type == 'english') {
//                 if (!isEnded) {
//                   _showPlaceBidDialog(context, auction);
//                 } else if (isWinner) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           CheckoutScreen(auctionId: auction.auctionId),
//                     ),
//                   );
//                 }
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Theme.of(context).primaryColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               elevation: 4,
//             ),
//             child: Text(
//               auction.type == 'fixed'
//                   ? "Buy Now"
//                   : (!isEnded ? "Place Bid" : "Pay Now"),
//               style: GoogleFonts.plusJakartaSans(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
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
//                     Icons.attach_money,
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

import 'dart:async';
import 'package:auctify/controllers/auction_controller.dart';
import 'package:auctify/controllers/bid_controller.dart';
import 'package:auctify/models/auction_model.dart';
import 'package:auctify/models/bid_model.dart';
import 'package:auctify/screens/auction/auction_bids_screen.dart';
import 'package:auctify/screens/checkout/checkout.dart';
import 'package:auctify/screens/chat/chat_screen.dart';
import 'package:auctify/services/user_service.dart';
import 'package:auctify/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuctionDetailScreen extends StatefulWidget {
  final String auctionId;
  const AuctionDetailScreen({super.key, required this.auctionId});

  @override
  State<AuctionDetailScreen> createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
  final UserService _userService = UserService();

  final AuctionController _auctionController = AuctionController();
  final BidController _bidController = BidController();
  final TextEditingController textBidController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Timer? _timer;
  Duration? _timeLeft;
  int selectedIndex = 0;
  bool isWishlisted = false;
  bool loading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _auctionController.finalizeAuction(
  //     widget.auctionId,
  //   ); // ensure English auction is finalized
  // }

  @override
  void initState() {
    super.initState();
    _checkWishlist();
  }

  Future<void> _checkWishlist() async {
    final result = await _userService.isWishlisted(
      currentUserId,
      widget.auctionId,
    );
    setState(() {
      isWishlisted = result;
      loading = false;
    });
  }

  Future<void> _toggleWishlist() async {
    await _userService.toggleWishlist(currentUserId, widget.auctionId);

    setState(() {
      isWishlisted = !isWishlisted;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        content: Text(
          isWishlisted ? "Added to WatchList" : "Removed from WatchList",
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    textBidController.dispose();
    super.dispose();
  }

  void _startTimer(DateTime endTime, String auctionId) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final diff = endTime.difference(DateTime.now());
      setState(() {
        _timeLeft = diff.isNegative ? Duration.zero : diff;
      });

      if (diff.isNegative) {
        _timer?.cancel();
        await _auctionController.finalizeAuction(auctionId);
      }
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  String timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return "${diff.inSeconds}s ago";
    if (diff.inMinutes < 60)
      return "${diff.inMinutes} min${diff.inMinutes > 1 ? 's' : ''} ago";
    if (diff.inHours < 24)
      return "${diff.inHours} hr${diff.inHours > 1 ? 's' : ''} ago";
    if (diff.inDays < 7)
      return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago";
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuctionModel>(
      stream: _auctionController.streamAuction(widget.auctionId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final auction = snapshot.data!;
        final isEnded = auction.status == 'ended' || auction.status == 'sold';
        final isWinner = auction.winnerId == currentUserId;
        final productImages = auction.imageUrls;

        // Start timer for English auctions
        if (auction.type == 'english' && _timeLeft == null) {
          _startTimer(auction.endTime.toDate(), auction.auctionId);
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(auction, productImages),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageThumbnails(productImages),
                      const SizedBox(height: 25),
                      _buildTitleAndPrice(auction),
                      const SizedBox(height: 20),
                      _buildDescription(auction),
                      const SizedBox(height: 25),
                      _buildSellerCard(auction),
                      SizedBox(height: auction.type == 'fixed' ? 100 : 25),
                      if (auction.type != 'fixed') ...[
                        _buildBidsSection(auction),
                        const SizedBox(height: 100),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          bottomSheet: _buildBottomActionBar(auction, isEnded, isWinner),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    receiverId: auction.sellerId,
                    receiverName: auction.sellerName,
                  ),
                ),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.message_outlined, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(AuctionModel auction, List<String> productImages) {
    return SliverAppBar(
      expandedHeight: 400.0,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted
                  ? AppColors.primary
                  : Theme.of(context).iconTheme.color,
            ),
            onPressed: _toggleWishlist,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: auction.auctionId,
          child: Image.network(productImages[selectedIndex], fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildImageThumbnails(List<String> productImages) {
    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: productImages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedIndex = index),
            child: Container(
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  width: 2,
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(productImages[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleAndPrice(AuctionModel auction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                auction.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                auction.category,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              auction.type == 'fixed'
                  ? "\$${auction.startingBid.toStringAsFixed(2)}"
                  : "\$${auction.currentBid?.toStringAsFixed(2) ?? auction.startingBid.toStringAsFixed(2)}",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const Spacer(),
            if (auction.type == 'english' && _timeLeft != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _timeLeft!.inSeconds > 0
                          ? _formatDuration(_timeLeft!)
                          : "Ended",
                      style: GoogleFonts.inter(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            const SizedBox(width: 4),
            Text(
              auction.location,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(AuctionModel auction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          auction.description,
          style: GoogleFonts.inter(
            fontSize: 15,
            height: 1.5,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildSellerCard(AuctionModel auction) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(auction.sellerId)
                .get(),
            builder: (context, snapshot) {
              final userData = snapshot.data?.data() as Map<String, dynamic>?;
              final profileUrl = userData?['profileImageUrl'] ?? "";
              return CircleAvatar(
                radius: 24,
                backgroundImage: profileUrl.isNotEmpty
                    ? NetworkImage(profileUrl)
                    : null,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.1),
                child: profileUrl.isEmpty
                    ? Icon(Icons.person, color: Theme.of(context).primaryColor)
                    : null,
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auction.sellerName,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                Text(
                  "Seller",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidsSection(AuctionModel auction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Bids",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AuctionBidsScreen(auctionId: auction.auctionId),
                  ),
                );
              },
              child: Text(
                "View All",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),

        StreamBuilder<List<BidModel>>(
          stream: _bidController.getAuctionBids(auction.auctionId),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text(
                "No bids yet. Be the first!",
                style: GoogleFonts.inter(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              );
            }

            final allBids = snapshot.data!;
            final Map<String, BidModel> latestBids = {};
            for (var bid in allBids) {
              if (!latestBids.containsKey(bid.userId) ||
                  bid.createdAt.toDate().isAfter(
                    latestBids[bid.userId]!.createdAt.toDate(),
                  )) {
                latestBids[bid.userId] = bid;
              }
            }

            final bids = latestBids.values.toList()
              ..sort((a, b) => b.amount.compareTo(a.amount));

            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: bids.length > 5 ? 5 : bids.length, // Show top 5
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final bid = bids[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(bid.userId)
                      .get(),
                  builder: (context, userSnapshot) {
                    final userData =
                        userSnapshot.data?.data() as Map<String, dynamic>?;
                    final profileUrl = userData?['profileImageUrl'] ?? "";
                    final userName = userData?['name'] ?? "User";

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).dividerColor.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: profileUrl.isNotEmpty
                                ? NetworkImage(profileUrl)
                                : null,
                            child: profileUrl.isEmpty
                                ? const Icon(Icons.person, size: 16)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              userName,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "\$${bid.amount.toStringAsFixed(2)}",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                timeAgo(bid.createdAt.toDate()),
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(
    AuctionModel auction,
    bool isEnded,
    bool isWinner,
  ) {
    if (auction.type == 'english' && isEnded && !isWinner)
      return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              if (auction.type == 'fixed') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CheckoutScreen(auctionId: auction.auctionId),
                  ),
                );
              } else if (auction.type == 'english') {
                if (!isEnded) {
                  _showPlaceBidDialog(context, auction);
                } else if (isWinner) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CheckoutScreen(auctionId: auction.auctionId),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: Text(
              auction.type == 'fixed'
                  ? "Buy Now"
                  : (!isEnded ? "Place Bid" : "Pay Now"),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPlaceBidDialog(BuildContext context, AuctionModel auction) {
    final user = FirebaseAuth.instance.currentUser;
    final double currentBid = auction.currentBid ?? auction.startingBid;
    final bool isSeller = user?.uid == auction.sellerId;
    final bool isEnded = auction.endTime.toDate().isBefore(DateTime.now());

    // Check if auction ended
    if (isEnded) {
      _showSnack(context, "Auction has ended", AppColors.primary);
      return;
    }

    // Check if current user is seller
    if (isSeller) {
      _showSnack(
        context,
        "You cannot place a bid on your own auction",
        AppColors.primary,
      );
      return;
    }

    // If checks pass, show dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.gavel_rounded, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                "Place Your Bid",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Current Bid: \$${currentBid.toStringAsFixed(2)}",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textBidController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter your bid",
                  prefixIcon: const Icon(
                    Icons.attach_money,
                    color: AppColors.textSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE53935),
                side: const BorderSide(color: Color(0xFFE53935)),
              ),
              child: Text(
                "Cancel",
                style: GoogleFonts.lato(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final newBid = double.tryParse(textBidController.text.trim());
                if (newBid == null)
                  return _showSnack(
                    context,
                    "Enter a valid bid amount",
                    AppColors.accent,
                  );
                if (newBid <= currentBid)
                  return _showSnack(
                    context,
                    "Bid must be higher than current bid",
                    AppColors.accent,
                  );

                try {
                  await _bidController.placeBid(
                    auctionId: auction.auctionId,
                    bidAmount: newBid,
                  );
                  textBidController.clear();
                  Navigator.pop(context);
                  _showSnack(
                    context,
                    "Bid placed successfully!",
                    AppColors.success,
                  );
                } catch (e) {
                  _showSnack(
                    context,
                    e.toString().replaceAll('Exception: ', ''),
                    AppColors.accent,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                "Place Bid",
                style: GoogleFonts.lato(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  // void _showPlaceBidDialog(BuildContext context, AuctionModel auction) {
  //   final double currentBid = auction.currentBid ?? auction.startingBid;
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         title: Row(
  //           children: [
  //             const Icon(Icons.gavel_rounded, color: AppColors.primary),
  //             const SizedBox(width: 8),
  //             Text(
  //               "Place Your Bid",
  //               style: GoogleFonts.lato(
  //                 fontWeight: FontWeight.w800,
  //                 fontSize: 16,
  //               ),
  //             ),
  //           ],
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               "Current Bid: \$${currentBid.toStringAsFixed(2)}",
  //               style: GoogleFonts.lato(
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 16,
  //                 color: AppColors.primary,
  //               ),
  //             ),
  //             const SizedBox(height: 12),
  //             TextField(
  //               controller: textBidController,
  //               keyboardType: TextInputType.number,
  //               decoration: InputDecoration(
  //                 labelText: "Enter your bid",
  //                 prefixIcon: const Icon(
  //                   Icons.currency_rupee,
  //                   color: AppColors.textSecondary,
  //                 ),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           OutlinedButton(
  //             onPressed: () => Navigator.pop(context),
  //             style: OutlinedButton.styleFrom(
  //               foregroundColor: const Color(0xFFE53935),
  //               side: const BorderSide(color: Color(0xFFE53935)),
  //             ),
  //             child: Text(
  //               "Cancel",
  //               style: GoogleFonts.lato(fontWeight: FontWeight.w600),
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               final newBid = double.tryParse(textBidController.text.trim());
  //               if (newBid == null)
  //                 return _showSnack(
  //                   context,
  //                   "Enter a valid bid amount",
  //                   AppColors.accent,
  //                 );
  //               if (newBid <= currentBid)
  //                 return _showSnack(
  //                   context,
  //                   "Bid must be higher than current bid",
  //                   AppColors.accent,
  //                 );

  //               try {
  //                 await _bidController.placeBid(
  //                   auctionId: auction.auctionId,
  //                   bidAmount: newBid,
  //                 );
  //                 textBidController.clear();
  //                 Navigator.pop(context);
  //                 _showSnack(
  //                   context,
  //                   "Bid placed successfully!",
  //                   AppColors.success,
  //                 );
  //               } catch (e) {
  //                 _showSnack(
  //                   context,
  //                   e.toString().replaceAll('Exception: ', ''),
  //                   AppColors.accent,
  //                 );
  //               }
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: AppColors.primary,
  //             ),
  //             child: Text(
  //               "Place Bid",
  //               style: GoogleFonts.lato(fontWeight: FontWeight.w600),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: GoogleFonts.lato(fontWeight: FontWeight.w800),
        ),
        backgroundColor: color,
      ),
    );
  }
}
