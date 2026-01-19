import 'package:auctify/admin.dart/adminDeshBoard.dart';
import 'package:auctify/admin.dart/admin_profile.dart';

import 'package:auctify/admin.dart/user_management.dart';
import 'package:auctify/admin.dart/manage_auctions.dart';
import 'package:auctify/utils/constants.dart';
import 'package:flutter/material.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int currentIndex = 0;
  late PageController _pageController;
  final List<Widget> pages = [
    AdminDashboardScreen(),
    ManageUsersScreen(),
    ManageAuctions(),
    AdminProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void onPageChange(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChange,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.primary,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Deshboard",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: "Users"),
            BottomNavigationBarItem(icon: Icon(Icons.gavel), label: "Auctions"),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_3_outlined),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
