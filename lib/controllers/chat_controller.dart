import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auctify/models/chat_model.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Send a message and update/create the conversation doc
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    if (message.trim().isEmpty) return;

    // Generate a unique chat ID based on participants
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    // Use serverTimestamp for consistency
    final timestamp = FieldValue.serverTimestamp();

    final Map<String, dynamic> messageData = {
      'chatId': chatRoomId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };

    // 1. Add message to 'messages' subcollection
    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(messageData);

    // 2. Update the chat document
    await _firestore.collection('chats').doc(chatRoomId).set({
      'participants': ids,
      'lastMessage': message,
      'lastMessageTime': timestamp,
      'lastSenderId': senderId,
    }, SetOptions(merge: true));
  }

  /// Stream of messages for a specific chat room
  Stream<List<ChatModel>> streamMessages(String chatRoomId) {
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ChatModel.fromMap(doc.data()))
              .toList();
        });
  }

  /// Stream of Chat Rooms for a specific user (Inbox)
  Stream<QuerySnapshot> streamUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  /// Helper to get conversation ID
  String getChatRoomId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return ids.join('_');
  }
}
