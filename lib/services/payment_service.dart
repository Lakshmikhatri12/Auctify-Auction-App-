import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'payments';

  /// Create new payment
  Future<void> createPayment(PaymentModel payment) async {
    await _firestore
        .collection(collection)
        .doc(payment.paymentId)
        .set(payment.toFirestore());
  }

  /// Get payment by ID
  Future<PaymentModel?> getPaymentById(String paymentId) async {
    final doc = await _firestore.collection(collection).doc(paymentId).get();
    if (!doc.exists) return null;
    return PaymentModel.fromFirestore(doc);
  }

  /// Stream payments of a user (buyer)
  Stream<List<PaymentModel>> streamPaymentsByBuyer(String buyerId) {
    return _firestore
        .collection(collection)
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PaymentModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Stream payments of a seller
  Stream<List<PaymentModel>> streamPaymentsBySeller(String sellerId) {
    return _firestore
        .collection(collection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PaymentModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> markOrderAsPaid(String orderId) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'paymentStatus': 'paid',
    });
  }

  /// Update payment status
  Future<void> updatePaymentStatus(String paymentId, String status) async {
    await _firestore.collection(collection).doc(paymentId).update({
      'status': status,
    });
  }
}
