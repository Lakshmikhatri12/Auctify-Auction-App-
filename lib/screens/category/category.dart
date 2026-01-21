// import 'package:auctify/controllers/auction_controller.dart';
// import 'package:auctify/models/auction_model.dart';
// import 'package:auctify/screens/auction/auction_detail_screen.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CategoryScreen extends StatelessWidget {
//   final String category;
//   final AuctionController _auctionController = AuctionController();

//   CategoryScreen({super.key, required this.category});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: Text(
//           category,
//           style: GoogleFonts.archivo(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: StreamBuilder<List<AuctionModel>>(
//         stream: _auctionController.streamAuctionsByCategory(category),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Text("Error loading auctions", style: GoogleFonts.lato()),
//             );
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Text(
//                 "No auctions in this category",
//                 style: GoogleFonts.lato(fontSize: 16),
//               ),
//             );
//           }

//           final auctions = snapshot.data!;
//           final englishAuctions = auctions
//               .where((a) => a.type == "english")
//               .toList();
//           final fixedAuctions = auctions
//               .where((a) => a.type == "fixed")
//               .toList();

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (englishAuctions.isNotEmpty) ...[
//                   _sectionTitle("English Auctions"),
//                   _auctionList(englishAuctions, context),
//                 ],
//                 if (fixedAuctions.isNotEmpty) ...[
//                   _sectionTitle("Fixed Price Auctions"),
//                   _auctionList(fixedAuctions, context),
//                 ],
//                 if (englishAuctions.isEmpty && fixedAuctions.isEmpty)
//                   Center(
//                     child: Text(
//                       "No auctions available",
//                       style: GoogleFonts.lato(fontSize: 16),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // ---------------- SECTION TITLE ----------------
//   Widget _sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Text(
//         title,
//         style: GoogleFonts.archivo(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: AppColors.textPrimary,
//         ),
//       ),
//     );
//   }

//   // ---------------- AUCTION LIST ----------------
//   Widget _auctionList(List<AuctionModel> auctions, BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: auctions.length,
//       itemBuilder: (context, index) {
//         final auction = auctions[index];

//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) =>
//                     AuctionDetailScreen(auctionId: auction.auctionId),
//               ),
//             );
//           },
//           child: Card(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 // IMAGE
//                 Container(
//                   height: 100,
//                   width: 100,
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(12),
//                       bottomLeft: Radius.circular(12),
//                     ),
//                     image: DecorationImage(
//                       fit: BoxFit.cover,
//                       image: NetworkImage(
//                         auction.imageUrls.isNotEmpty
//                             ? auction.imageUrls.first
//                             : "https://via.placeholder.com/150",
//                       ),
//                     ),
//                   ),
//                 ),

//                 // DETAILS
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           auction.title,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: GoogleFonts.archivo(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           auction.description,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: GoogleFonts.lato(
//                             fontSize: 14,
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               auction.type == 'fixed'
//                                   ? "\$${auction.startingBid.toStringAsFixed(2)}"
//                                   : "Current: \$${(auction.currentBid ?? auction.startingBid).toStringAsFixed(2)}",
//                               style: GoogleFonts.archivo(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.success,
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 5,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: AppColors.primary.withOpacity(0.15),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 auction.type == 'fixed'
//                                     ? "Buy Now"
//                                     : "Place Bid",
//                                 style: GoogleFonts.lato(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.primary,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Category: ${auction.category}",
//                           style: GoogleFonts.lato(
//                             fontSize: 12,
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:auctify/controllers/auction_controller.dart';
import 'package:auctify/models/auction_model.dart';
import 'package:auctify/screens/auction/auction_detail.dart';

import 'package:auctify/utils/auctionCard.dart';
import 'package:auctify/utils/constants.dart';
import 'package:auctify/utils/notification_Icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  final AuctionController _auctionController = AuctionController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: GoogleFonts.archivo(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        actions: [NotificationIcon(), SizedBox(width: 5)],
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: AppColors.primary,
          labelStyle: GoogleFonts.archivo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          labelColor: AppColors.primary,
          unselectedLabelColor: Theme.of(context).textTheme.titleMedium?.color,
          controller: _tabController,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "English"),
            Tab(text: "Fixed"),
          ],
        ),
      ),
      body: StreamBuilder<List<AuctionModel>>(
        stream: _auctionController.streamAuctionsByCategory(widget.category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error loading auctions", style: GoogleFonts.lato()),
            );
          }

          final auctions = snapshot.data ?? [];

          // Filter auctions by type
          final englishAuctions = auctions
              .where((a) => a.type == 'english')
              .toList();
          final fixedAuctions = auctions
              .where((a) => a.type == 'fixed')
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildGridView(auctions),
              _buildGridView(englishAuctions),
              _buildGridView(fixedAuctions),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGridView(List<AuctionModel> auctions) {
    if (auctions.isEmpty) {
      return Center(
        child: Text(
          "No auctions available",
          style: GoogleFonts.lato(fontSize: 16),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        itemCount: auctions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 284,
          mainAxisSpacing: 12,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final auction = auctions[index];
          return AuctionCard(
            auctionModel: auction,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      AuctionDetailScreen(auctionId: auction.auctionId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
