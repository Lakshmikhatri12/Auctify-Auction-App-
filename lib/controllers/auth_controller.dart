import 'dart:io';

import 'package:auctify/layout/layout.dart';
import 'package:auctify/login/login_page.dart';
import 'package:auctify/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  /// 🔹 NAVIGATE BASED ON ROLE
  // void _navigateBasedOnRole(BuildContext context, UserModel user) {
  //   if (user.role == 'admin') {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => AdminDashboardScreen()),
  //     );
  //   } else {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => Layout()),
  //     );
  //   }
  // }

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

      // 1️⃣ Sign in with Firebase Auth
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // 2️⃣ Fetch user document from Firestore
      final doc = await _userService.getUserById(uid);

      if (doc == null) {
        _showSnackBar(
          context,
          'User data not found',
          backgroundColor: Colors.red,
        );
        return;
      }

      // 3️⃣ Check role
      // if (doc.role == 'admin') {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (_) => AdminLayout()),
      //   );
      // } else
      {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Layout()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password';
      }

      _showSnackBar(context, message, backgroundColor: Colors.red);
    } catch (e) {
      _showSnackBar(
        context,
        'An error occurred: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  /// 🔹 FORGOT PASSWORD
  Future<void> forgotPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      if (email.isEmpty) {
        _showSnackBar(
          context,
          'Please enter your email',
          backgroundColor: AppColors.primary,
        );
        return;
      }

      await _auth.sendPasswordResetEmail(email: email);

      _showSnackBar(
        context,
        'Password reset link sent to your email',
        backgroundColor: Colors.green,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to send reset email';

      if (e.code == 'user-not-found') {
        message = 'No account found with this email';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }

      _showSnackBar(context, message, backgroundColor: Colors.red);
    } catch (e) {
      _showSnackBar(
        context,
        'An error occurred: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  /// 🔹 GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return; // user cancelled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final user = userCredential.user!;
      final uid = user.uid;

      // 🔹 Check if user already exists in Firestore
      final existingUser = await _userService.getUserById(uid);

      if (existingUser == null) {
        // 🔹 Create new user document
        UserModel newUser = UserModel(
          uid: uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          profileImageUrl: user.photoURL ?? '',
        );

        await _userService.createUser(newUser);
      }

      _showSnackBar(context, 'Login successful', backgroundColor: Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Layout()),
      );
    } on FirebaseAuthException catch (e) {
      _showSnackBar(
        context,
        'Google sign-in failed: ${e.message}',
        backgroundColor: Colors.red,
      );
    } catch (e) {
      _showSnackBar(
        context,
        'An error occurred: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  /// 🔹 LOGOUT
  Future<void> logout(BuildContext context) async {
    try {
      // Sign out from Google (if logged in)
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      // Sign out from Firebase
      await _auth.signOut();

      _showSnackBar(
        context,
        'Logged out successfully',
        backgroundColor: Colors.green,
      );

      // Navigate to Login Screen & clear stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      _showSnackBar(context, 'Logout failed: $e', backgroundColor: Colors.red);
    }
  }
}
