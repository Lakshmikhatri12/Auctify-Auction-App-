// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class BidModel {
// //   final String bidId;
// //   final String auctionId;
// //   final String auctionTitle;
// //   final String userId;
// //   final String bidderName;
// //   final String profileImageUrl;
// //   final double amount;
// //   final DateTime timestamp;

// //   BidModel({
// //     required this.bidId,
// //     required this.auctionId,
// //     required this.auctionTitle,
// //     required this.userId,
// //     required this.bidderName,
// //     required this.amount,
// //     required this.timestamp,
// //     required this.profileImageUrl,
// //   });

// //   factory BidModel.fromMap(Map<String, dynamic> map) {
// //     return BidModel(
// //       bidId: map['bidId'] ?? '',
// //       auctionId: map['auctionId'] ?? '',
// //       auctionTitle: map['auctionTitle'] ?? '',
// //       userId: map['userId'] ?? '',
// //       bidderName: map['bidderName'] ?? 'Unknown',
// //       profileImageUrl: map['profileImageUrl'] ?? '',
// //       amount: (map['amount'] as num).toDouble(),
// //       timestamp: (map['timestamp'] as Timestamp).toDate(),
// //     );
// //   }

// //   Map<String, dynamic> toMap() {
// //     return {
// //       'bidId': bidId,
// //       'auctionId': auctionId,
// //       'auctionTitle': auctionTitle,
// //       'userId': userId,
// //       'bidderName': bidderName,
// //       'profileImageUrl': profileImageUrl,
// //       'amount': amount,
// //       'timestamp': timestamp,
// //     };
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';

// class BidModel {
//   final String bidId;
//   final String auctionId;
//   final String auctionTitle;
//   final String userId;
//   final String bidderName;
//   final String profileImageUrl;
//   final double amount;
//   final DateTime timestamp;
//   final String? productImageUrl; // optional

//   BidModel({
//     required this.bidId,
//     required this.auctionId,
//     required this.auctionTitle,
//     required this.userId,
//     required this.bidderName,
//     required this.amount,
//     required this.timestamp,
//     required this.profileImageUrl,
//     this.productImageUrl,
//   });

//   factory BidModel.fromMap(
//     Map<String, dynamic> map, {
//     required String bidId,
//     required String auctionId,
//   }) {
//     return BidModel(
//       bidId: bidId,
//       auctionId: auctionId,
//       auctionTitle: map['auctionTitle'] ?? '',
//       userId: map['userId'] ?? '',
//       bidderName: map['bidderName'] ?? 'Unknown',
//       profileImageUrl: map['profileImageUrl'] ?? '',
//       amount: (map['amount'] as num).toDouble(),
//       timestamp: (map['timestamp'] as Timestamp).toDate(),
//       productImageUrl:
//           map['productImage'] ?? '', // ensure you save this in Firestore
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'auctionTitle': auctionTitle,
//       'userId': userId,
//       'bidderName': bidderName,
//       'profileImageUrl': profileImageUrl,
//       'amount': amount,
//       'timestamp': timestamp,
//       'productImage': productImageUrl,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class BidModel {
  final String id;
  final String auctionId;
  final String userId;
  final double amount;
  final Timestamp createdAt;

  BidModel({
    required this.id,
    required this.auctionId,
    required this.userId,
    required this.amount,
    required this.createdAt,
  });

  /// Convert Firestore → Dart
  factory BidModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return BidModel(
      id: doc.id,
      auctionId: data['auctionId'],
      userId: data['userId'],
      amount: (data['amount'] as num).toDouble(),
      createdAt: data['createdAt'],
    );
  }

  /// Convert Dart → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'auctionId': auctionId,
      'userId': userId,
      'amount': amount,
      'timestamp': createdAt,
    };
  }
}
