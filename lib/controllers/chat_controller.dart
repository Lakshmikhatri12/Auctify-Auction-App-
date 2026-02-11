// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:auctify/models/chat_model.dart';

// class ChatController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// Send a message and update/create the conversation doc
//   Future<void> sendMessage({
//     required String senderId,
//     required String receiverId,
//     required String message,
//   }) async {
//     if (message.trim().isEmpty) return;

//     // Generate a unique chat ID based on participants
//     List<String> ids = [senderId, receiverId];
//     ids.sort();
//     String chatRoomId = ids.join('_');

//     // Use serverTimestamp for consistency
//     final timestamp = FieldValue.serverTimestamp();

//     final Map<String, dynamic> messageData = {
//       'chatId': chatRoomId,
//       'senderId': senderId,
//       'receiverId': receiverId,
//       'message': message,
//       'timestamp': timestamp,
//     };

//     // 1. Add message to 'messages' subcollection
//     await _firestore
//         .collection('chats')
//         .doc(chatRoomId)
//         .collection('messages')
//         .add(messageData);

//     // 2. Update the chat document
//     await _firestore.collection('chats').doc(chatRoomId).set({
//       'participants': ids,
//       'lastMessage': message,
//       'lastMessageTime': timestamp,
//       'lastSenderId': senderId,
//     }, SetOptions(merge: true));
//   }

//   /// Stream of messages for a specific chat room
//   Stream<List<ChatModel>> streamMessages(String chatRoomId) {
//     return _firestore
//         .collection('chats')
//         .doc(chatRoomId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .snapshots()
//         .map((snapshot) {
//           return snapshot.docs
//               .map((doc) => ChatModel.fromMap(doc.data()))
//               .toList();
//         });
//   }

//   /// Stream of Chat Rooms for a specific user (Inbox)
//   Stream<QuerySnapshot> streamUserChats(String userId) {
//     return _firestore
//         .collection('chats')
//         .where('participants', arrayContains: userId)
//         .orderBy('lastMessageTime', descending: true)
//         .snapshots();
//   }

//   /// Helper to get conversation ID
//   String getChatRoomId(String user1, String user2) {
//     List<String> ids = [user1, user2];
//     ids.sort();
//     return ids.join('_');
//   }
// }

// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import '../models/chat_model.dart';

// class ChatController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final Dio _dio = Dio();

//   /// -------------------------
//   /// SEND MESSAGE (TEXT or IMAGE)
//   /// -------------------------
//   Future<void> sendMessage({
//     required String senderId,
//     required String receiverId,
//     String? message,
//     File? imageFile, // optional image
//   }) async {
//     String? imageUrl;

//     // Upload image if provided
//     if (imageFile != null) {
//       imageUrl = await _uploadImageToCloudinary(imageFile);
//     }

//     // Don't send empty message without image
//     if ((message == null || message.trim().isEmpty) && imageUrl == null) return;

//     // Generate unique chat room ID
//     List<String> ids = [senderId, receiverId]..sort();
//     String chatRoomId = ids.join('_');
//     final timestamp = FieldValue.serverTimestamp();

//     // Prepare message data
//     final Map<String, dynamic> messageData = {
//       'chatId': chatRoomId,
//       'senderId': senderId,
//       'receiverId': receiverId,
//       'message': message ?? '',
//       'imageUrl': imageUrl,
//       'timestamp': timestamp,
//     };

//     // Add message to 'messages' subcollection
//     await _firestore
//         .collection('chats')
//         .doc(chatRoomId)
//         .collection('messages')
//         .add(messageData);

//     // Update main chat document (for inbox/last message)
//     await _firestore.collection('chats').doc(chatRoomId).set({
//       'participants': ids,
//       'lastMessage': message ?? (imageUrl != null ? '📷 Image' : ''),
//       'lastMessageTime': timestamp,
//       'lastSenderId': senderId,
//     }, SetOptions(merge: true));

//   }

//   /// -------------------------
//   /// UPLOAD IMAGE TO CLOUDINARY
//   /// -------------------------
//   Future<String> _uploadImageToCloudinary(File file) async {
//     const cloudName = 'dzatmbj31';
//     const uploadPreset = 'chat_bucket';

//     final formData = FormData.fromMap({
//       'file': await MultipartFile.fromFile(file.path),
//       'upload_preset': uploadPreset,
//       'folder': 'chat_bucket', // optional folder
//     });

//     final response = await _dio.post(
//       'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
//       data: formData,
//     );

//     return response.data['secure_url'];
//   }

//   /// -------------------------
//   /// STREAM MESSAGES IN CHAT ROOM
//   /// -------------------------
//   Stream<List<ChatModel>> streamMessages(String chatRoomId) {
//     return _firestore
//         .collection('chats')
//         .doc(chatRoomId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map((doc) => ChatModel.fromMap(doc.data()))
//               .toList(),
//         );
//   }

//   /// -------------------------
//   /// STREAM USER'S CHAT ROOMS (INBOX)
//   /// -------------------------
//   Stream<QuerySnapshot> streamUserChats(String userId) {
//     return _firestore
//         .collection('chats')
//         .where('participants', arrayContains: userId)
//         .orderBy('lastMessageTime', descending: true)
//         .snapshots();
//   }

//   /// -------------------------
//   /// GENERATE CHAT ROOM ID
//   /// -------------------------
//   String getChatRoomId(String user1, String user2) {
//     List<String> ids = [user1, user2]..sort();
//     return ids.join('_');
//   }
// }

import 'dart:io';
import 'package:auctify/screens/Notification/notification_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import '../models/chat_model.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Dio _dio = Dio();
  final NotificationHelper _notificationHelper = NotificationHelper();

  /// -------------------------
  /// SEND MESSAGE (TEXT or IMAGE) + NOTIFICATION
  /// -------------------------
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    String? message,
    File? imageFile,
  }) async {
    String? imageUrl;

    // Upload image if provided
    if (imageFile != null) {
      imageUrl = await _uploadImageToCloudinary(imageFile);
    }

    // Don't send empty message without image
    if ((message == null || message.trim().isEmpty) && imageUrl == null) return;

    // Generate unique chat room ID
    List<String> ids = [senderId, receiverId]..sort();
    String chatRoomId = ids.join('_');
    final timestamp = FieldValue.serverTimestamp();

    // Prepare message data
    final Map<String, dynamic> messageData = {
      'chatId': chatRoomId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message ?? '',
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'read': false,
    };

    // Add message to 'messages' subcollection
    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(messageData);

    // Update main chat document (for inbox/last message)
    await _firestore.collection('chats').doc(chatRoomId).set({
      'participants': ids,
      'lastMessage': message ?? (imageUrl != null ? '📷 Image' : ''),
      'lastMessageTime': timestamp,
      'lastSenderId': senderId,
    }, SetOptions(merge: true));

    // ✅ Send a notification to the receiver
    await _notificationHelper.createNotification(
      userId: receiverId,
      type: 'message',
      title: 'New message',
      message: message ?? '📷 Image',
    );
  }

  /// -------------------------
  /// UPLOAD IMAGE TO CLOUDINARY
  /// -------------------------
  Future<String> _uploadImageToCloudinary(File file) async {
    const cloudName = 'dzatmbj31';
    const uploadPreset = 'chat_bucket';

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'upload_preset': uploadPreset,
      'folder': 'chat_bucket',
    });

    final response = await _dio.post(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      data: formData,
    );

    return response.data['secure_url'];
  }

  /// -------------------------
  /// STREAM MESSAGES IN CHAT ROOM
  /// -------------------------
  Stream<List<ChatModel>> streamMessages(String chatRoomId) {
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatModel.fromMap(doc.data()))
              .toList(),
        );
  }

  /// -------------------------
  /// STREAM USER'S CHAT ROOMS (INBOX)
  /// -------------------------
  Stream<QuerySnapshot> streamUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  /// -------------------------
  /// GENERATE CHAT ROOM ID
  /// -------------------------
  String getChatRoomId(String user1, String user2) {
    List<String> ids = [user1, user2]..sort();
    return ids.join('_');
  }

  /// Marks all unread messages in a chat as read for the current user
  Future<void> markMessagesRead({
    required String chatRoomId,
    required String userId,
  }) async {
    final unreadMessages = await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .get();

    final batch = _firestore.batch();

    for (var doc in unreadMessages.docs) {
      batch.update(doc.reference, {'read': true});
    }

    await batch.commit();
  }
}
