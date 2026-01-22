// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../utils/constants.dart';

// class ForgetPassword extends StatefulWidget {
//   const ForgetPassword({Key? key}) : super(key: key);

//   @override
//   State<ForgetPassword> createState() => _ForgetPasswordState();
// }

// class _ForgetPasswordState extends State<ForgetPassword> {
//   final TextEditingController _emailController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _loading = false;

//   void _showSnackBar(String message, {Color bgColor = Colors.black}) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(message), backgroundColor: bgColor));
//   }

//   Future<void> _resetPassword() async {
//     final email = _emailController.text.trim();
//     if (email.isEmpty) {
//       _showSnackBar('Please enter your email', bgColor: Colors.red);
//       return;
//     }

//     setState(() => _loading = true);

//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//       _showSnackBar('Password reset email sent!', bgColor: Colors.green);
//     } on FirebaseAuthException catch (e) {
//       String message = 'Failed to send email';
//       if (e.code == 'user-not-found') message = 'No user found with this email';
//       _showSnackBar(message, bgColor: Colors.red);
//     } catch (e) {
//       _showSnackBar('Error: $e', bgColor: Colors.red);
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: AppBar(title: Text('Forgot Password', style: GoogleFonts.lato())),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Enter your email to reset password',
//               style: GoogleFonts.lato(fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: _loading ? null : _resetPassword,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: _loading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text(
//                         'Send Reset Email',
//                         style: GoogleFonts.lato(fontSize: 16),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:auctify/utils/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;

  /// Show snackbar with app theme colors
  void _showSnackBar(String message, {Color? bgColor}) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: bgColor ?? theme.colorScheme.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Reset password email
  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnackBar('Please enter your email', bgColor: Colors.red);
      return;
    }

    setState(() => _loading = true);

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSnackBar('Password reset email sent!', bgColor: Colors.green);
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to send email';
      if (e.code == 'user-not-found')
        message = 'No user found with this email';
      else if (e.code == 'invalid-email')
        message = 'Invalid email address';
      _showSnackBar(message, bgColor: Colors.red);
    } catch (e) {
      _showSnackBar('Error: $e', bgColor: Colors.red);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Forgor Passwoed"),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your email to reset password',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: theme.hintColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: theme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _loading
                      ? CircularProgressIndicator(
                          color: theme.colorScheme.onPrimary,
                        )
                      : Text(
                          'Send Reset Email',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
