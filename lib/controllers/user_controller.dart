import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserController {
  final UserService _userService = UserService();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<UserModel?> streamCurrentUser() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _userService.streamUser(uid);
  }

  Future<void> updateProfile({
    required String uid,
    String? name,
    String? profileImageUrl,
  }) async {
    await _userService.updateUserFields(uid, {
      if (name != null) 'name': name,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
    });
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return await _userService.getUserById(uid);
  }
}
