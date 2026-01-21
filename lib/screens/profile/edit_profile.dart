import 'package:auctify/controllers/user_controller.dart';
import 'package:auctify/models/user_model.dart';
import 'package:auctify/utils/constants.dart';
import 'package:auctify/utils/custom_appbar.dart';
import 'package:auctify/utils/notification_Icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = UserController();

  late TextEditingController _nameController;
  late TextEditingController _emailController; // Read-only usually
  late TextEditingController _phoneController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    // Assuming phone is a field in UserModel, if not we'll check validity later
    _phoneController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _userController.updateProfile(
        uid: widget.user.uid,
        name: _nameController.text.trim(),
        // Add other fields to updateProfile if supported
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.scaffoldBg, // Removed to use Theme defaults
      appBar: CustomAppBar(
        title: "Edit Profile",

        actions: [NotificationIcon(), SizedBox(width: 5)],
      ),

      body: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Full Name"),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration("Enter your full name"),
                  validator: (value) =>
                      value!.isEmpty ? "Name cannot be empty" : null,
                ),
                const SizedBox(height: 20),

                _buildLabel("Email Address"),
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: _inputDecoration("Email").copyWith(
                    fillColor: Colors.grey[200],
                    suffixIcon: const Icon(
                      Icons.lock_outline,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Email cannot be changed",
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 20),

                // Add Phone Field if your UserModel supports it
                // _buildLabel("Phone Number"),
                // TextFormField(
                //   controller: _phoneController,
                //   decoration: _inputDecoration("Enter phone number"),
                //   keyboardType: TextInputType.phone,
                // ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Save Changes",
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context).inputDecorationTheme.fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}
