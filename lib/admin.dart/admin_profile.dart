import 'package:auctify/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Admin Profile',
          style: GoogleFonts.archivo(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            CircleAvatar(
              radius: 50,
              backgroundImage: admin?.photoURL != null
                  ? NetworkImage(admin!.photoURL!)
                  : null,
              child: admin?.photoURL == null
                  ? const Icon(Icons.admin_panel_settings, size: 50)
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              admin?.displayName ?? "Admin",
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              admin?.email ?? "admin@example.com",
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 30),

            // Menu options
            _adminMenu(
              icon: Icons.supervised_user_circle,
              title: "User Management",
              onTap: () {
                // Navigate to User Management Screen
              },
            ),
            _adminMenu(
              icon: Icons.gavel,
              title: "Auction Management",
              onTap: () {
                // Navigate to Auction Management Screen
              },
            ),
            _adminMenu(
              icon: Icons.list_alt,
              title: "Bid Management",
              onTap: () {
                // Navigate to Bid Management Screen
              },
            ),
            _adminMenu(
              icon: Icons.bar_chart,
              title: "Reports",
              onTap: () {
                // Navigate to Reports Screen
              },
            ),
            _adminMenu(
              icon: Icons.logout,
              title: "Logout",
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _adminMenu({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueGrey),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
