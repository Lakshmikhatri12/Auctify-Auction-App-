import 'package:auctify/controllers/chat_controller.dart';
import 'package:auctify/models/chat_model.dart';
import 'package:auctify/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatController _chatController = ChatController();
  late String currentUserId;
  late String chatId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    chatId = _chatController.getChatRoomId(currentUserId, widget.receiverId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    _chatController.sendMessage(
      senderId: currentUserId,
      receiverId: widget.receiverId,
      message: _messageController.text.trim(),
    );

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60, // slight offset
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatModel>>(
              stream: _chatController.streamMessages(chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                final messages = snapshot.data!;

                // Auto scroll to bottom on new message
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == currentUserId;
                    final showDate =
                        index == 0 ||
                        _shouldShowDate(
                          messages[index - 1].timestamp,
                          msg.timestamp,
                        );

                    return Column(
                      children: [
                        if (showDate) _buildDateSeparator(msg.timestamp),
                        _buildMessageBubble(msg, isMe),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).cardTheme.color,
      shadowColor: Colors.black.withOpacity(0.05),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Text(
              widget.receiverName[0].toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.receiverName,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontSize: 16,
                ),
              ),
              Text(
                "Online", // This would be dynamic in a real app
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: AppColors.success, // Keep specific status color
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.waving_hand_rounded,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Say Hello!",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Start the conversation with ${widget.receiverName}",
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(context).textTheme.titleSmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    String label;

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      label = "Today";
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      label = "Yesterday";
    } else {
      label = DateFormat('MMMM d, y').format(date);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.titleSmall?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowDate(Timestamp prev, Timestamp current) {
    final p = prev.toDate();
    final c = current.toDate();
    return p.day != c.day || p.month != c.month || p.year != c.year;
  }

  Widget _buildMessageBubble(ChatModel msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.only(
            topLeft: isMe
                ? const Radius.circular(20)
                : const Radius.circular(4), // Pointy corner for received
            topRight: isMe
                ? const Radius.circular(4) // Pointy corner for sent
                : const Radius.circular(20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              msg.message,
              style: GoogleFonts.inter(
                color: isMe
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('h:mm a').format(msg.timestamp.toDate()),
              style: GoogleFonts.inter(
                color: isMe
                    ? Colors.white.withOpacity(0.7)
                    : Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.transparent),
                ),
                child: TextField(
                  controller: _messageController,
                  style: GoogleFonts.inter(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: GoogleFonts.inter(
                      color: Theme.of(context).hintColor,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
