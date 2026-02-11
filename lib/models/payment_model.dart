// import 'package:cloud_firestore/cloud_firestore.dart';

// class PaymentModel {
//   final String paymentId;
//   final String orderId;
//   final String auctionId;

//   final String buyerId;
//   final String sellerId;

//   final double amount;
//   final String method; // card | cod | wallet
//   final String status; // success | failed | pending
//   final String transactionId;

//   final Timestamp createdAt;

//   PaymentModel({
//     required this.paymentId,
//     required this.orderId,
//     required this.auctionId,
//     required this.buyerId,
//     required this.sellerId,
//     required this.amount,
//     required this.method,
//     required this.status,
//     required this.transactionId,
//     required this.createdAt,
//   });

//   /// Firestore → Dart
//   factory PaymentModel.fromFirestore(
//     DocumentSnapshot<Map<String, dynamic>> doc,
//   ) {
//     final data = doc.data()!;
//     return PaymentModel(
//       paymentId: doc.id,
//       orderId: data['orderId'],
//       auctionId: data['auctionId'],
//       buyerId: data['buyerId'],
//       sellerId: data['sellerId'],
//       amount: (data['amount'] as num).toDouble(),
//       method: data['method'],
//       status: data['status'],
//       transactionId: data['transactionId'],
//       createdAt: data['createdAt'],
//     );
//   }

//   /// Dart → Firestore
//   Map<String, dynamic> toFirestore() {
//     return {
//       'orderId': orderId,
//       'auctionId': auctionId,
//       'buyerId': buyerId,
//       'sellerId': sellerId,
//       'amount': amount,
//       'method': method,
//       'status': status,
//       'transactionId': transactionId,
//       'createdAt': createdAt,
//     };
//   }
// }
