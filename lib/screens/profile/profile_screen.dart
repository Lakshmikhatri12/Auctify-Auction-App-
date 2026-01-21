import 'dart:io';

import 'package:auctify/Notification/notification_screen.dart';
import 'package:auctify/controllers/user_controller.dart';
import 'package:auctify/models/user_model.dart';
import 'package:auctify/screens/auction/my_auctions.dart';
import 'package:auctify/screens/bid_history/my_bids.dart';
import 'package:auctify/screens/profile/edit_profile.dart';
import 'package:auctify/services/theme_service.dart'; // Import ThemeService
import 'package:auctify/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auctify/utils/constants.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserController _userController = UserController();
  final UserService _userService = UserService();

  Future<void> _uploadImage(UserModel user) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Uploading image...')));
      }

      try {
        String uploadedUrl = await _userService.uploadProfileImage(file);
        await _userController.updateProfile(
          uid: user.uid,
          profileImageUrl: uploadedUrl,
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.scaffoldBg, // Removed to use Theme defaults
      body: StreamBuilder<UserModel?>(
        stream: _userController.streamCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("User not found"));
          }

          final user = snapshot.data!;
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(user),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _statsGrid(user.uid),
                      const SizedBox(height: 30),
                      Text(
                        "Settings",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _settingsGroup(context, user),
                      const SizedBox(height: 30),
                      Text(
                        "Account",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _accountGroup(context),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(UserModel user) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: AppColors.primary),
            // Pattern or gradient overlay could go here
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: user.profileImageUrl.isNotEmpty
                              ? NetworkImage(user.profileImageUrl)
                              : null,
                          child: user.profileImageUrl.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey[400],
                                )
                              : null,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _uploadImage(user),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    user.email,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeService().themeNotifier,
          builder: (context, currentMode, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Select Theme",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.wb_sunny_outlined),
                    title: const Text("Light Mode"),
                    trailing: currentMode == ThemeMode.light
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      ThemeService().setTheme(ThemeMode.light);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.dark_mode_outlined),
                    title: const Text("Dark Mode"),
                    trailing: currentMode == ThemeMode.dark
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      ThemeService().setTheme(ThemeMode.dark);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.settings_system_daydream_outlined,
                    ),
                    title: const Text("System Default"),
                    trailing: currentMode == ThemeMode.system
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      ThemeService().setTheme(ThemeMode.system);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _settingsGroup(BuildContext context, UserModel user) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _menuItem(
            icon: Icons.person_outline,
            title: "Edit Profile",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(user: user),
                ),
              );
            },
          ),
          _divider(),
          _menuItem(
            icon: Icons.dark_mode_outlined,
            title: "App Theme",
            trailing: ValueListenableBuilder<ThemeMode>(
              valueListenable: ThemeService().themeNotifier,
              builder: (context, mode, _) {
                String text = "System";
                if (mode == ThemeMode.light) text = "Light";
                if (mode == ThemeMode.dark) text = "Dark";
                return Text(
                  text,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                );
              },
            ),
            onTap: () => _showThemeSelector(context),
          ),
          _divider(),
          _menuItem(
            icon: Icons.notifications_outlined,
            title: "Notifications",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _accountGroup(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _menuItem(
            icon: Icons.history,
            title: "My Bids",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyBidsScreen()),
              );
            },
          ),
          _divider(),
          _menuItem(
            icon: Icons.gavel_outlined,
            title: "My Auctions",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAuctionsScreen()),
              );
            },
          ),
          _divider(),
          _menuItem(
            icon: Icons.logout,
            title: "Logout",
            isDestructive: true,
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColors.error.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDestructive
              ? AppColors.error
              : Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      trailing:
          trailing ??
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
    );
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.grey[100], indent: 60);
  }

  Widget _statsGrid(String userId) {
    return FutureBuilder<Map<String, int>>(
      future: _getStats(userId),
      builder: (context, snapshot) {
        final stats =
            snapshot.data ?? {"myBids": 0, "auctions": 0, "won": 0, "sell": 0};

        return Row(
          children: [
            Expanded(
              child: _statCard("My Bids", stats["myBids"]!, Colors.blue),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _statCard("Auctions", stats["auctions"]!, Colors.orange),
            ),
            const SizedBox(width: 10),
            Expanded(child: _statCard("Won", stats["won"]!, Colors.green)),
          ],
        );
      },
    );
  }

  Widget _statCard(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, int>> _getStats(String userId) async {
    final firestore = FirebaseFirestore.instance;
    // ... existing stats logic (simplified for brevity if unchanged) ...
    // Re-implementing to ensure it works
    // My Bids
    final myBidsSnap = await firestore
        .collection('users')
        .doc(userId)
        .collection('myBids')
        .get();

    // Auctions
    final auctionsSnap = await firestore
        .collection('auctions')
        .where('sellerId', isEqualTo: userId)
        .get();

    // Won
    final wonSnap = await firestore
        .collection('auctions')
        .where('winnerId', isEqualTo: userId)
        .get();

    // Sell (Sold items)
    final soldSnap = await firestore
        .collection('auctions')
        .where('sellerId', isEqualTo: userId)
        .where('status', isEqualTo: 'sold')
        .get();

    return {
      "myBids": myBidsSnap.docs.length,
      "auctions": auctionsSnap.docs.length,
      "won": wonSnap.docs.length,
      "sell": soldSnap.docs.length,
    };
  }
}
