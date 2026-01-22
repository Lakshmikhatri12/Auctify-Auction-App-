// import 'package:auctify/Notification/notification_helper.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/bid_model.dart';
// import '../services/bid_service.dart';

// class BidController {
//   final BidService _bidService = BidService();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final NotificationHelper _notificationHelper = NotificationHelper();

//   Future<void> placeBid({
//     required String auctionId,
//     required double bidAmount,
//   }) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception("User not logged in");

//     final auctionRef = _firestore.collection('auctions').doc(auctionId);
//     final bidRef = _firestore.collection('bids').doc();
//     final myBidRef = _firestore
//         .collection('users')
//         .doc(user.uid)
//         .collection('myBids')
//         .doc(auctionId);

//     await _firestore.runTransaction((transaction) async {
//       final auctionSnapshot = await transaction.get(auctionRef);

//       if (!auctionSnapshot.exists) {
//         throw Exception("Auction not found");
//       }

//       final auctionData = auctionSnapshot.data()!;
//       final double currentBid = (auctionData['currentBid'] as num).toDouble();
//       final String status = auctionData['status'];
//       final String sellerId = auctionData['sellerId'];
//       final List<dynamic> bidderIds = List.from(auctionData['bidderIds'] ?? []);

//       if (status != 'active') {
//         throw Exception("Auction is not active");
//       }

//       if (bidAmount <= currentBid) {
//         throw Exception("Bid must be higher than current bid");
//       }
//       // Notify previous highest bidder that they are outbid
//       if (bidderIds.isNotEmpty) {
//         final previousBidderId = bidderIds.last;
//         if (previousBidderId != user.uid) {
//           await _notificationHelper.notifyOutbid(
//             outbidUserId: previousBidderId,
//             auctionTitle: auctionData['title'],
//             newBidAmount: bidAmount,
//             auctionId: auctionId,
//           );
//         }
//       }

//       // 1️⃣ Update auction currentBid & bidderIds
//       transaction.update(auctionRef, {
//         'currentBid': bidAmount,
//         'bidderIds': FieldValue.arrayUnion([user.uid]),
//       });

//       // 2️⃣ Create bid in top-level bids collection
//       transaction.set(bidRef, {
//         'auctionId': auctionId,
//         'userId': user.uid,
//         'amount': bidAmount,
//         'createdAt': Timestamp.now(),
//       });

//       // 3️⃣ Update user's myBids subcollection for fast UI
//       transaction.set(myBidRef, {
//         'auctionId': auctionId,
//         'lastBid': bidAmount,
//         'status': 'active',
//         'updatedAt': Timestamp.now(),
//       }, SetOptions(merge: true));

//       // Notify the bidder about their successful bid
//       await _notificationHelper.notifyBidPlaced(
//         bidderId: user.uid,
//         auctionTitle: (await auctionRef.get()).data()?['title'] ?? 'Auction',
//         amount: bidAmount,
//         auctionId: auctionId,
//       );
//     });
//   }

//   /// Stream bids for auction detail screen
//   Stream<List<BidModel>> getAuctionBids(String auctionId) {
//     return _bidService.getBidsForAuction(auctionId);
//   }

//   /// Stream logged-in user's bids for live updates
//   Stream<List<BidModel>> getMyBidsStream() {
//     final user = _auth.currentUser;
//     if (user == null) return const Stream.empty();

//     return _firestore
//         .collection('users')
//         .doc(user.uid)
//         .collection('myBids')
//         .orderBy('updatedAt', descending: true)
//         .snapshots()
//         .asyncMap((snapshot) async {
//           // For each bid, fetch auction data
//           List<BidModel> userBids = [];
//           for (var doc in snapshot.docs) {
//             final data = doc.data();
//             final auctionId = data['auctionId'];

//             // Fetch auction details
//             final auctionDoc = await _firestore
//                 .collection('auctions')
//                 .doc(auctionId)
//                 .get();
//             final auctionData = auctionDoc.data();

//             if (auctionData != null) {
//               userBids.add(
//                 BidModel(
//                   id: doc.id,
//                   auctionId: auctionId,
//                   userId: user.uid,
//                   amount: (data['lastBid'] as num).toDouble(),
//                   createdAt: data['updatedAt'], // Use updatedAt as timestamp
//                 ),
//               );
//             }
//           }
//           return userBids;
//         });
//   }

//   Future<void> checkAndSetWinner(String auctionId) async {
//     final auctionRef = FirebaseFirestore.instance
//         .collection('auctions')
//         .doc(auctionId);
//     final doc = await auctionRef.get();

//     if (!doc.exists) return;

//     final data = doc.data()!;
//     final status = data['status'] ?? 'active';
//     final endTime = data['endTime'] as Timestamp?;
//     final bidderIds = List<String>.from(data['bidderIds'] ?? []);

//     if (status == 'active' &&
//         endTime != null &&
//         endTime.toDate().isBefore(DateTime.now())) {
//       // Determine winner
//       final winnerId = bidderIds.isNotEmpty ? bidderIds.last : null;

//       await auctionRef.update({
//         'status': 'sold',
//         'winnerId': winnerId,
//         'paymentStatus': winnerId != null ? 'pending' : null,
//         'soldAt': Timestamp.now(),
//       });
//     }
//   }
// }

import 'package:auctify/screens/Notification/notification_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bid_model.dart';
import '../services/bid_service.dart';
import 'auction_controller.dart';

class BidController {
  final BidService _bidService = BidService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationHelper _notificationHelper = NotificationHelper();
  final AuctionController _auctionController = AuctionController();

  /// Place bid with validation and notifications
  Future<void> placeBid({
    required String auctionId,
    required double bidAmount,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final auctionRef = _firestore.collection('auctions').doc(auctionId);
    final bidRef = _firestore.collection('bids').doc();
    final myBidRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('myBids')
        .doc(auctionId);

    await _firestore.runTransaction((transaction) async {
      final auctionSnapshot = await transaction.get(auctionRef);
      if (!auctionSnapshot.exists) throw Exception("Auction not found");

      final auctionData = auctionSnapshot.data()!;
      final double currentBid = (auctionData['currentBid'] as num).toDouble();
      final String sellerId = auctionData['sellerId']; /////////
      final endTime = auctionData['endTime'] as Timestamp?; ////////////
      final String status = auctionData['status'];
      final List<dynamic> bidderIds = List.from(auctionData['bidderIds'] ?? []);

      // ✅ Prevent seller from bidding
      if (sellerId == user.uid) {
        throw Exception("You cannot place a bid on your own auction");
      }

      // ✅ Prevent bidding after auction ends
      if (endTime != null && endTime.toDate().isBefore(DateTime.now())) {
        throw Exception("Auction has ended");
      }

      if (status != 'active') throw Exception("Auction is not active");
      if (bidAmount <= currentBid)
        throw Exception("Bid must be higher than current bid");

      // Notify previous highest bidder
      if (bidderIds.isNotEmpty) {
        final previousBidderId = bidderIds.last;
        if (previousBidderId != user.uid) {
          await _notificationHelper.notifyOutbid(
            outbidUserId: previousBidderId,
            auctionTitle: auctionData['title'],
            newBidAmount: bidAmount,
            auctionId: auctionId,
          );
        }
      }

      // Update auction
      transaction.update(auctionRef, {
        'currentBid': bidAmount,
        'bidderIds': FieldValue.arrayUnion([user.uid]),
      });

      // Create bid
      transaction.set(bidRef, {
        'auctionId': auctionId,
        'userId': user.uid,
        'amount': bidAmount,
        'createdAt': Timestamp.now(),
      });

      // Update user's myBids
      transaction.set(myBidRef, {
        'auctionId': auctionId,
        'lastBid': bidAmount,
        'status': 'active',
        'updatedAt': Timestamp.now(),
      }, SetOptions(merge: true));
    });

    // Notify bidder that their bid was placed
    await _notificationHelper.notifyBidPlaced(
      bidderId: user.uid,
      auctionTitle: (await auctionRef.get()).data()?['title'] ?? 'Auction',
      amount: bidAmount,
      auctionId: auctionId,
    );

    // After bid, check if auction ended and finalize if needed
    await _auctionController.finalizeAuction(auctionId);
  }

  /// Stream bids for auction detail screen
  Stream<List<BidModel>> getAuctionBids(String auctionId) {
    return _bidService.getBidsForAuction(auctionId);
  }

  /// Stream logged-in user's bids for live updates
  Stream<List<BidModel>> getMyBidsStream() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('myBids')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<BidModel> userBids = [];
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final auctionId = data['auctionId'];

            final auctionDoc = await _firestore
                .collection('auctions')
                .doc(auctionId)
                .get();
            final auctionData = auctionDoc.data();

            if (auctionData != null) {
              userBids.add(
                BidModel(
                  id: doc.id,
                  auctionId: auctionId,
                  userId: user.uid,
                  amount: (data['lastBid'] as num).toDouble(),
                  createdAt: data['updatedAt'],
                ),
              );
            }
          }
          return userBids;
        });
  }

  /// Check and set winner manually (optional, auto-called after bid)
  Future<void> checkAndSetWinner(String auctionId) async {
    final auctionRef = _firestore.collection('auctions').doc(auctionId);
    final doc = await auctionRef.get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final status = data['status'] ?? 'active';
    final endTime = data['endTime'] as Timestamp?;
    final bidderIds = List<String>.from(data['bidderIds'] ?? []);

    if (status == 'active' &&
        endTime != null &&
        endTime.toDate().isBefore(DateTime.now())) {
      final winnerId = bidderIds.isNotEmpty ? bidderIds.last : null;

      await auctionRef.update({
        'status': 'sold',
        'winnerId': winnerId,
        'paymentStatus': winnerId != null ? 'pending' : null,
        'soldAt': Timestamp.now(),
      });

      // Notify winner & seller
      if (winnerId != null) {
        await _notificationHelper.notifyAuctionWon(
          winnerId: winnerId,
          auctionTitle: data['title'] ?? 'Auction',
          amount: (data['currentBid'] as num?)?.toDouble() ?? 0,
          auctionId: auctionId,
        );

        final sellerId = data['sellerId'];
        if (sellerId != null) {
          await _notificationHelper.notifyAuctionSold(
            sellerId: sellerId,
            auctionTitle: data['title'] ?? 'Auction',
            amount: (data['currentBid'] as num?)?.toDouble() ?? 0,
            auctionId: auctionId,
          );
        }
      }
    }
  }
}
