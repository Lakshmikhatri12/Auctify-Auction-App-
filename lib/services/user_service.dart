import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Dio _dio = Dio();

  CollectionReference get _users => _firestore.collection('users');

  /// Upload user profile image to Cloudinary
  Future<String> uploadProfileImage(File file) async {
    const cloudName = 'dzatmbj31'; // Your Cloudinary cloud name
    const uploadPreset =
        'user_bucket'; // You can create a separate preset for users

    final response = await _dio.post(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      data: FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'upload_preset': uploadPreset,
        'folder': 'users', // organize images under "users" folder
      }),
    );

    return response.data['secure_url']; // Returns the Cloudinary URL
  }

  /// Create new user in Firestore
  Future<void> createUser(UserModel user) async {
    await _users.doc(user.uid).set(user.toMap());
  }

  /// Get user by UID
  Future<UserModel?> getUserById(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  /// Stream current user
  Stream<UserModel?> streamUser(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  /// Update user fields
  Future<void> updateUserFields(String uid, Map<String, dynamic> data) async {
    await _users.doc(uid).update(data);
  }

  Stream<List<UserModel>> streamAllUsers() {
    return _users.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // --- Wishlist Methods ---

  /// Toggle item in wishlist (Add/Remove)
  Future<void> toggleWishlist(String userId, String auctionId) async {
    final docRef = _users.doc(userId).collection('wishlist').doc(auctionId);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'addedAt': FieldValue.serverTimestamp(),
        'auctionId': auctionId,
      });
    }
  }

  /// Check if item is in wishlist
  Future<bool> isWishlisted(String userId, String auctionId) async {
    final doc = await _users
        .doc(userId)
        .collection('wishlist')
        .doc(auctionId)
        .get();
    return doc.exists;
  }

  /// Stream of wishlist auction IDs
  Stream<List<String>> streamWishlistIds(String userId) {
    return _users
        .doc(userId)
        .collection('wishlist')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }
}
