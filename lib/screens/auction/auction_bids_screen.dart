import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auctify/controllers/bid_controller.dart';
import 'package:auctify/models/bid_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuctionBidsScreen extends StatelessWidget {
  final String auctionId;

  const AuctionBidsScreen({super.key, required this.auctionId});

  @override
  Widget build(BuildContext context) {
    final BidController bidController = BidController();

    return Scaffold(
      appBar: AppBar(title: const Text("All Bids")),
      body: StreamBuilder<List<BidModel>>(
        stream: bidController.getAuctionBids(auctionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No bids yet"));
          }

          final bids = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bids.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final bid = bids[index];

              return _BidTile(bid: bid);
            },
          );
        },
      ),
    );
  }
}

class _BidTile extends StatelessWidget {
  final BidModel bid;
  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hr ago";
    if (diff.inDays < 7) return "${diff.inDays} days ago";

    return "${date.day}/${date.month}/${date.year}";
  }

  const _BidTile({required this.bid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(bid.userId)
          .get(),
      builder: (context, snapshot) {
        String userName = "User";
        String profileUrl = "";

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          userName = data['name'] ?? "User";
          profileUrl = data['profileImage'] ?? "";
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: profileUrl.isNotEmpty
                    ? NetworkImage(profileUrl)
                    : null,
                child: profileUrl.isEmpty
                    ? const Icon(Icons.person, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  userName,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$${bid.amount.toStringAsFixed(2)}",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    timeAgo(bid.createdAt.toDate()),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
