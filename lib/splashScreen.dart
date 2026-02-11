// // import 'dart:async';

// // import 'package:auctify/layout/layout.dart';
// // import 'package:auctify/login/login_page.dart';
// // import 'package:auctify/utils/constants.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';

// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});

// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }

// // class _SplashScreenState extends State<SplashScreen> {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _checkUserRole();
// //   }

// //   Future<void> _checkUserRole() async {
// //     // Small delay for splash effect
// //     await Future.delayed(const Duration(seconds: 2));

// //     final user = _auth.currentUser;

// //     if (user == null) {
// //       // Not logged in → go to Login
// //       if (!mounted) return;
// //       Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
// //       return;
// //     }

// //     try {
// //       final doc = await _firestore.collection('users').doc(user.uid).get();

// //       if (!doc.exists || doc.data() == null) {
// //         // User doc missing → go to login
// //         if (!mounted) return;
// //         Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
// //         return;
// //       }

// //       // final role = doc.data()!['role'] ?? 'user';

// //       // if (!mounted) return;

// //       // // if (role == 'admin') {
// //       // //   Navigator.pushReplacement(
// //       // //     context,
// //       // //     MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
// //       // //   );
// //       // // }
// //       //  else {
// //       //   Navigator.pushReplacement(
// //       //     context,
// //       //     MaterialPageRoute(builder: (_) => const Layout()),
// //       //   );
// //       // }
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (_) => Layout()),
// //       );
// //     } catch (e) {
// //       // Error fetching role → fallback to login
// //       if (!mounted) return;
// //      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.primary,
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: const [
// //             Icon(Icons.hive, color: Colors.white, size: 80),
// //             SizedBox(height: 20),
// //             Text(
// //               "Auctify",
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 28,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             SizedBox(height: 10),
// //             CircularProgressIndicator(color: Colors.white),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:async';
// import 'package:auctify/login/login_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../../layout/layout.dart';
// import '../../utils/constants.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );

//     _scaleAnimation = Tween<double>(
//       begin: 0.7,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     _controller.forward();
//     _checkAuth();
//   }

//   void _checkAuth() async {
//     await Future.delayed(const Duration(seconds: 3));

//     final user = FirebaseAuth.instance.currentUser;

//     if (!mounted) return;

//     if (user != null) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const Layout()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginPage()),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primary,
//       body: Center(
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: ScaleTransition(
//             scale: _scaleAnimation,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Icon(Icons.gavel_rounded, size: 100, color: Colors.white),
//                 SizedBox(height: 16),
//                 Text(
//                   'SellSpot',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../layout/layout.dart';
import '../../login/login_page.dart';
import '../../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _scale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigate();
    });
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => user == null ? const LoginPage() : const Layout(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 🔹 Replace this Icon with your app logo image later
                  Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(28),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/icon/icon.png"),
                      ),
                    ),
                    // child: const Center(
                    //   child: Text(
                    //     'S',
                    //     style: TextStyle(
                    //       fontSize: 56,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'SellSpot',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 1.3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Buy • Sell • Auction',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
