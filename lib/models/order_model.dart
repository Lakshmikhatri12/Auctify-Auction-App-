import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String auctionId;
  final String auctionType; // fixed | english

  final String buyerId;
  final String sellerId;

  final double price;
  final String orderStatus; // placed | confirmed | shipped | delivered
  final String paymentStatus; // paid
  final String email;

  final Map<String, dynamic> shippingAddress;
  final Timestamp createdAt;

  OrderModel({
    required this.orderId,
    required this.auctionId,
    required this.auctionType,
    required this.buyerId,
    required this.sellerId,
    required this.price,
    this.orderStatus = 'placed',
    this.paymentStatus = 'paid',
    required this.email,
    required this.shippingAddress,
    required this.createdAt,
  });

  /// Firestore → Dart
  factory OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return OrderModel(
      orderId: doc.id,
      auctionId: data['auctionId'],
      auctionType: data['auctionType'],
      buyerId: data['buyerId'],
      sellerId: data['sellerId'],
      price: (data['price'] as num).toDouble(),
      orderStatus: data['orderStatus'],
      paymentStatus: data['paymentStatus'],
      email: data['email'] ?? '',
      shippingAddress: Map<String, dynamic>.from(data['shippingAddress']),
      createdAt: data['createdAt'],
    );
  }

  /// Dart → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'auctionId': auctionId,
      'auctionType': auctionType,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'price': price,
      'orderStatus': orderStatus,
      'paymentStatus': paymentStatus,
      'email': email,
      'shippingAddress': shippingAddress,
      'createdAt': createdAt,
    };
  }
}
