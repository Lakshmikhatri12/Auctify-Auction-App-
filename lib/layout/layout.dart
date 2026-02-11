// import 'package:auctify/screens/auction/place_auction.dart';
// import 'package:auctify/screens/chat/inbox_screen.dart';
// import 'package:auctify/screens/home/home_screen.dart';
// import 'package:auctify/screens/profile/profile_screen.dart';
// import 'package:auctify/screens/watchlist.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Layout extends StatefulWidget {
//   const Layout({super.key});

//   @override
//   State<Layout> createState() => _LayoutState();
// }

// class _LayoutState extends State<Layout> {
//   int currentIndex = 0;
//   late PageController _pageController;
//   final List<Widget> pages = [
//     HomeScreen(),
//     WatchList(),
//     PlaceAuction(),
//     InboxScreen(),
//     ProfileScreen(),
//   ];

//   int unreadCount = 0;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _pageController = PageController();
//   // }

//   // @override
//   // void dispose() {
//   //   _pageController.dispose();
//   //   super.dispose();
//   // }

//   // @override
//   // void onPageChange(int index) {
//   //   setState(() {
//   //     currentIndex = index;
//   //   });
//   // }

//   // @override
//   // void _onItemTapped(int index) {
//   //   setState(() {
//   //     currentIndex = index;
//   //     _pageController.jumpToPage(index);
//   //   });
//   // }

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _listenUnreadMessages();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       currentIndex = index;
//       _pageController.jumpToPage(index);
//     });
//   }

//   void onPageChange(int index) {
//     setState(() {
//       currentIndex = index;
//     });
//   }

//   /// Listen to unread messages and update badge count
//   void _listenUnreadMessages() {
//     final currentUserId = FirebaseAuth.instance.currentUser!.uid;

//     FirebaseFirestore.instance
//         .collection('chats')
//         .where('participants', arrayContains: currentUserId)
//         .snapshots()
//         .listen((chatSnapshot) async {
//           int totalUnread = 0;

//           for (var chatDoc in chatSnapshot.docs) {
//             final chatId = chatDoc.id;
//             final messagesSnapshot = await FirebaseFirestore.instance
//                 .collection('chats')
//                 .doc(chatId)
//                 .collection('messages')
//                 .where('receiverId', isEqualTo: currentUserId)
//                 .where('read', isEqualTo: false)
//                 .get();

//             totalUnread += messagesSnapshot.docs.length;
//           }

//           setState(() {
//             unreadCount = totalUnread;
//           });
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: PageView(
//           controller: _pageController,
//           onPageChanged: onPageChange,
//           children: pages,
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           currentIndex: currentIndex,
//           selectedItemColor: AppColors.accent,
//           unselectedItemColor: AppColors.primary,
//           onTap: _onItemTapped,
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home_outlined),
//               label: "Home",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.favorite_border_sharp),
//               label: "WatchList",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.image_outlined),
//               label: "Sell",
//             ),
//             BottomNavigationBarItem(
//               icon: Stack(
//                 children: [
//                   const Icon(Icons.message),
//                   if (unreadCount > 0)
//                     Positioned(
//                       right: 0,
//                       top: 0,
//                       child: Container(
//                         padding: const EdgeInsets.all(2),
//                         decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         constraints: const BoxConstraints(
//                           minWidth: 16,
//                           minHeight: 16,
//                         ),
//                         child: Text(
//                           unreadCount > 99 ? '99+' : '$unreadCount',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               label: "Inbox",
//             ),
//             // BottomNavigationBarItem(icon: Icon(Icons.message), label: "Inbox"),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person_3_outlined),
//               label: "Profile",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:auctify/controllers/chat_controller.dart';
import 'package:auctify/screens/auction/place_auction.dart';
import 'package:auctify/screens/chat/inbox_screen.dart';
import 'package:auctify/screens/home/home_screen.dart';
import 'package:auctify/screens/profile/profile_screen.dart';
import 'package:auctify/screens/watchlist.dart';
import 'package:auctify/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int currentIndex = 0;
  late PageController _pageController;
  final ChatController _chatController = ChatController();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

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

  void onPageChange(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  /// Stream unread messages count
  Stream<int> _unreadMessagesCount() {
    return _chatController.streamUserChats(currentUserId).asyncMap((
      snapshot,
    ) async {
      int totalUnread = 0;

      for (var chatDoc in snapshot.docs) {
        final chatId = chatDoc.id;

        // Count unread messages in this chat
        final unreadSnapshot = await FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .where('receiverId', isEqualTo: currentUserId)
            .where('read', isEqualTo: false)
            .get();

        totalUnread += unreadSnapshot.docs.length;
      }

      return totalUnread;
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
        bottomNavigationBar: StreamBuilder<int>(
          stream: _unreadMessagesCount(),
          initialData: 0,
          builder: (context, snapshot) {
            final unreadCount = snapshot.data ?? 0;

            return BottomNavigationBar(
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
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      Icon(Icons.message),
                      if (unreadCount > 0)
                        Positioned(
                          right: 0,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                unreadCount > 99
                                    ? '99+'
                                    : unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: "Inbox",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_3_outlined),
                  label: "Profile",
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
