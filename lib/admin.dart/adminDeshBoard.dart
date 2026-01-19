// import 'package:auctify/admin.dart/manage_auctions.dart';
// import 'package:auctify/admin.dart/user_management.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AdminDashboardScreen extends StatelessWidget {
//   const AdminDashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: AppBar(
//         title: Text(
//           'Admin Dashboard',
//           style: GoogleFonts.inter(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           children: [
//             _buildDashboardCard(
//               context,
//               title: 'Users',
//               icon: Icons.people,
//               color: Colors.orange,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ManageUsersScreen()),
//                 );
//               },
//             ),
//             _buildDashboardCard(
//               context,
//               title: 'Auctions',
//               icon: Icons.gavel,
//               color: Colors.green,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const ManageAuctions()),
//                 );
//               },
//             ),

//             _buildDashboardCard(
//               context,
//               title: 'Bids',
//               icon: Icons.attach_money,
//               color: Colors.purple,
//               onTap: () {
//                 // TODO: Navigate to Bid Management Screen
//               },
//             ),
//             _buildDashboardCard(
//               context,
//               title: 'Reports',
//               icon: Icons.bar_chart,
//               color: Colors.red,
//               onTap: () {
//                 // TODO: Navigate to Reports Screen
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDashboardCard(
//     BuildContext context, {
//     required String title,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             gradient: LinearGradient(
//               colors: [color.withOpacity(0.7), color],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 48, color: Colors.white),
//               const SizedBox(height: 16),
//               Text(
//                 title,
//                 style: GoogleFonts.inter(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:auctify/admin.dart/manage_auctions.dart';
import 'package:auctify/admin.dart/user_management.dart';
import 'package:auctify/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: GoogleFonts.archivo(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Stats Grid
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('auctions')
                    .snapshots(),
                builder: (context, auctionSnapshot) {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, userSnapshot) {
                      int totalUsers = userSnapshot.hasData
                          ? userSnapshot.data!.docs.length
                          : 0;
                      int totalAuctions = auctionSnapshot.hasData
                          ? auctionSnapshot.data!.docs.length
                          : 0;
                      int activeAuctions = auctionSnapshot.hasData
                          ? auctionSnapshot.data!.docs
                                .where((doc) => doc['status'] == 'active')
                                .length
                          : 0;
                      int completedAuctions = auctionSnapshot.hasData
                          ? auctionSnapshot.data!.docs
                                .where(
                                  (doc) =>
                                      doc['status'] == 'ended' ||
                                      doc['status'] == 'sold',
                                )
                                .length
                          : 0;

                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: [
                          _statCard("Total Users", totalUsers, Colors.blue),
                          _statCard(
                            "Total Auctions",
                            totalAuctions,
                            Colors.green,
                          ),
                          _statCard(
                            "Active Auctions",
                            activeAuctions,
                            Colors.orange,
                          ),
                          _statCard(
                            "Completed Auctions",
                            completedAuctions,
                            Colors.red,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            // Column(
            //   children: [
            //     _adminButton(
            //       title: "User Management",
            //       icon: Icons.supervised_user_circle,
            //       color: Colors.blueGrey,
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => ManageUsersScreen(),
            //           ),
            //         );
            //       },
            //     ),
            //     _adminButton(
            //       title: "Auction Management",
            //       icon: Icons.gavel,
            //       color: Colors.green,
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => ManageAuctions()),
            //         );
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, int count, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 16, color: color)),
        ],
      ),
    );
  }

  Widget _adminButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        onPressed: onTap,
      ),
    );
  }
}
