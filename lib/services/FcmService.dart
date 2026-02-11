// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class FcmService {
//   Future<void> saveFcmToken(String uid) async {
//   final token = await FirebaseMessaging.instance.getToken();

//   if (token != null) {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .update({
//       'fcmToken': token,
//     });
//   }
// }

//   /// Handle token refresh (important!)
//   static void listenForTokenRefresh(String uid) {
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
//       await FirebaseFirestore.instance.collection('users').doc(uid).update({
//         'fcmToken': newToken,
//       });
//     });
//   }
// }
