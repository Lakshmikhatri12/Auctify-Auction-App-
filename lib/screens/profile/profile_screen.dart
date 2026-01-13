import 'dart:io';

import 'package:auctify/controllers/auction_controller.dart';
import 'package:auctify/controllers/bid_controller.dart';
import 'package:auctify/controllers/user_controller.dart';
import 'package:auctify/models/user_model.dart';
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
  final BidController _bidController = BidController();
  final AuctionController _auctionController = AuctionController();

  Future<void> _uploadImage(UserModel user) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      // Upload to Firestore via UserController
      final userController = UserController();

      // Assuming you have a method to upload image in UserService
      String uploadedUrl = await _userService.uploadProfileImage(file);

      // Update user profile
      await userController.updateProfile(
        uid: user.uid,
        profileImageUrl: uploadedUrl,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
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
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  // User Avatar
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: user.profileImageUrl.isNotEmpty
                              ? NetworkImage(user.profileImageUrl)
                              : null,
                          child: user.profileImageUrl.isEmpty
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _uploadImage(user),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                Icons.camera_alt,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // User Name
                  Text(
                    user.name,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // User Email
                  Text(
                    user.email,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stats Grid
                  _statsGrid(),

                  const SizedBox(height: 25),

                  // Menu Items
                  _profileMenu(
                    icon: Icons.hourglass_bottom,
                    title: "My Bids",
                    iconColor: AppColors.primary,
                  ),
                  const SizedBox(height: 4),
                  _profileMenu(
                    icon: Icons.local_offer_outlined,
                    title: "My Auctions",
                    iconColor: AppColors.primary,
                  ),
                  const SizedBox(height: 4),
                  _profileMenu(
                    icon: Icons.celebration,
                    title: "Won Auctions",
                    iconColor: AppColors.primary,
                  ),
                  const SizedBox(height: 4),
                  _profileMenu(
                    icon: Icons.exit_to_app,
                    title: "Logout",
                    iconColor: AppColors.primary,
                    onTap: () {
                      // Add logout logic here
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statsGrid() {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<Map<String, int>>(
      future: _getStats(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats =
            snapshot.data ?? {"myBids": 0, "auctions": 0, "won": 0, "sell": 0};

        final List<String> titles = ["My Bids", "Auctions", "Won", "Sell"];
        final List<int> counts = [
          stats["myBids"]!,
          stats["auctions"]!,
          stats["won"]!,
          stats["sell"]!,
        ];
        final List<Color> colors = [
          AppColors.accent.withOpacity(0.8),
          const Color(0xFF22CCB2).withOpacity(0.8),
          AppColors.success.withOpacity(0.8),
          AppColors.secondary.withOpacity(0.8),
        ];

        return SizedBox(
          height: 140,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: titles.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisExtent: 120,
              crossAxisSpacing: 0,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors[index],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        titles[index],
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        counts[index].toString(),
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// ListTile for menu
  Widget _profileMenu({
    required IconData icon,
    required String title,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(255, 209, 208, 208),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(size: 24, icon, color: iconColor),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF171A1F),
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Fetch stats from Firestore
  Future<Map<String, int>> _getStats(String userId) async {
    final firestore = FirebaseFirestore.instance;

    // My Bids
    final myBidsSnap = await firestore
        .collection('users')
        .doc(userId)
        .collection('myBids')
        .get();
    final myBidsCount = myBidsSnap.docs.length;

    // Auctions created by user
    final auctionsSnap = await firestore
        .collection('auctions')
        .where('sellerId', isEqualTo: userId)
        .get();
    final auctionsCount = auctionsSnap.docs.length;

    // Won auctions
    final wonSnap = await firestore
        .collection('auctions')
        .where('winnerId', isEqualTo: userId)
        .get();
    final wonCount = wonSnap.docs.length;

    // Items sold by user
    final soldSnap = await firestore
        .collection('auctions')
        .where('sellerId', isEqualTo: userId)
        .where('status', isEqualTo: 'sold')
        .get();
    final soldCount = soldSnap.docs.length;

    return {
      "myBids": myBidsCount,
      "auctions": auctionsCount,
      "won": wonCount,
      "sell": soldCount,
    };
  }
}
