// import 'dart:io';

// import 'package:auctify/layout/layout.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../models/user_model.dart';
// import '../services/user_service.dart';

// class AuthController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final UserService _userService = UserService();

//   Future<void> signUp({
//     required BuildContext context,
//     required String name,
//     required String email,
//     required String password,
//     File? profileImage, // optional image
//   }) async {
//     UserCredential credential = await _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );

//     final uid = credential.user!.uid;

//     String profileImageUrl = ''; // default empty

//     if (profileImage != null) {
//       profileImageUrl = await _userService.uploadProfileImage(profileImage);
//     }

//     UserModel user = UserModel(
//       uid: uid,
//       name: name,
//       email: email,
//       profileImageUrl: profileImageUrl,
//     );

//     await _userService.createUser(user);

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => Layout()),
//     );
//   }

//   /// 🔹 LOGIN
//   Future<void> login({
//     required BuildContext context,
//     required String email,
//     required String password,
//   }) async {
//     await _auth.signInWithEmailAndPassword(email: email, password: password);

//     /// 🔹 Navigate to Home
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => Layout()),
//     );
//   }
// }

import 'dart:io';

import 'package:auctify/layout/layout.dart';
import 'package:auctify/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  /// 🔹 SHOW SNACKBAR
  void _showSnackBar(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.black,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// 🔹 SIGN UP
  Future<void> signUp({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    File? profileImage,
  }) async {
    try {
      _showSnackBar(
        context,
        'Creating account...',
        backgroundColor: Colors.blue,
      );

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      String profileImageUrl = '';

      if (profileImage != null) {
        try {
          profileImageUrl = await _userService.uploadProfileImage(profileImage);
        } catch (e) {
          _showSnackBar(
            context,
            'Profile image upload failed',
            backgroundColor: Colors.orange,
          );
        }
      }

      UserModel user = UserModel(
        uid: uid,
        name: name,
        email: email,
        profileImageUrl: profileImageUrl,
      );

      await _userService.createUser(user);

      _showSnackBar(
        context,
        'Account created successfully!',
        backgroundColor: Colors.green,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Layout()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Signup failed';
      if (e.code == 'email-already-in-use')
        message = 'Email is already in use';
      else if (e.code == 'weak-password')
        message = 'Password is too weak';
      else if (e.code == 'invalid-email')
        message = 'Invalid email';

      _showSnackBar(context, message, backgroundColor: Colors.red);
    } catch (e) {
      _showSnackBar(
        context,
        'An error occurred: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  /// 🔹 LOGIN
  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      _showSnackBar(
        context,
        'Logging in...',
        backgroundColor: AppColors.primary,
      );

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Layout()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found')
        message = 'No user found for that email';
      else if (e.code == 'wrong-password')
        message = 'Incorrect password';

      _showSnackBar(context, message, backgroundColor: Colors.red);
    } catch (e) {
      _showSnackBar(
        context,
        'An error occurred: $e',
        backgroundColor: Colors.red,
      );
    }
  }
}
