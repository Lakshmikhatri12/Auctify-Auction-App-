// import 'package:auctify/screens/Notification/notification_screen.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:badges/badges.dart' as badges;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class NotificationIcon extends StatelessWidget {
//   final double iconSize;
//   final Color iconColor;

//   const NotificationIcon({
//     Key? key,
//     this.iconSize = 24,
//     this.iconColor = AppColors.primary,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final uid = FirebaseAuth.instance.currentUser?.uid;

//     if (uid == null) return const SizedBox(); // hide if no user logged in

//     // Stream only unread notifications
//     final unreadStream = FirebaseFirestore.instance
//         .collection('notifications')
//         .where('userId', isEqualTo: uid)
//         .where('read', isEqualTo: false)
//         .snapshots();

//     return StreamBuilder<QuerySnapshot>(
//       stream: unreadStream,
//       builder: (context, snapshot) {
//         int unreadCount = snapshot.hasData ? snapshot.data!.docs.length : 0;

//         return IconButton(
//           icon: badges.Badge(
//             badgeContent: Text(
//               unreadCount > 99 ? '99+' : unreadCount.toString(),
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 8,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             showBadge: unreadCount > 0,
//             position: badges.BadgePosition.topEnd(top: -6, end: -6),
//             child: Icon(
//               Icons.notifications_none,
//               size: iconSize,
//               color: iconColor,
//             ),
//           ),
//           onPressed: () async {
//             // Navigate to notifications
//             await Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => NotificationScreen()),
//             );
//           },
//         );
//       },
//     );
//   }
// }


import 'package:auctify/screens/Notification/notification_screen.dart';
import 'package:auctify/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationIcon extends StatelessWidget {
  final double iconSize;
  final Color iconColor;

  const NotificationIcon({
    super.key,
    this.iconSize = 24,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const SizedBox.shrink();

    final unreadStream = FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: uid)
        .where('read', isEqualTo: false)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: unreadStream,
      builder: (context, snapshot) {
        final unreadCount = snapshot.data?.docs.length ?? 0;

        return IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificationScreen()),
            );
          },
          icon: badges.Badge(
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.red,
            ),
            position: badges.BadgePosition.topEnd(top: -6, end: -6),
            showBadge: unreadCount > 0,
            badgeContent: Text(
              unreadCount > 99 ? '99+' : unreadCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Icon(
              Icons.notifications_none,
              size: iconSize,
              color: iconColor,
            ),
          ),
        );
      },
    );
  }
}
