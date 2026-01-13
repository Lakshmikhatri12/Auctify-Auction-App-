import 'package:auctify/utils/constants.dart';
import 'package:flutter/material.dart';

class RecommendedAuctions extends StatelessWidget {
  const RecommendedAuctions({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Stack(
              children: [
                Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        "https://cdn.pixabay.com/photo/2023/01/16/18/53/binoculars-7723093_1280.jpg",
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
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "22:12:12",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
