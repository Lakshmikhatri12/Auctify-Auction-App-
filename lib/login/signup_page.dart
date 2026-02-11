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

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    [
      nameFocus,
      emailFocus,
      phoneFocus,
      passwordFocus,
      confirmFocus,
    ].forEach((n) => n.addListener(() => setState(() {})));
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmController.dispose();

    nameFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    passwordFocus.dispose();
    confirmFocus.dispose();
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
                    AppColors.primary.withOpacity(0.6),
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
                    "Create Account",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Join SellSpot today",
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
                        _field(
                          controller: nameController,
                          focus: nameFocus,
                          label: "Full Name",
                          hint: "John Doe",
                          icon: Icons.person_outline,
                          validator: (v) =>
                              v == null || v.isEmpty ? "Enter name" : null,
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller: emailController,
                          focus: emailFocus,
                          label: "Email",
                          hint: "example@email.com",
                          icon: Icons.email_outlined,
                          keyboard: TextInputType.emailAddress,
                          validator: (v) => v == null || !v.contains('@')
                              ? "Enter valid email"
                              : null,
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller: phoneController,
                          focus: phoneFocus,
                          label: "Phone",
                          hint: "0300XXXXXXX",
                          icon: Icons.phone_outlined,
                          keyboard: TextInputType.phone,
                          validator: (v) => v == null || v.length < 10
                              ? "Enter valid phone"
                              : null,
                        ),

                        const SizedBox(height: 18),

                        _passwordField(
                          controller: passwordController,
                          focus: passwordFocus,
                          label: "Password",
                          obscure: _obscurePassword,
                          toggle: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _passwordField(
                          controller: confirmController,
                          focus: confirmFocus,
                          label: "Confirm Password",
                          obscure: _obscureConfirm,
                          toggle: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                          validator: (v) => v != passwordController.text
                              ? "Passwords do not match"
                              : null,
                        ),

                        const SizedBox(height: 24),

                        /// SIGN UP BUTTON
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
                                    await authController.signUp(
                                      context: context,
                                      name: nameController.text.trim(),
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
                                    "Create Account",
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

                        /// GOOGLE
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

                        /// LOGIN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
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

  Widget _field({
    required TextEditingController controller,
    required FocusNode focus,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focus,
      keyboardType: keyboard,
      validator: validator,
      decoration: _inputDecoration(
        label: label,
        hint: hint,
        icon: icon,
        focusNode: focus,
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required FocusNode focus,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focus,
      obscureText: obscure,
      validator:
          validator ??
          (v) => v == null || v.length < 8 ? "Minimum 8 characters" : null,
      decoration: _inputDecoration(
        label: label,
        hint: "••••••••",
        icon: Icons.lock_outline,
        focusNode: focus,
        suffix: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.primary,
          ),
          onPressed: toggle,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    FocusNode? focusNode,
    Widget? suffix,
  }) {
    final focused = focusNode?.hasFocus ?? false;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.darkTextSecondary),
      prefixIcon: Icon(icon, color: focused ? AppColors.primary : Colors.grey),
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
