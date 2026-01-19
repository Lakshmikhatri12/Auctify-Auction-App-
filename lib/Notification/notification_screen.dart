// import 'package:auctify/utils/constants.dart';
// import 'package:auctify/utils/custom_appbar.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class NotificationScreen extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   NotificationScreen({super.key});

//   Stream<QuerySnapshot> _notificationStream() {
//     final uid = _auth.currentUser?.uid;
//     if (uid == null) {
//       return const Stream.empty();
//     }
//     return _firestore
//         .collection('notifications')
//         .where('userId', isEqualTo: uid)
//         .orderBy('createdAt', descending: true)
//         .snapshots();
//   }

//   String _formatTimestamp(Timestamp timestamp) {
//     final dt = timestamp.toDate();
//     final now = DateTime.now();
//     final diff = now.difference(dt);

//     if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
//     if (diff.inHours < 24) return '${diff.inHours} hr ago';
//     return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
//   }

//   Icon _getIconForType(String type) {
//     switch (type) {
//       case 'bid':
//         return const Icon(Icons.gavel, color: Colors.blue, size: 30);
//       case 'auction_won':
//         return const Icon(Icons.emoji_events, color: Colors.green);
//       case 'auction_sold':
//         return const Icon(Icons.attach_money, color: Colors.orange);
//       case 'payment':
//         return const Icon(Icons.payment, color: Colors.purple);
//       case 'new_auction':
//         return const Icon(Icons.new_releases, color: Colors.teal);
//       case 'outbid':
//         return const Icon(Icons.warning, color: Colors.red);
//       default:
//         return const Icon(Icons.notifications, color: Colors.grey);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: CustomAppBar(
//         title: "Notifications",
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => NotificationScreen()),
//               );
//             },
//             color: AppColors.primary,
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _notificationStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No notifications yet!',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             );
//           }

//           final notifications = snapshot.data!.docs;

//           return ListView.builder(
//             padding: const EdgeInsets.all(8),
//             itemCount: notifications.length,
//             itemBuilder: (context, index) {
//               final doc = notifications[index];
//               final data = doc.data() as Map<String, dynamic>;
//               final title = data['title'] ?? '';
//               final message = data['message'] ?? '';
//               final timestamp = data['createdAt'] as Timestamp;
//               final read = data['read'] as bool? ?? false;
//               final type = data['type'] ?? '';

//               return Dismissible(
//                 key: Key(doc.id), // Each Dismissible needs a unique key
//                 direction:
//                     DismissDirection.endToStart, // swipe from right to left
//                 background: Container(
//                   alignment: Alignment.centerRight,
//                   padding: const EdgeInsets.only(right: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(Icons.delete, color: Colors.white),
//                 ),
//                 confirmDismiss: (direction) async {
//                   // Optional: show a confirmation dialog
//                   return await showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: const Text("Delete Notification?"),
//                       content: const Text(
//                         "Are you sure you want to delete this notification?",
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(false),
//                           child: const Text("Cancel"),
//                         ),
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(true),
//                           child: const Text(
//                             "Delete",
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 onDismissed: (direction) async {
//                   // Delete from Firestore
//                   await doc.reference.delete();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Notification deleted")),
//                   );
//                 },
//                 child: Card(
//                   elevation: 2,
//                   margin: const EdgeInsets.symmetric(vertical: 6),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   color: read ? Colors.white : Colors.deepPurple.shade50,
//                   child: ListTile(
//                     leading: _getIconForType(type),
//                     title: Text(
//                       title,
//                       style: TextStyle(
//                         fontWeight: read ? FontWeight.normal : FontWeight.bold,
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 4),
//                         Text(message, style: const TextStyle(fontSize: 14)),
//                         const SizedBox(height: 6),
//                         Text(
//                           _formatTimestamp(timestamp),
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                     trailing: read
//                         ? null
//                         : const Icon(
//                             Icons.circle,
//                             color: Colors.deepPurple,
//                             size: 12,
//                           ),
//                     onTap: () async {
//                       // Mark as read
//                       await doc.reference.update({'read': true});
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:auctify/utils/constants.dart';
import 'package:auctify/utils/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NotificationScreen({super.key});

  Stream<QuerySnapshot> _notificationStream() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dt = timestamp.toDate();
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
  }

  Icon _getIconForType(String type) {
    switch (type) {
      case 'bid':
        return const Icon(Icons.gavel, color: Colors.blue, size: 30);
      case 'auction_won':
        return const Icon(Icons.emoji_events, color: Colors.green);
      case 'auction_sold':
        return const Icon(Icons.attach_money, color: Colors.orange);
      case 'payment':
        return const Icon(Icons.payment, color: Colors.purple);
      case 'new_auction':
        return const Icon(Icons.new_releases, color: Colors.teal);
      case 'outbid':
        return const Icon(Icons.warning, color: Colors.red);
      default:
        return const Icon(Icons.notifications, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: CustomAppBar(title: "Notifications"),
      body: StreamBuilder<QuerySnapshot>(
        stream: _notificationStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No notifications yet!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final doc = notifications[index];
              final data = doc.data() as Map<String, dynamic>;
              final title = data['title'] ?? '';
              final message = data['message'] ?? '';
              final timestamp = data['createdAt'] as Timestamp;
              final read = data['read'] as bool? ?? false;
              final type = data['type'] ?? '';

              return Dismissible(
                key: Key(doc.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Notification?"),
                      content: const Text(
                        "Are you sure you want to delete this notification?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) async {
                  // DELETE notification (Firestore rules now allow it)
                  try {
                    await doc.reference.delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Notification deleted")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to delete notification"),
                      ),
                    );
                  }
                },
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: read ? Colors.white : Colors.deepPurple.shade50,
                  child: ListTile(
                    leading: _getIconForType(type),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight: read ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(message, style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 6),
                        Text(
                          _formatTimestamp(timestamp),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: read
                        ? null
                        : const Icon(
                            Icons.circle,
                            color: Colors.deepPurple,
                            size: 12,
                          ),
                    onTap: () async {
                      // Mark as read (optional: can be via server or cloud function)
                      await doc.reference.update({'read': true});
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
