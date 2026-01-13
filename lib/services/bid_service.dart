// import 'package:auctify/models/bid_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class BidService {
//   final _firestore = FirebaseFirestore.instance;

//   // Place bid
//   Future<void> placeBid(BidModel bid) async {
//     await _firestore.collection('bids').doc(bid.bidId).set(bid.toMap());

//     // Update auction current bid
//     await _firestore.collection('auctions').doc(bid.auctionId).update({
//       'currentBid': bid.amount,
//     });
//   }

//   // All bids of ONE auction
//   Stream<List<BidModel>> streamBidsForAuction(String auctionId) {
//     return _firestore
//         .collection('bids')
//         .where('auctionId', isEqualTo: auctionId)
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map(
//           (snap) => snap.docs
//               .map(
//                 (d) =>
//                     BidModel.fromMap(d.data(), bidId: '', auctionId: auctionId),
//               )
//               .toList(),
//         );
//   }

//   // All bids of ONE user
//   Stream<List<BidModel>> streamMyBids(String userId, String) {
//     return _firestore
//         .collection('bids')
//         .where('bidderId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map(
//           (snap) => snap.docs
//               .map((d) => BidModel.fromMap(d.data(), bidId: '', auctionId: ''))
//               .toList(),
//         );
//   }
// }

import 'package:auctify/controllers/auction_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bid_model.dart';

class BidService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuctionController _auctionController = AuctionController();

  /// Place a bid (used inside transaction)
  Future<void> placeBid(BidModel bid) async {
    await _firestore.collection('bids').add(bid.toFirestore());
  }

  /// Get all bids of an auction (highest first)
  Stream<List<BidModel>> getBidsForAuction(String auctionId) {
    return _firestore
        .collection('bids')
        .where('auctionId', isEqualTo: auctionId)
        .orderBy('amount', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((e) => BidModel.fromFirestore(e)).toList(),
        );
  }

  /// Get highest bid of an auction
  Future<BidModel?> getHighestBid(String auctionId) async {
    final snapshot = await _firestore
        .collection('bids')
        .where('auctionId', isEqualTo: auctionId)
        .orderBy('amount', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return BidModel.fromFirestore(snapshot.docs.first);
  }

  /// Stream all bids placed by a user (live updates)
  Stream<List<BidModel>> getBidsByUserStream(String userId) {
    return _firestore
        .collection('bids')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => BidModel.fromFirestore(doc)).toList(),
        );
  }

  Future<void> payForAuction(String auctionId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await _auctionController.markAuctionAsPaid(auctionId, currentUserId);
  }
}
