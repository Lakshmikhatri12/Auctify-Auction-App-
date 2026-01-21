// import 'package:auctify/utils/constants.dart';
// import 'package:flutter/material.dart';

// class RecommendedAuctions extends StatelessWidget {
//   const RecommendedAuctions({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: 5,
//       itemBuilder: (context, index) => Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 5),
//             child: Stack(
//               children: [
//                 Container(
//                   width: 300,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     image: DecorationImage(
//                       fit: BoxFit.fill,
//                       image: NetworkImage(
//                         "https://cdn.pixabay.com/photo/2023/01/16/18/53/binoculars-7723093_1280.jpg",
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   left: 10,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       color: Colors.white30.withOpacity(0.5),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: Text(
//                         "22:12:12",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:auctify/controllers/auction_controller.dart';
import 'package:auctify/models/auction_model.dart';
import 'package:auctify/screens/auction/auction_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecommendedAuctions extends StatefulWidget {
  const RecommendedAuctions({super.key});

  @override
  State<RecommendedAuctions> createState() => _RecommendedAuctionsState();
}

class _RecommendedAuctionsState extends State<RecommendedAuctions> {
  final AuctionController _auctionController = AuctionController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update UI every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AuctionModel>>(
      stream: _auctionController.streamAllAuctions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text("No auctions found")),
          );
        }

        // Filter English auctions and take latest 5
        List<AuctionModel> englishAuctions = snapshot.data!
            .where((auction) => auction.type == 'english')
            .toList();

        englishAuctions.sort((a, b) => b.startTime.compareTo(a.startTime));

        final displayAuctions = englishAuctions.take(5).toList();

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: displayAuctions.length,
            itemBuilder: (context, index) {
              final auction = displayAuctions[index];
              final imageUrl = auction.imageUrls.isNotEmpty
                  ? auction.imageUrls[0]
                  : '';

              // Calculate remaining time
              final remaining = auction.endTime.toDate().difference(
                DateTime.now(),
              );
              final isExpired = remaining.isNegative;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AuctionDetailScreen(
                              auctionId:
                                  auction.auctionId, // ✅ use 'auction' here
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: imageUrl.isNotEmpty
                                ? NetworkImage(imageUrl)
                                : const NetworkImage(
                                    "https://cdn.pixabay.com/photo/2023/01/16/18/53/binoculars-7723093_1280.jpg",
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white30.withOpacity(0.5),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          isExpired ? "Ended" : formatDuration(remaining),
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// import 'package:auctify/models/auction_model.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class RecommendedAuctions extends StatelessWidget {
//   const RecommendedAuctions({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Stream latest 5 fixed auctions
//     Stream<List<AuctionModel>> auctionStream = FirebaseFirestore.instance
//         .collection('auctions')
//         .where('type', isEqualTo: 'fixed') // only fixed auctions
//         .orderBy('createdAt', descending: true) // latest first
//         .limit(5)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map(
//                 (doc) => AuctionModel.fromFirestore(
//                   doc.data() as Map<String, dynamic>,
//                   doc.id,
//                 ),
//               )
//               .toList(),
//         );

//     return SizedBox(
//       height: 200,
//       child: StreamBuilder<List<AuctionModel>>(
//         stream: auctionStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No recommended auctions"));
//           }

//           final auctions = snapshot.data!;

//           return ListView.separated(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             itemCount: auctions.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 12),
//             itemBuilder: (context, index) {
//               final auction = auctions[index];

//               return Stack(
//                 children: [
//                   Container(
//                     width: 300,
//                     height: 200,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       image: DecorationImage(
//                         fit: BoxFit.cover,
//                         image: NetworkImage(
//                           auction.imageUrls.isNotEmpty
//                               ? auction.imageUrls.first
//                               : 'https://via.placeholder.com/300x200',
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 10,
//                     left: 10,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         color: Colors.white30.withOpacity(0.5),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(5.0),
//                         child: Text(
//                           auction.type == 'fixed'
//                               ? 'Fixed Auction'
//                               : auction.type,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
