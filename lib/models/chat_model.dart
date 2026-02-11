import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatModel {
//   String chatId;
//   String senderId;
//   String receiverId;
//   String message;
//   Timestamp timestamp;

//   ChatModel({
//     required this.chatId,
//     required this.senderId,
//     required this.receiverId,
//     required this.message,
//     required this.timestamp,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'chatId': chatId,
//       'senderId': senderId,
//       'receiverId': receiverId,
//       'message': message,
//       'timestamp': timestamp,
//     };
//   }

//   factory ChatModel.fromMap(Map<String, dynamic> map) {
//     return ChatModel(
//       chatId: map['chatId'] ?? '',
//       senderId: map['senderId'] ?? '',
//       receiverId: map['receiverId'] ?? '',
//       message: map['message'] ?? '',
//       timestamp: map['timestamp'] is Timestamp
//           ? map['timestamp'] as Timestamp
//           : Timestamp.now(), // Fallback for loading state
//     );
//   }
// }

class ChatModel {
  String chatId;
  String senderId;
  String receiverId;
  String message;
  Timestamp timestamp;
  String? imageUrl; // New field

  ChatModel({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'imageUrl': imageUrl, // include it
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? map['timestamp'] as Timestamp
          : Timestamp.now(),
      imageUrl: map['imageUrl'], // new
    );
  }
}
