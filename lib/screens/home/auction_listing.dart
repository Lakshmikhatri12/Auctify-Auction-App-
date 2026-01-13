import 'package:auctify/models/auction_model.dart';
import 'package:auctify/screens/auction/auction_detail_screen.dart';
import 'package:auctify/utils/auctionCard.dart';
import 'package:auctify/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuctionListingScreen extends StatefulWidget {
  const AuctionListingScreen({super.key});

  @override
  State<AuctionListingScreen> createState() => _AuctionListingScreenState();
}

class _AuctionListingScreenState extends State<AuctionListingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.scaffoldBg,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_none, color: AppColors.primary),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// 🔍 SEARCH BAR
            Row(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {},
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: const [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              "Search auctions",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.primary,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_alt, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// 🧩 AUCTION GRID
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('auctions')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No auctions available"));
                  }

                  final auctions = snapshot.data!.docs;

                  return GridView.builder(
                    itemCount: auctions.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 284,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 10,
                        ),
                    itemBuilder: (context, index) {
                      final doc = auctions[index];
                      final data = doc.data() as Map<String, dynamic>;

                      /// ✅ Convert Firestore → AuctionModel
                      final auctionModel = AuctionModel.fromFirestore(
                        data,
                        doc.id,
                      );

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AuctionDetailScreen(
                                auctionId: auctionModel.auctionId,
                              ),
                            ),
                          );
                        },
                        child: AuctionCard(auctionModel: auctionModel),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 FIXED + ENGLISH PRICE HANDLER
  String _getAuctionPriceText(AuctionModel auction) {
    if (auction.type == 'english') {
      final price = auction.currentBid ?? auction.startingBid;
      return '\$${price.toStringAsFixed(0)}';
    } else {
      return '\$${auction.startingBid.toStringAsFixed(0)}';
    }
  }
}

// import 'package:auctify/controllers/auction_controller.dart';
// import 'package:auctify/models/auction_model.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shimmer/shimmer.dart';

// class AuctionListingScreen extends StatefulWidget {
//   const AuctionListingScreen({super.key});

//   @override
//   State<AuctionListingScreen> createState() => _AuctionListingScreenState();
// }

// class _AuctionListingScreenState extends State<AuctionListingScreen> {
//   final AuctionController _auctionController = AuctionController();
//   String selectedCategory = 'All';
//   String searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: AppBar(
//         backgroundColor: AppColors.scaffoldBg,
//         elevation: 0,
//         title: _searchBar(),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 12),
//             _categoryFilters(),
//             const SizedBox(height: 16),
//             Expanded(
//               child: StreamBuilder<List<AuctionModel>>(
//                 stream: _auctionController.streamAllAuctions(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return _shimmerLoading();
//                   }

//                   final auctions = snapshot.data!
//                       .where(
//                         (a) =>
//                             selectedCategory == 'All' ||
//                             a.category == selectedCategory,
//                       )
//                       .where(
//                         (a) => a.title.toLowerCase().contains(
//                           searchQuery.toLowerCase(),
//                         ),
//                       )
//                       .toList();

//                   if (auctions.isEmpty) {
//                     return const Center(child: Text("No auctions found"));
//                   }

//                   return ListView(
//                     children: [
//                       Text(
//                         "Recommended",
//                         style: GoogleFonts.archivo(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       SizedBox(
//                         height: 250,
//                         child: ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: auctions.length,
//                           separatorBuilder: (_, __) =>
//                               const SizedBox(width: 12),
//                           itemBuilder: (context, index) =>
//                               _auctionCardHorizontal(auctions[index]),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         "All Auctions",
//                         style: GoogleFonts.archivo(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       ...auctions.map(
//                         (auction) => Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           child: _auctionCardVertical(auction),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // SEARCH BAR
//   Widget _searchBar() {
//     return TextField(
//       onChanged: (value) => setState(() => searchQuery = value),
//       decoration: InputDecoration(
//         hintText: 'Search auctions...',
//         filled: true,
//         fillColor: Colors.white,
//         prefixIcon: const Icon(Icons.search, color: Colors.grey),
//         contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }

//   // CATEGORY FILTER CHIPS
//   Widget _categoryFilters() {
//     final categories = [
//       'All',
//       'Fixed',
//       'English',
//       'Furniture',
//       'Electronics',
//       'Antiques',
//     ];

//     return SizedBox(
//       height: 40,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: categories.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 8),
//         itemBuilder: (context, index) {
//           final category = categories[index];
//           final isSelected = category == selectedCategory;
//           return GestureDetector(
//             onTap: () => setState(() => selectedCategory = category),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: isSelected ? AppColors.primary : Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: AppColors.primary),
//                 boxShadow: isSelected
//                     ? [
//                         BoxShadow(
//                           color: AppColors.primary.withOpacity(0.4),
//                           blurRadius: 8,
//                         ),
//                       ]
//                     : [],
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 category,
//                 style: GoogleFonts.archivo(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                   color: isSelected ? Colors.white : AppColors.textPrimary,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // HORIZONTAL AUCTION CARD
//   Widget _auctionCardHorizontal(AuctionModel auction) {
//     return Container(
//       width: 180,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             child: Image.network(
//               auction.imageUrls.isNotEmpty ? auction.imageUrls[0] : '',
//               height: 120,
//               width: 180,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             child: Text(
//               auction.title,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Text(
//               auction.type == 'fixed'
//                   ? "Buy Now: \$${auction.startingBid}"
//                   : "Bid Now: \$${auction.startingBid}",
//               style: const TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//           ),
//           const Spacer(),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 minimumSize: const Size.fromHeight(35),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Text(auction.type == 'fixed' ? "Buy Now" : "Bid Now"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // VERTICAL AUCTION CARD
//   Widget _auctionCardVertical(AuctionModel auction) {
//     return Container(
//       height: 140,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.horizontal(
//               left: Radius.circular(16),
//             ),
//             child: Image.network(
//               auction.imageUrls.isNotEmpty ? auction.imageUrls[0] : '',
//               width: 140,
//               height: 140,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     auction.title,
//                     style: GoogleFonts.archivo(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: AppColors.textPrimary,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     auction.type == 'fixed'
//                         ? "Buy Now: \$${auction.startingBid}"
//                         : "Starting Bid: \$${auction.startingBid}",
//                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   const Spacer(),
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         minimumSize: const Size(90, 36),
//                       ),
//                       child: Text(
//                         auction.type == 'fixed' ? "Buy Now" : "Bid Now",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // SHIMMER LOADING PLACEHOLDER
//   Widget _shimmerLoading() {
//     return ListView.builder(
//       itemCount: 5,
//       itemBuilder: (_, __) => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Shimmer.fromColors(
//           baseColor: Colors.grey.shade300,
//           highlightColor: Colors.grey.shade100,
//           child: Container(
//             height: 140,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
