// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/auction_model.dart';
// import '../utils/constants.dart';

// class AuctionListingCard extends StatelessWidget {
//   final String? category; // optional: filter by category

//   AuctionListingCard({super.key, this.category});

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     // Stream of auctions (optionally filtered by category)
//     Stream<List<AuctionModel>> auctionStream = category != null
//         ? _firestore
//               .collection('auctions')
//               .where('category', isEqualTo: category)
//               .snapshots()
//               .map(
//                 (snapshot) => snapshot.docs
//                     .map(
//                       (doc) => AuctionModel.fromFirestore(doc.data(), doc.id),
//                     )
//                     .toList(),
//               )
//         : _firestore
//               .collection('auctions')
//               .snapshots()
//               .map(
//                 (snapshot) => snapshot.docs
//                     .map(
//                       (doc) => AuctionModel.fromFirestore(doc.data(), doc.id),
//                     )
//                     .toList(),
//               );

//     return SizedBox(
//       height: 260,
//       child: StreamBuilder<List<AuctionModel>>(
//         stream: auctionStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No auctions available"));
//           }

//           final auctions = snapshot.data!;

//           return ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: auctions.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 12),
//             itemBuilder: (context, index) {
//               final auction = auctions[index];

//               return Container(
//                 width: 180,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 6,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadius.vertical(
//                         top: Radius.circular(16),
//                       ),
//                       child: auction.imageUrls.isNotEmpty
//                           ? Image.network(
//                               auction.imageUrls[0],
//                               height: 140,
//                               width: 180,
//                               fit: BoxFit.cover,
//                             )
//                           : Container(
//                               height: 140,
//                               width: 180,
//                               color: Colors.grey[300],
//                               child: const Icon(Icons.image, size: 50),
//                             ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 6,
//                       ),
//                       child: Text(
//                         auction.title,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8),
//                       child: Text(
//                         _getAuctionPriceText(auction),
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.blue,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ),
//                     const Spacer(),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   String _getAuctionPriceText(AuctionModel auction) {
//     if (auction.type == 'english') {
//       final price = auction.currentBid ?? auction.startingBid;
//       return ' \$${price.toStringAsFixed(0)}';
//     } else {
//       return ' \$${auction.startingBid.toStringAsFixed(0)}';
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/auction_model.dart';
import '../utils/constants.dart';

class AuctionListingCard extends StatefulWidget {
  final String? category; // optional: filter by category

  AuctionListingCard({super.key, this.category});

  @override
  State<AuctionListingCard> createState() => _AuctionListingCardState();
}

class _AuctionListingCardState extends State<AuctionListingCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Stream of auctions (optionally filtered by category)
    Stream<List<AuctionModel>> auctionStream = widget.category != null
        ? _firestore
              .collection('auctions')
              .where('category', isEqualTo: widget.category)
              .snapshots()
              .map(
                (snapshot) => snapshot.docs
                    .map(
                      (doc) => AuctionModel.fromFirestore(doc.data(), doc.id),
                    )
                    .toList(),
              )
        : _firestore
              .collection('auctions')
              .snapshots()
              .map(
                (snapshot) => snapshot.docs
                    .map(
                      (doc) => AuctionModel.fromFirestore(doc.data(), doc.id),
                    )
                    .toList(),
              );

    return Column(
      children: [
        // 🔍 Search Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: TextField(
            onChanged: (val) => setState(() {
              searchQuery = val.toLowerCase();
            }),
            decoration: InputDecoration(
              hintText: "Search auctions",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 260,
          child: StreamBuilder<List<AuctionModel>>(
            stream: auctionStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No auctions available"));
              }

              // Apply search filter
              final auctions = snapshot.data!
                  .where((a) => a.title.toLowerCase().contains(searchQuery))
                  .toList();

              if (auctions.isEmpty) {
                return const Center(
                  child: Text("No auctions match your search"),
                );
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: auctions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final auction = auctions[index];

                  bool isInactive = auction.status != 'active';
                  String statusLabel = '';
                  if (auction.status == 'sold') {
                    statusLabel = 'SOLD';
                  } else if (auction.status == 'ended') {
                    statusLabel = 'ENDED';
                  }

                  return Stack(
                    children: [
                      // Auction Card
                      Container(
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: auction.imageUrls.isNotEmpty
                                  ? Image.network(
                                      auction.imageUrls[0],
                                      height: 140,
                                      width: 180,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 140,
                                      width: 180,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image, size: 50),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: Text(
                                auction.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                _getAuctionPriceText(auction),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),

                      // Status Chip
                      if (isInactive && statusLabel.isNotEmpty)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              statusLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  String _getAuctionPriceText(AuctionModel auction) {
    if (auction.type == 'english') {
      final price = auction.currentBid ?? auction.startingBid;
      return ' \$${price.toStringAsFixed(0)}';
    } else {
      return ' \$${auction.startingBid.toStringAsFixed(0)}';
    }
  }
}
