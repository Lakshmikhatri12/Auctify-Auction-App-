// import 'package:auctify/controllers/auth_controller.dart';
// import 'package:auctify/login/login_page.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final AuthController authController = AuthController();
//   bool _obscurePassword = true;
//   bool _obscureConfirm = true;
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmController = TextEditingController();

//   final FocusNode nameFocus = FocusNode();
//   final FocusNode emailFocus = FocusNode();
//   final FocusNode phoneFocus = FocusNode();
//   final FocusNode passwordFocus = FocusNode();
//   final FocusNode confirmFocus = FocusNode();

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     // Rebuild when focus changes to update icon and label colors
//     [
//       nameFocus,
//       emailFocus,
//       phoneFocus,
//       passwordFocus,
//       confirmFocus,
//     ].forEach((node) => node.addListener(() => setState(() {})));
//   }

//   @override
//   void dispose() {
//     [
//       nameFocus,
//       emailFocus,
//       phoneFocus,
//       passwordFocus,
//       confirmFocus,
//     ].forEach((node) => node.dispose());
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
//                     "Create Account",
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
//                         /// Name
//                         TextFormField(
//                           controller: nameController,
//                           focusNode: nameFocus,
//                           decoration: _inputDecoration(
//                             label: "Name",
//                             icon: Icons.person_outline,
//                             focusNode: nameFocus,
//                             hint: "Enter your full name",
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Please enter your name";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),

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

//                         /// Phone
//                         TextFormField(
//                           controller: phoneController,
//                           focusNode: phoneFocus,
//                           keyboardType: TextInputType.phone,
//                           decoration: _inputDecoration(
//                             label: "Phone Number",
//                             icon: Icons.phone_outlined,
//                             focusNode: phoneFocus,
//                             hint: "Enter your phone number",
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Please enter phone number";
//                             }
//                             if (value.length < 10) {
//                               return "Enter valid phone number";
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
//                             hint: "Enter password",
//                             suffix: IconButton(
//                               icon: Icon(
//                                 _obscurePassword
//                                     ? Icons.visibility_off_outlined
//                                     : Icons.remove_red_eye_outlined,
//                                 color: Colors.grey.shade600,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscurePassword = !_obscurePassword;
//                                 });
//                               },
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Please enter password";
//                             }
//                             if (value.length < 8) {
//                               return "Minimum 8 characters required";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),

//                         /// Confirm Password
//                         TextFormField(
//                           controller: confirmController,
//                           focusNode: confirmFocus,
//                           obscureText: _obscureConfirm,
//                           decoration: _inputDecoration(
//                             label: "Confirm Password",
//                             icon: Icons.lock_outline_rounded,
//                             focusNode: confirmFocus,
//                             hint: "Confirm Password",
//                             suffix: IconButton(
//                               icon: Icon(
//                                 _obscureConfirm
//                                     ? Icons.visibility_off_outlined
//                                     : Icons.remove_red_eye_outlined,
//                                 color: Colors.grey.shade600,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscureConfirm = !_obscureConfirm;
//                                 });
//                               },
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Please confirm password";
//                             }
//                             if (value != passwordController.text) {
//                               return "Passwords do not match";
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 24),

//                         /// Sign Up Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed: _isLoading
//                                 ? null
//                                 : () async {
//                                     if (!_formKey.currentState!.validate()) {
//                                       return;
//                                     }
//                                     setState(() => _isLoading = true);
//                                     try {
//                                       // TODO: connect to your signup flow
//                                       authController.signUp(
//                                         context: context,
//                                         name: nameController.text,
//                                         email: emailController.text,
//                                         password: passwordController.text,
//                                       );
//                                       await Future.delayed(
//                                         const Duration(seconds: 1),
//                                       );
//                                       if (!mounted) return;
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         const SnackBar(
//                                           content: Text('Signed up'),
//                                         ),
//                                       );
//                                     } finally {
//                                       if (mounted) {
//                                         setState(() => _isLoading = false);
//                                       }
//                                     }
//                                   },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.primary,
//                             ),
//                             child: _isLoading
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                 : const Text("Sign Up"),
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

//             /// Login Redirect
//             const SizedBox(height: 10),
//             const Text(
//               "Already have an account?",
//               style: TextStyle(color: Color(0xFF565D6D)),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => LoginPage()),
//                 );
//               },
//               child: const Text(
//                 "Login",
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
//   /// Reusable Widgets
//   /// ===============================
//   InputDecoration _inputDecoration({
//     String? hint,
//     required String label,
//     required IconData icon,
//     FocusNode? focusNode,
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

import 'package:auctify/controllers/auth_controller.dart';
import 'package:auctify/login/login_page.dart';
import 'package:auctify/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthController authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    [
      nameFocus,
      emailFocus,
      phoneFocus,
      passwordFocus,
      confirmFocus,
    ].forEach((node) => node.addListener(() => setState(() {})));
  }

  @override
  void dispose() {
    [
      nameFocus,
      emailFocus,
      phoneFocus,
      passwordFocus,
      confirmFocus,
    ].forEach((node) => node.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.85),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hive, size: 70, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            /// FORM CARD
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /// Name
                        TextFormField(
                          controller: nameController,
                          focusNode: nameFocus,
                          decoration: _inputDecoration(
                            label: "Name",
                            icon: Icons.person_outline,
                            focusNode: nameFocus,
                            hint: "Enter full name",
                          ),
                          validator: (value) => (value == null || value.isEmpty)
                              ? "Enter your name"
                              : null,
                        ),
                        const SizedBox(height: 16),

                        /// Email
                        TextFormField(
                          controller: emailController,
                          focusNode: emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(
                            label: "Email",
                            icon: Icons.email_outlined,
                            focusNode: emailFocus,
                            hint: "Enter your email",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Enter email";
                            final emailRegex = RegExp(
                              r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                            );
                            if (!emailRegex.hasMatch(value))
                              return "Enter valid email";
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        /// Phone
                        TextFormField(
                          controller: phoneController,
                          focusNode: phoneFocus,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration(
                            label: "Phone",
                            icon: Icons.phone_outlined,
                            focusNode: phoneFocus,
                            hint: "Enter phone number",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Enter phone";
                            if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value))
                              return "Enter valid phone number";
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        /// Password
                        TextFormField(
                          controller: passwordController,
                          focusNode: passwordFocus,
                          obscureText: _obscurePassword,
                          decoration: _inputDecoration(
                            label: "Password",
                            icon: Icons.lock_outline_rounded,
                            focusNode: passwordFocus,
                            hint: "Enter password",
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.remove_red_eye_outlined,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Enter password";
                            if (value.length < 8)
                              return "Password must be at least 8 chars";
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        /// Confirm Password
                        TextFormField(
                          controller: confirmController,
                          focusNode: confirmFocus,
                          obscureText: _obscureConfirm,
                          decoration: _inputDecoration(
                            label: "Confirm Password",
                            icon: Icons.lock_outline_rounded,
                            focusNode: confirmFocus,
                            hint: "Confirm password",
                            suffix: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off_outlined
                                    : Icons.remove_red_eye_outlined,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Confirm password";
                            if (value != passwordController.text)
                              return "Passwords do not match";
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        /// Sign Up Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate())
                                      return;
                                    setState(() => _isLoading = true);
                                    try {
                                      await authController.signUp(
                                        context: context,
                                        name: nameController.text.trim(),
                                        email: emailController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                      );
                                    } finally {
                                      if (mounted)
                                        setState(() => _isLoading = false);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text("Sign Up"),
                          ),
                        ),
                        SizedBox(height: 57),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Color(0xFF565D6D),
                                ),
                              ),
                              Text(
                                "  OR  ",
                                style: TextStyle(color: Color(0xFF565D6D)),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Color(0xFF565D6D),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            AuthController().signInWithGoogle(context);
                          },
                          child: Container(
                            width: 342,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: Color(0xFF171A1F),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  size: 24,
                                  FontAwesomeIcons.google,
                                  color: Color(0xFF171A1F),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Continue with Google",
                                  style: GoogleFonts.lato(
                                    color: Color(0xFF171A1F),
                                    fontSize: 14,

                                    fontWeight: FontWeight.w500,
                                    height: 22 / 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Login Redirect
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(color: Color(0xFF565D6D)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
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
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(
        color: (focusNode?.hasFocus ?? false)
            ? AppColors.primary
            : Colors.grey.shade700,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
      prefixIcon: Icon(
        icon,
        color: (focusNode?.hasFocus ?? false)
            ? AppColors.primary
            : Colors.grey.shade600,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}
