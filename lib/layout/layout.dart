import 'package:auctify/screens/auction/place_auction.dart';
import 'package:auctify/screens/chat/inbox_screen.dart';
import 'package:auctify/screens/home/home_screen.dart';
import 'package:auctify/screens/profile/profile_screen.dart';
import 'package:auctify/screens/watchlist.dart';
import 'package:auctify/utils/constants.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int currentIndex = 0;
  late PageController _pageController;
  final List<Widget> pages = [
    HomeScreen(),
    WatchList(),
    PlaceAuction(),
    InboxScreen(),
    ProfileScreen(),
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
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_sharp),
              label: "WatchList",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.image_outlined),
              label: "Sell",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: "Inbox"),
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
