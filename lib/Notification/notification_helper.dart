import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a notification
  Future<void> createNotification({
    required String userId, // Who will receive the notification
    required String
    type, // bid | auction_won | auction_sold | payment | new_auction | outbid
    required String title, // Title shown in the notification screen
    required String message, // Detailed message
    String? relatedAuctionId, // Optional: link to auction
  }) async {
    await _firestore.collection('notifications').add({
      'userId': userId,
      'type': type,
      'title': title,
      'message': message,
      'relatedAuctionId': relatedAuctionId,
      'read': false,
      'createdAt': Timestamp.now(),
    });
  }

  /// Helper: notify seller that their auction was created
  Future<void> notifyNewAuction({
    required String sellerId,
    required String auctionTitle,
    required String auctionId,
  }) async {
    await createNotification(
      userId: sellerId,
      type: 'new_auction',
      title: 'Your auction is live!',
      message: 'Your auction "$auctionTitle" has been successfully created.',
      relatedAuctionId: auctionId,
    );
  }

  /// Helper: notify buyer when they won an auction
  Future<void> notifyAuctionWon({
    required String winnerId,
    required String auctionTitle,
    required double amount,
    required String auctionId,
  }) async {
    await createNotification(
      userId: winnerId,
      type: 'auction_won',
      title: '🎉 You won the auction!',
      message:
          'You won the auction "$auctionTitle" for \$${amount.toStringAsFixed(2)}.',
      relatedAuctionId: auctionId,
    );
  }

  Future<void> notifyAuctionEnded({
    required String auctionTitle,
    required String auctionId,
  }) async {
    // Example: send a notification to all bidders or seller
    print("Auction '$auctionTitle' ended! ID: $auctionId");
    // Implement actual notification logic here
  }

  /// Helper: notify seller that their auction was sold
  Future<void> notifyAuctionSold({
    required String sellerId,
    required String auctionTitle,
    required double amount,
    required String auctionId,
  }) async {
    await createNotification(
      userId: sellerId,
      type: 'auction_sold',
      title: '💰 Auction Sold!',
      message:
          'Your auction "$auctionTitle" was won for \$${amount.toStringAsFixed(2)}.',
      relatedAuctionId: auctionId,
    );
  }

  /// Helper: notify buyer when payment is successful
  Future<void> notifyPaymentReceived({
    required String sellerId,
    required String auctionTitle,
  }) async {
    await createNotification(
      userId: sellerId,
      type: 'payment',
      title: '✅ Payment Received',
      message: 'You have received payment for your auction "$auctionTitle".',
    );
  }

  /// Helper: notify users when they are outbid
  Future<void> notifyOutbid({
    required String outbidUserId,
    required String auctionTitle,
    required double newBidAmount,
    required String auctionId,
  }) async {
    await createNotification(
      userId: outbidUserId,
      type: 'outbid',
      title: '⚠️ You were outbid!',
      message:
          'A new bid of \$${newBidAmount.toStringAsFixed(2)} has been placed on "$auctionTitle".',
      relatedAuctionId: auctionId,
    );
  }

  /// Helper: notify bidder about their successful bid
  Future<void> notifyBidPlaced({
    required String bidderId,
    required String auctionTitle,
    required double amount,
    required String auctionId,
  }) async {
    await createNotification(
      userId: bidderId,
      type: 'bid',
      title: 'Bid Placed!',
      message:
          'You placed a bid of \$${amount.toStringAsFixed(2)} on "$auctionTitle".',
      relatedAuctionId: auctionId,
    );
  }

  /// Notify all users about a new auction
  Future<void> notifyAllUsersNewAuction({
    required String auctionTitle,
    required String sellerName,
    required String auctionId,
  }) async {
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .get();

    for (var doc in usersSnapshot.docs) {
      final userId = doc.id;

      // Optionally skip the seller themselves
      // if (userId == sellerId) continue;

      await createNotification(
        userId: userId,
        type: 'new_auction',
        title: 'New Auction Available!',
        message:
            'Seller $sellerName has just created a new auction: "$auctionTitle". Check it out!',
        relatedAuctionId: auctionId,
      );
    }
  }
}
