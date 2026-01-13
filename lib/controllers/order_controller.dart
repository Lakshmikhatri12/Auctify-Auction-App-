import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderController {
  final OrderService _orderService = OrderService();

  /// Place new order
  Future<void> placeOrder({
    required String orderId,
    required String auctionId,
    required String auctionType,
    required String buyerId,
    required String sellerId,
    required double price,
    required Map<String, dynamic> shippingAddress,
  }) async {
    final order = OrderModel(
      orderId: orderId,
      auctionId: auctionId,
      auctionType: auctionType,
      buyerId: buyerId,
      sellerId: sellerId,
      price: price,
      shippingAddress: shippingAddress,
      createdAt: Timestamp.now(),
    );

    await _orderService.createOrder(order);
  }

  /// Stream buyer's orders
  Stream<List<OrderModel>> getBuyerOrders(String buyerId) {
    return _orderService.streamOrdersByBuyer(buyerId);
  }

  /// Stream seller's orders
  Stream<List<OrderModel>> getSellerOrders(String sellerId) {
    return _orderService.streamOrdersBySeller(sellerId);
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _orderService.updateOrderFields(orderId, {'orderStatus': status});
  }

  /// Mark payment status
  Future<void> markPaymentStatus(String orderId, String paymentStatus) async {
    await _orderService.updateOrderFields(orderId, {
      'paymentStatus': paymentStatus,
    });
  }
}
