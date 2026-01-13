import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'orders';

  /// Create new order
  Future<void> createOrder(OrderModel order) async {
    await _firestore
        .collection(collection)
        .doc(order.orderId)
        .set(order.toFirestore());
  }

  // /// Stream all orders of a user (buyer)
  // Stream<List<OrderModel>> streamOrdersByBuyer(String buyerId) {
  //   return _firestore
  //       .collection(collection)
  //       .where('buyerId', isEqualTo: buyerId)
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map(
  //         (snapshot) => snapshot.docs
  //             .map((doc) => OrderModel.fromFirestore(doc))
  //             .toList(),
  //       );
  // }
  /// Stream all orders of a buyer that are 'placed'
  /// Stream all orders of a user (buyer) without needing a composite index
  Stream<List<OrderModel>> streamOrdersByBuyer(String buyerId) {
    return _firestore
        .collection(collection)
        .where('buyerId', isEqualTo: buyerId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList();

          // Sort by createdAt descending (latest first)
          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return orders;
        });
  }

  // /// Stream all orders of a seller
  // Stream<List<OrderModel>> streamOrdersBySeller(String sellerId) {
  //   return _firestore
  //       .collection(collection)
  //       .where('sellerId', isEqualTo: sellerId)
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map(
  //         (snapshot) => snapshot.docs
  //             .map((doc) => OrderModel.fromFirestore(doc))
  //             .toList(),
  //       );
  // }

  /// Stream all orders of a seller without needing a composite index
  Stream<List<OrderModel>> streamOrdersBySeller(String sellerId) {
    return _firestore
        .collection(collection)
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList();

          // Sort by createdAt descending
          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return orders;
        });
  }

  /// Get order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    final doc = await _firestore.collection(collection).doc(orderId).get();
    if (!doc.exists) return null;
    return OrderModel.fromFirestore(doc);
  }

  /// Update order fields (status/payment)
  Future<void> updateOrderFields(
    String orderId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(collection).doc(orderId).update(data);
  }

  /// Mark order as shipped
  Future<void> markOrderAsShipped(String orderId) async {
    await updateOrderFields(orderId, {'orderStatus': 'shipped'});
  }

  /// Mark order as delivered
  Future<void> markOrderAsDelivered(String orderId) async {
    await updateOrderFields(orderId, {'orderStatus': 'delivered'});
  }

  /// Mark order as confirmed
  Future<void> markOrderAsConfirmed(String orderId) async {
    await updateOrderFields(orderId, {'orderStatus': 'confirmed'});
  }
}
