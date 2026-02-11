import 'package:auctify/controllers/chat_controller.dart';
import 'package:auctify/screens/chat/chat_screen.dart';
import 'package:auctify/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final ChatController _chatController = ChatController();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Surface color
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildChatList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          "Messages",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatController.streamUserChats(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        final chats = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chatData = chats[index].data() as Map<String, dynamic>;
            final participants = List<String>.from(chatData['participants']);
            final otherUserId = participants.firstWhere(
              (id) => id != currentUserId,
              orElse: () => '',
            );

            if (otherUserId.isEmpty) return const SizedBox.shrink();

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(otherUserId)
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return const SizedBox.shrink();

                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>?;
                if (userData == null) return const SizedBox.shrink();

                return _buildChatCard(chatData, userData, otherUserId);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildChatCard(
    Map<String, dynamic> chatData,
    Map<String, dynamic> userData,
    String otherUserId,
  ) {
    final lastMessage = chatData['lastMessage'] ?? '';
    final lastTime = chatData['lastMessageTime'] as Timestamp?;
    final otherUserName = userData['name'] ?? 'Unknown User';
    final otherUserProfile = userData['profileImageUrl'] ?? '';

    final chatRoomId = _chatController.getChatRoomId(
      currentUserId,
      otherUserId,
    );

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .where('receiverId', isEqualTo: currentUserId)
          .where('read', isEqualTo: false)
          .snapshots(),
      builder: (context, unreadSnapshot) {
        final unreadCount = unreadSnapshot.hasData
            ? unreadSnapshot.data!.docs.length
            : 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                // Mark messages as read when opened
                await _chatController.markMessagesRead(
                  chatRoomId: chatRoomId,
                  userId: currentUserId,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      receiverId: otherUserId,
                      receiverName: otherUserName,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          backgroundImage: otherUserProfile.isNotEmpty
                              ? NetworkImage(otherUserProfile)
                              : null,
                          child: otherUserProfile.isEmpty
                              ? Text(
                                  otherUserName[0].toUpperCase(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                  ),
                                )
                              : null,
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                otherUserName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.color,
                                ),
                              ),
                              if (lastTime != null)
                                Text(
                                  _formatTime(lastTime),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.titleSmall?.color,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: Theme.of(
                                context,
                              ).textTheme.titleSmall?.color,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    //   Map<String, dynamic> chatData,
    //   Map<String, dynamic> userData,
    //   String otherUserId,
    // ) {
    //   final lastMessage = chatData['lastMessage'] ?? '';
    //   final lastTime = chatData['lastMessageTime'] as Timestamp?;
    //   final otherUserName = userData['name'] ?? 'Unknown User';
    //   final otherUserProfile = userData['profileImageUrl'] ?? '';

    //   return Container(
    //     margin: const EdgeInsets.only(bottom: 16),
    //     decoration: BoxDecoration(
    //       color: Theme.of(context).cardTheme.color,
    //       borderRadius: BorderRadius.circular(16),
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.black.withOpacity(0.02),
    //           blurRadius: 8,
    //           offset: const Offset(0, 2),
    //         ),
    //       ],
    //     ),
    //     child: Material(
    //       color: Colors.transparent,
    //       child: InkWell(
    //         onTap: () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (_) => ChatScreen(
    //                 receiverId: otherUserId,
    //                 receiverName: otherUserName,
    //               ),
    //             ),
    //           );
    //         },
    //         borderRadius: BorderRadius.circular(16),
    //         child: Padding(
    //           padding: const EdgeInsets.all(16),
    //           child: Row(
    //             children: [
    //               Stack(
    //                 children: [
    //                   CircleAvatar(
    //                     radius: 28,
    //                     backgroundColor: Theme.of(
    //                       context,
    //                     ).primaryColor.withOpacity(0.1),
    //                     backgroundImage: otherUserProfile.isNotEmpty
    //                         ? NetworkImage(otherUserProfile)
    //                         : null,
    //                     child: otherUserProfile.isEmpty
    //                         ? Text(
    //                             otherUserName[0].toUpperCase(),
    //                             style: GoogleFonts.plusJakartaSans(
    //                               fontWeight: FontWeight.bold,
    //                               color: Theme.of(context).primaryColor,
    //                               fontSize: 20,
    //                             ),
    //                           )
    //                         : null,
    //                   ),
    //                   // Online status indicator (mocked for now)
    //                   Positioned(
    //                     right: 0,
    //                     bottom: 0,
    //                     child: Container(
    //                       width: 14,
    //                       height: 14,
    //                       decoration: BoxDecoration(
    //                         color: AppColors.success,
    //                         shape: BoxShape.circle,
    //                         border: Border.all(color: Colors.white, width: 2),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               const SizedBox(width: 16),
    //               Expanded(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Text(
    //                           otherUserName,
    //                           style: GoogleFonts.plusJakartaSans(
    //                             fontWeight: FontWeight.w600,
    //                             fontSize: 16,
    //                             color: Theme.of(
    //                               context,
    //                             ).textTheme.titleMedium?.color,
    //                           ),
    //                         ),
    //                         if (lastTime != null)
    //                           Text(
    //                             _formatTime(lastTime),
    //                             style: GoogleFonts.inter(
    //                               fontSize: 12,
    //                               color: Theme.of(
    //                                 context,
    //                               ).textTheme.titleSmall?.color,
    //                               fontWeight: FontWeight.w500,
    //                             ),
    //                           ),
    //                       ],
    //                     ),
    //                     const SizedBox(height: 6),
    //                     Text(
    //                       lastMessage,
    //                       maxLines: 1,
    //                       overflow: TextOverflow.ellipsis,
    //                       style: GoogleFonts.inter(
    //                         color: Theme.of(context).textTheme.titleSmall?.color,

    //                         fontSize: 14,
    //                         height: 1.4,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No messages yet",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Start a conversation with a seller\nfrom the auction details page.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Theme.of(context).textTheme.titleSmall?.color,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return DateFormat('h:mm a').format(date);
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
}
