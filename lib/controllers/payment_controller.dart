import 'package:auctify/services/order_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model.dart';
import '../services/payment_service.dart';

class PaymentController {
  final PaymentService _paymentService = PaymentService();
  final OrderService _orderService = OrderService();

  /// Make a payment
  Future<void> makePayment({
    required String paymentId,
    required String orderId,
    required String auctionId,
    required String buyerId,
    required String sellerId,
    required double amount,
    required String method,
    required String transactionId,
  }) async {
    final payment = PaymentModel(
      paymentId: paymentId,
      orderId: orderId,
      auctionId: auctionId,
      buyerId: buyerId,
      sellerId: sellerId,
      amount: amount,
      method: method,
      status: 'success', // default success, you can handle failed/pending later
      transactionId: transactionId,
      createdAt: Timestamp.now(),
    );

    await _paymentService.createPayment(payment);

    // Mark order as paid
    await _orderService.updateOrderFields(orderId, {'paymentStatus': 'paid'});
  }

  /// Stream payments by buyer
  Stream<List<PaymentModel>> getBuyerPayments(String buyerId) {
    return _paymentService.streamPaymentsByBuyer(buyerId);
  }

  /// Stream payments by seller
  Stream<List<PaymentModel>> getSellerPayments(String sellerId) {
    return _paymentService.streamPaymentsBySeller(sellerId);
  }

  /// Update payment status
  Future<void> updatePaymentStatus(String paymentId, String status) async {
    await _paymentService.updatePaymentStatus(paymentId, status);
  }
}
