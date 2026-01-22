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
    required String paymentStatus,
    required String email,
    required String productName, // Needed for email
  }) async {
    final order = OrderModel(
      orderId: orderId,
      auctionId: auctionId,
      auctionType: auctionType,
      buyerId: buyerId,
      sellerId: sellerId,
      price: price,
      shippingAddress: shippingAddress,
      paymentStatus: paymentStatus,
      email: email,
      createdAt: Timestamp.now(),
    );

    await _orderService.createOrder(order);

    // Trigger Email Notification (Firebase Extension)
    await _sendConfirmationEmail(
      email: email,
      orderId: orderId,
      productName: productName,
      price: price,
      shippingAddress: shippingAddress,
    );
  }

  /// Trigger Firebase "Trigger Email" Extension
  Future<void> _sendConfirmationEmail({
    required String email,
    required String orderId,
    required String productName,
    required double price,
    required Map<String, dynamic> shippingAddress,
  }) async {
    await FirebaseFirestore.instance.collection('mail').add({
      'to': [email],
      'message': {
        'subject': 'Order Confirmation - #$orderId',
        'html':
            '''
          <div style="font-family: Arial, sans-serif; color: #333; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;">
            <div style="text-align: center; padding-bottom: 20px; border-bottom: 2px solid #5D3FD3;">
              <h1 style="color: #5D3FD3;">Auctify</h1>
              <p style="font-size: 16px; color: #666;">Thank you for your purchase!</p>
            </div>
            
            <div style="padding: 20px 0;">
              <p>Hi,</p>
              <p>Your order for <strong>$productName</strong> has been successfully placed.</p>
              
              <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
                <tr style="background-color: #f9f9f9;">
                  <td style="padding: 10px; border: 1px solid #ddd;"><strong>Order ID</strong></td>
                  <td style="padding: 10px; border: 1px solid #ddd;">#$orderId</td>
                </tr>
                <tr>
                  <td style="padding: 10px; border: 1px solid #ddd;"><strong>Product</strong></td>
                  <td style="padding: 10px; border: 1px solid #ddd;">$productName</td>
                </tr>
                <tr style="background-color: #f9f9f9;">
                  <td style="padding: 10px; border: 1px solid #ddd;"><strong>Total Price</strong></td>
                  <td style="padding: 10px; border: 1px solid #ddd; color: #28a745; font-weight: bold;">\$${price.toStringAsFixed(2)}</td>
                </tr>
              </table>

              <h3 style="margin-top: 20px;">Shipping Address</h3>
              <p style="background-color: #f4f4f4; padding: 10px; border-radius: 5px;">
                ${shippingAddress['name']}<br>
                ${shippingAddress['street']}, ${shippingAddress['city']}<br>
                ${shippingAddress['state']}, ${shippingAddress['zip']}<br>
                ${shippingAddress['country']}
              </p>
            </div>

            <div style="text-align: center; margin-top: 30px; font-size: 12px; color: #999;">
              <p>If you have any questions, reply to this email.</p>
              <p>&copy; ${DateTime.now().year} Auctify. All rights reserved.</p>
            </div>
          </div>
        ''',
      },
    });
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
  // Future<void> updateOrderStatus(String orderId, String status) async {
  //   await _orderService.updateOrderFields(orderId, {'orderStatus': status});
  // }
  /// Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    // 1️⃣ Update the order status
    await _orderService.updateOrderFields(orderId, {'orderStatus': status});

    // 2️⃣ Only mark auction as sold when status is "confirmed"
    if (status.toLowerCase() == 'confirmed') {
      final orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();

      if (!orderSnapshot.exists) return;

      final orderData = orderSnapshot.data()!;
      final auctionId = orderData['auctionId'] as String;
      final buyerId = orderData['buyerId'] as String;

      // Fetch the auction to check if it’s still active
      final auctionSnapshot = await FirebaseFirestore.instance
          .collection('auctions')
          .doc(auctionId)
          .get();

      if (auctionSnapshot.exists) {
        final auctionData = auctionSnapshot.data()!;
        if ((auctionData['status'] ?? 'active') == 'active') {
          await FirebaseFirestore.instance
              .collection('auctions')
              .doc(auctionId)
              .update({
                'status': 'sold',
                'soldAt': FieldValue.serverTimestamp(),
                'winnerId': buyerId,
              });
        }
      }
    }
  }

  /// Mark payment status
  Future<void> markPaymentStatus(String orderId, String paymentStatus) async {
    await _orderService.updateOrderFields(orderId, {
      'paymentStatus': paymentStatus,
    });
  }
}
