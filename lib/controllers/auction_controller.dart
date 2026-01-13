import 'dart:io';
import 'package:auctify/Notification/notification_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/auction_model.dart';
import '../services/auction_service.dart';

class AuctionController {
  final AuctionService _service = AuctionService();
  final Uuid _uuid = Uuid();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationHelper _notificationHelper = NotificationHelper();

  /// Fetch current user's name from Firestore
  Future<String> getCurrentUserName() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final data = snapshot.data();

    if (data == null || !data.containsKey('name')) {
      return "Unknown"; // fallback
    }

    return data['name'];
  }

  // Create English Auction
  Future<AuctionModel> createEnglishAuction({
    required String title,
    required String description,
    required double startingBid,
    double? bidIncrement,
    int? durationHours,
    required String category,
    required String location,
    required List<File> images,
  }) async {
    final imageUrls = await _service.uploadImages(images);
    final sellerName = await getCurrentUserName();
    final currentUserId = _auth.currentUser!.uid;

    final auction = AuctionModel(
      auctionId: _uuid.v4(),
      title: title,
      description: description,
      sellerId: currentUserId,
      sellerName: sellerName, // ✅ store seller name

      type: 'english',
      startingBid: startingBid,
      currentBid: startingBid,
      bidIncrement: bidIncrement ?? 1,
      imageUrls: imageUrls,
      durationHours: durationHours ?? 24,
      location: location,
      startTime: Timestamp.fromDate(DateTime.now()), // ✅ store as Timestamp
      endTime: Timestamp.fromDate(
        DateTime.now().add(Duration(hours: durationHours ?? 24)),
      ),
      // startTime: DateTime.now(),
      // endTime: DateTime.now().add(Duration(hours: durationHours ?? 24)),
      status: 'active',
      category: category,
    );

    await _service.createAuction(auction);
    await _notificationHelper.notifyNewAuction(
      sellerId: currentUserId,
      auctionTitle: auction.title,
      auctionId: auction.auctionId,
    );
    return auction;
  }

  // Create Fixed Auction
  Future<AuctionModel> createFixedAuction({
    required String title,
    required String description,
    required double fixedPrice,
    int? quantity,
    required String category,
    required String location,
    required List<File> images,
  }) async {
    final imageUrls = await _service.uploadImages(images);
    final sellerName = await getCurrentUserName(); // ✅ fetch seller name
    final currentUserId = _auth.currentUser!.uid;

    final auction = AuctionModel(
      auctionId: _uuid.v4(),
      title: title,
      description: description,
      sellerId: currentUserId,
      sellerName: sellerName, // ✅ store seller name
      type: 'fixed',
      startingBid: fixedPrice,
      currentBid: fixedPrice,
      quantity: quantity ?? 1,
      imageUrls: imageUrls,
      location: location,
      startTime: Timestamp.fromDate(DateTime.now()),
      endTime: Timestamp.fromDate(
        DateTime.now().add(const Duration(hours: 24)),
      ),
      // startTime: DateTime.now(),
      // endTime: DateTime.now().add(const Duration(hours: 24)),
      status: 'active',
      category: category,
    );

    await _service.createAuction(auction);
    await _notificationHelper.notifyNewAuction(
      sellerId: currentUserId,
      auctionTitle: auction.title,
      auctionId: auction.auctionId,
    );
    return auction;
  }

  // Streams
  Stream<AuctionModel> streamAuction(String auctionId) =>
      _service.streamAuction(auctionId);
  Stream<List<AuctionModel>> streamAllAuctions() =>
      _service.streamAllAuctions();
  Stream<List<AuctionModel>> streamAuctionsByCategory(String category) =>
      _service.streamAuctionsByCategory(category);

  Future<void> finalizeAuction(String auctionId) async {
    final auctionRef = _firestore.collection('auctions').doc(auctionId);
    final doc = await auctionRef.get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final status = data['status'] ?? 'active';
    final endTime = data['endTime'] as Timestamp?;
    final type = data['type'] ?? 'english';

    // Only finalize if active and English type
    if (status != 'active' || endTime == null || type != 'english') return;
    if (endTime.toDate().isAfter(DateTime.now())) return;

    String? winnerId;
    double currentBid =
        (data['currentBid'] as num?)?.toDouble() ??
        (data['startingBid'] as num?)?.toDouble() ??
        0;

    final bidderIds = List<String>.from(data['bidderIds'] ?? []);

    if (bidderIds.isNotEmpty) {
      final bidsSnap = await auctionRef
          .collection('bids')
          .orderBy('amount', descending: true)
          .limit(1)
          .get();

      if (bidsSnap.docs.isNotEmpty) {
        final highestBid = bidsSnap.docs.first.data();
        winnerId = highestBid['userId'];
        currentBid = (highestBid['amount'] as num).toDouble();
      } else {
        // fallback
        winnerId = bidderIds.last;
      }
    }

    // Update auction as ENDED (not sold yet)
    await auctionRef.update({
      'status': 'ended', // English auction ended
      'winnerId': winnerId, // Highest bidder
      'currentBid': currentBid,
      'paymentStatus': winnerId != null ? 'pending' : null,
    });

    // Notify winner
    if (winnerId != null) {
      await _notificationHelper.notifyAuctionWon(
        winnerId: winnerId,
        auctionTitle: data['title'] ?? 'Auction',
        amount: currentBid,
        auctionId: auctionId,
      );
    }

    // Notify seller
    // final sellerId = data['sellerId'];
    // if (sellerId != null) {
    //   await _notificationHelper.notifyAuctionEnded(
    //     sellerId: sellerId,
    //     auctionTitle: data['title'] ?? 'Auction',
    //     amount: currentBid,
    //     auctionId: auctionId,
    //   );
    // }
  }

  /// Automatically finalize all auctions that have ended
  Future<void> finalizeAllExpiredAuctions() async {
    final now = DateTime.now();
    final snapshot = await _firestore
        .collection('auctions')
        .where('status', isEqualTo: 'active')
        .where('endTime', isLessThanOrEqualTo: Timestamp.fromDate(now))
        .get();

    for (var doc in snapshot.docs) {
      await finalizeAuction(doc.id);
    }
  }

  /// Stream of all active auctions (optional for live updates)
  Stream<QuerySnapshot> getActiveAuctionsStream() {
    return _firestore
        .collection('auctions')
        .where('status', isEqualTo: 'active')
        .snapshots();
  }

  // Mark auction as paid by winner
  Future<void> markAuctionAsPaid(String auctionId, String winnerId) async {
    final auctionRef = _firestore.collection('auctions').doc(auctionId);
    final snapshot = await auctionRef.get();
    if (!snapshot.exists) return;

    final auctionData = snapshot.data()!;
    if (auctionData['winnerId'] != winnerId) return; // only winner can pay

    await auctionRef.update({
      'paymentStatus': 'paid',
      'paidAt': Timestamp.now(),
    });

    final sellerId = auctionData['sellerId'];
    final auctionTitle = auctionData['title'];

    if (sellerId != null) {
      await _notificationHelper.notifyPaymentReceived(
        sellerId: sellerId,
        auctionTitle: auctionTitle ?? 'Auction',
      );
    }
  }

  // delete auction
}
