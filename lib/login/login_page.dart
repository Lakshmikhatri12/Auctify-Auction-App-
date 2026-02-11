// import 'package:auctify/controllers/auth_controller.dart';
// import 'package:auctify/login/signup_page.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final AuthController authController = AuthController();
//   bool _obscurePassword = true;
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   final FocusNode emailFocus = FocusNode();
//   final FocusNode passwordFocus = FocusNode();

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     [emailFocus, passwordFocus].forEach(
//       (node) => node.addListener(() => setState(() {})),
//     ); // update UI on focus
//   }

//   @override
//   void dispose() {
//     [emailFocus, passwordFocus].forEach((node) => node.dispose());
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             /// HEADER
//             Container(
//               height: 220,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.primary,
//                     AppColors.primary.withOpacity(0.85),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               child: const Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.hive, size: 70, color: Colors.white),
//                   SizedBox(height: 8),
//                   Text(
//                     "Welcome Back",
//                     style: TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             /// FORM CARD
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Card(
//                 elevation: 6,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         /// Email
//                         TextFormField(
//                           controller: emailController,
//                           focusNode: emailFocus,
//                           decoration: _inputDecoration(
//                             label: "Email",
//                             icon: Icons.email_outlined,
//                             focusNode: emailFocus,
//                             hint: "Enter your email",
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Please enter email";
//                             }
//                             if (!value.contains("@")) {
//                               return "Enter valid email";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),

//                         /// Password
//                         TextFormField(
//                           controller: passwordController,
//                           focusNode: passwordFocus,
//                           obscureText: _obscurePassword,
//                           decoration: _inputDecoration(
//                             label: "Password",
//                             icon: Icons.lock_outline_rounded,
//                             focusNode: passwordFocus,
//                             hint: "Enter your password",
//                             suffix: IconButton(
//                               icon: Icon(
//                                 _obscurePassword
//                                     ? Icons.visibility_off_outlined
//                                     : Icons.remove_red_eye_outlined,
//                                 color: AppColors.primary.withOpacity(0.7),
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscurePassword = !_obscurePassword;
//                                 });
//                               },
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 10),

//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () {},
//                             child: const Text(
//                               "Forgot Password?",
//                               style: TextStyle(color: AppColors.primary),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 20),

//                         /// Login Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed: _isLoading
//                                 ? null
//                                 : () async {
//                                     if (!_formKey.currentState!.validate())
//                                       return;

//                                     setState(() => _isLoading = true);

//                                     try {
//                                       // Use the controller's login function which already shows SnackBars
//                                       await authController.login(
//                                         context: context,
//                                         email: emailController.text.trim(),
//                                         password: passwordController.text
//                                             .trim(),
//                                       );
//                                     } finally {
//                                       if (mounted)
//                                         setState(() => _isLoading = false);
//                                     }
//                                   },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.primary,
//                             ),
//                             child: _isLoading
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                 : const Text("Login"),
//                           ),
//                         ),

//                         const SizedBox(height: 24),

//                         /// OR Divider
//                         Row(
//                           children: const [
//                             Expanded(child: Divider()),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 8),
//                               child: Text("OR"),
//                             ),
//                             Expanded(child: Divider()),
//                           ],
//                         ),

//                         const SizedBox(height: 20),

//                         /// Social Buttons
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             _socialButton(
//                               icon: FontAwesomeIcons.google,
//                               color: Colors.red,
//                               onTap: () {},
//                             ),
//                             const SizedBox(width: 20),
//                             _socialButton(
//                               icon: FontAwesomeIcons.facebook,
//                               color: Colors.blue,
//                               onTap: () {},
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             /// Sign Up
//             const SizedBox(height: 10),
//             const Text(
//               "Don't have an account?",
//               style: TextStyle(color: Color(0xFF565D6D)),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const SignUpPage()),
//                 );
//               },
//               child: const Text(
//                 "Sign Up",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primary,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ===============================
//   /// Input Decoration
//   /// ===============================
//   InputDecoration _inputDecoration({
//     required String label,
//     required IconData icon,
//     FocusNode? focusNode,
//     String? hint,
//     Widget? suffix,
//   }) {
//     return InputDecoration(
//       labelText: label,
//       hintText: hint,
//       labelStyle: TextStyle(
//         color: (focusNode != null && focusNode.hasFocus)
//             ? AppColors.primary
//             : Colors.grey.shade700,
//         fontWeight: FontWeight.w500,
//       ),
//       hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
//       prefixIcon: Icon(
//         icon,
//         color: (focusNode != null && focusNode.hasFocus)
//             ? AppColors.primary
//             : Colors.grey.shade600,
//       ),
//       suffixIcon: suffix,
//       filled: true,
//       fillColor: Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: AppColors.primary, width: 2),
//       ),
//     );
//   }

//   Widget _socialButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(50),
//       child: CircleAvatar(
//         radius: 26,
//         backgroundColor: color.withOpacity(0.1),
//         child: FaIcon(icon, color: color),
//       ),
//     );
//   }
// }

// import 'package:auctify/controllers/auth_controller.dart';
// import 'package:auctify/login/forget_password.dart';
// import 'package:auctify/login/signup_page.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final AuthController authController = AuthController();
//   final _formKey = GlobalKey<FormState>();
//   bool _obscurePassword = true;
//   bool _isLoading = false;

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   final FocusNode emailFocus = FocusNode();
//   final FocusNode passwordFocus = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     [
//       emailFocus,
//       passwordFocus,
//     ].forEach((node) => node.addListener(() => setState(() {})));
//   }

//   @override
//   void dispose() {
//     [emailFocus, passwordFocus].forEach((node) => node.dispose());
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             /// HEADER
//             Container(
//               height: 220,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.primary,
//                     AppColors.primary.withOpacity(0.85),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               child: const Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.hive, size: 70, color: Colors.white),
//                   SizedBox(height: 8),
//                   Text(
//                     "Welcome Back",
//                     style: TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             /// FORM CARD
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Card(
//                 elevation: 6,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         /// Email
//                         TextFormField(
//                           controller: emailController,
//                           focusNode: emailFocus,
//                           decoration: _inputDecoration(
//                             label: "Email",
//                             icon: Icons.email_outlined,
//                             focusNode: emailFocus,
//                             hint: "Enter your email",
//                           ),
//                           keyboardType: TextInputType.emailAddress,
//                           validator: (value) {
//                             if (value == null || value.isEmpty)
//                               return "Please enter email";
//                             final emailRegex = RegExp(
//                               r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
//                             );
//                             if (!emailRegex.hasMatch(value))
//                               return "Enter valid email";
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),

//                         /// Password
//                         TextFormField(
//                           controller: passwordController,
//                           focusNode: passwordFocus,
//                           obscureText: _obscurePassword,
//                           decoration: _inputDecoration(
//                             label: "Password",
//                             icon: Icons.lock_outline_rounded,
//                             focusNode: passwordFocus,
//                             hint: "Enter your password",
//                             suffix: IconButton(
//                               icon: Icon(
//                                 _obscurePassword
//                                     ? Icons.visibility_off_outlined
//                                     : Icons.remove_red_eye_outlined,
//                                 color: AppColors.primary.withOpacity(0.7),
//                               ),
//                               onPressed: () => setState(
//                                 () => _obscurePassword = !_obscurePassword,
//                               ),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty)
//                               return "Please enter password";
//                             if (value.length < 8)
//                               return "Password must be at least 8 characters";
//                             return null;
//                           },
//                         ),
//                         Align(
//                           alignment: AlignmentGeometry.centerRight,
//                           child: TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ForgetPassword(),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               "Forget Password",
//                               style: GoogleFonts.lato(
//                                 color: AppColors.primary,
//                                 fontSize: 11,

//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 20),

//                         /// Login Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed: _isLoading
//                                 ? null
//                                 : () async {
//                                     if (!_formKey.currentState!.validate())
//                                       return;
//                                     setState(() => _isLoading = true);
//                                     try {
//                                       await authController.login(
//                                         context: context,
//                                         email: emailController.text.trim(),
//                                         password: passwordController.text
//                                             .trim(),
//                                       );
//                                     } finally {
//                                       if (mounted)
//                                         setState(() => _isLoading = false);
//                                     }
//                                   },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.primary,
//                             ),
//                             child: _isLoading
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                 : const Text("Login"),
//                           ),
//                         ),

//                         SizedBox(height: 57),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 24),
//                           child: Row(
//                             children: const [
//                               Expanded(
//                                 child: Divider(
//                                   thickness: 1,
//                                   color: Color(0xFF565D6D),
//                                 ),
//                               ),
//                               Text(
//                                 "  OR  ",
//                                 style: TextStyle(color: Color(0xFF565D6D)),
//                               ),
//                               Expanded(
//                                 child: Divider(
//                                   thickness: 1,
//                                   color: Color(0xFF565D6D),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 30),
//                         GestureDetector(
//                           onTap: () {
//                             AuthController().signInWithGoogle(context);
//                           },
//                           child: Container(
//                             width: 342,
//                             height: 48,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(
//                                 width: 1,
//                                 color: Color(0xFF171A1F),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 FaIcon(
//                                   size: 24,
//                                   FontAwesomeIcons.google,
//                                   color: Color(0xFF171A1F),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   "Continue with Google",
//                                   style: GoogleFonts.lato(
//                                     color: Color(0xFF171A1F),
//                                     fontSize: 14,

//                                     fontWeight: FontWeight.w500,
//                                     height: 22 / 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 20),

//                         /// Sign Up
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Don't have an account?",
//                               style: TextStyle(color: Color(0xFF565D6D)),
//                             ),
//                             TextButton(
//                               onPressed: () => Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => const SignUpPage(),
//                                 ),
//                               ),
//                               child: const Text(
//                                 "Sign Up",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.primary,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration({
//     required String label,
//     required IconData icon,
//     FocusNode? focusNode,
//     String? hint,
//     Widget? suffix,
//   }) {
//     return InputDecoration(
//       labelText: label,
//       hintText: hint,
//       labelStyle: TextStyle(
//         color: (focusNode != null && focusNode.hasFocus)
//             ? AppColors.primary
//             : Colors.grey.shade700,
//         fontWeight: FontWeight.w500,
//       ),
//       hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
//       prefixIcon: Icon(
//         icon,
//         color: (focusNode != null && focusNode.hasFocus)
//             ? AppColors.primary
//             : Colors.grey.shade600,
//       ),
//       suffixIcon: suffix,
//       filled: true,
//       fillColor: Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: Colors.grey.shade400),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: Colors.grey.shade400),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(color: AppColors.primary, width: 2),
//       ),
//     );
//   }
// }

import 'package:auctify/controllers/auth_controller.dart';
import 'package:auctify/login/forget_password.dart';
import 'package:auctify/login/signup_page.dart';
import 'package:auctify/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = AuthController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    emailFocus.addListener(() => setState(() {}));
    passwordFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            /// HEADER
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "SellSpot",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Buy • Sell • Auction",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            /// FORM CARD
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 8,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /// EMAIL
                        TextFormField(
                          controller: emailController,
                          focusNode: emailFocus,
                          decoration: _inputDecoration(
                            label: "Email",
                            icon: Icons.email_outlined,
                            focusNode: emailFocus,
                            hint: "example@email.com",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) =>
                              v == null || v.isEmpty ? "Enter email" : null,
                        ),

                        const SizedBox(height: 18),

                        /// PASSWORD
                        TextFormField(
                          controller: passwordController,
                          focusNode: passwordFocus,
                          obscureText: _obscurePassword,
                          decoration: _inputDecoration(
                            label: "Password",
                            icon: Icons.lock_outline,
                            focusNode: passwordFocus,
                            hint: "••••••••",
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.primary,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ForgetPassword(),
                              ),
                            ),
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// LOGIN BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate())
                                      return;
                                    setState(() => _isLoading = true);
                                    await authController.login(
                                      context: context,
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    );
                                    if (mounted)
                                      setState(() => _isLoading = false);
                                  },
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        /// DIVIDER
                        Row(
                          children: const [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "OR",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 22),

                        /// GOOGLE LOGIN
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () =>
                              authController.signInWithGoogle(context),
                          icon: const FaIcon(FontAwesomeIcons.google),
                          label: const Text("Continue with Google"),
                        ),

                        const SizedBox(height: 20),

                        /// SIGN UP
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don’t have an account?"),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpPage(),
                                ),
                              ),
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    FocusNode? focusNode,
    String? hint,
    Widget? suffix,
  }) {
    final isFocused = focusNode?.hasFocus ?? false;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: isFocused ? AppColors.primary : Colors.grey,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}
