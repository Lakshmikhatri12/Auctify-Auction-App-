// import 'package:auctify/screens/auction/auction_detail_screen.dart';
// import 'package:auctify/utils/constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class MyAuctionsScreen extends StatefulWidget {
//   const MyAuctionsScreen({super.key});

//   @override
//   State<MyAuctionsScreen> createState() => _MyAuctionsScreenState();
// }

// class _MyAuctionsScreenState extends State<MyAuctionsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   // 🔒 Stable Firestore stream
//   Stream<QuerySnapshot> _myAuctionsStream(String status) {
//     final user = _auth.currentUser;
//     if (user == null) return const Stream.empty();

//     return _firestore
//         .collection('auctions')
//         .where('sellerId', isEqualTo: user.uid)
//         .where('status', isEqualTo: status)
//         .snapshots();
//   }

//   DateTime _parseEndTime(dynamic raw) {
//     if (raw is Timestamp) return raw.toDate();
//     if (raw is String) return DateTime.tryParse(raw) ?? DateTime.now();
//     return DateTime.now();
//   }

//   String _timeLeft(DateTime endTime) {
//     final diff = endTime.difference(DateTime.now());
//     if (diff.isNegative) return "Ended";
//     if (diff.inDays > 0) return "${diff.inDays}d left";
//     if (diff.inHours > 0) return "${diff.inHours}h left";
//     if (diff.inMinutes > 0) return "${diff.inMinutes}m left";
//     return "Ending soon";
//   }

//   // ===========================
//   // AUCTION CARD (PRO UI)
//   // ===========================
//   Widget _auctionCard(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     final endTime = _parseEndTime(data['endTime']);
//     final images = List<String>.from(data['imageUrls'] ?? []);
//     final isEnglish = data['type'] == 'english';

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.06),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // IMAGE
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             child: images.isNotEmpty
//                 ? Stack(
//                     children: [
//                       Image.network(
//                         images.first,
//                         height: 160,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                       Positioned(
//                         top: 10,
//                         right: 20,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(18),
//                             color: isEnglish
//                                 ? const Color(0xFF22CCB2)
//                                 : AppColors.primary,
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 5,
//                             ),
//                             child: Text(
//                               isEnglish ? "ENGLISH" : "FIXED",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 : Container(
//                     height: 160,
//                     color: Colors.grey.shade200,
//                     child: const Icon(Icons.image, size: 60),
//                   ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // TITLE
//                 Text(
//                   data['title'] ?? '',
//                   style: GoogleFonts.archivo(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),

//                 const SizedBox(height: 8),

//                 // PRICE + TIME
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       isEnglish
//                           ? "Highest Bid  \$${data['currentBid'] ?? 0}"
//                           : "Price  \$${data['startingBid'] ?? 0}",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                     _pill(_timeLeft(endTime), Colors.orange),
//                   ],
//                 ),

//                 const SizedBox(height: 12),

//                 // STATUS + ACTION
//                 Row(
//                   children: [
//                     _statusBadge(data['status']),
//                     const Spacer(),
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: Colors.blue.withOpacity(0.1),
//                           child: IconButton(
//                             onPressed: () {},
//                             icon: Icon(Icons.edit, color: Colors.blue),
//                           ),
//                         ),
//                         SizedBox(width: 5),
//                         _actionButton(doc, data),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _pill(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: color.withOpacity(.12),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//           color: color,
//         ),
//       ),
//     );
//   }

//   Widget _statusBadge(String status) {
//     switch (status) {
//       case 'active':
//         return _pill("ACTIVE", Colors.green);
//       case 'sold':
//         return _pill("SOLD", Colors.blue);
//       default:
//         return _pill("ENDED", Colors.grey);
//     }
//   }

//   Widget _actionButton(DocumentSnapshot doc, Map<String, dynamic> data) {
//     if (data['status'] == 'active') {
//       return CircleAvatar(
//         backgroundColor: AppColors.error.withOpacity(0.1),
//         child: IconButton(
//           icon: const Icon(Icons.delete_outline, color: Colors.red),
//           onPressed: () =>
//               _firestore.collection('auctions').doc(doc.id).delete(),
//         ),
//       );
//     }

//     return TextButton(
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => AuctionDetailScreen(auctionId: doc.id),
//           ),
//         );
//       },
//       child: const Text("View"),
//     );
//   }

//   Widget _tabBody(String status) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _myAuctionsStream(status),
//       builder: (_, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final docs = snapshot.data!.docs;
//         if (docs.isEmpty) {
//           return const Center(child: Text("No auctions found"));
//         }

//         docs.sort((a, b) {
//           return _parseEndTime(
//             (b.data() as Map)['endTime'],
//           ).compareTo(_parseEndTime((a.data() as Map)['endTime']));
//         });

//         return ListView(
//           padding: const EdgeInsets.all(16),
//           children: docs.map(_auctionCard).toList(),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: AppBar(
//         title: const Text("My Auctions"),
//         backgroundColor: AppColors.primary,
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: "Active"),
//             Tab(text: "Sold"),
//             Tab(text: "Ended"),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [_tabBody('active'), _tabBody('sold'), _tabBody('ended')],
//       ),
//     );
//   }
// }

import 'package:auctify/screens/auction/auction_detail.dart';
import 'package:auctify/screens/auction/edit_auction_screen.dart';
import 'package:auctify/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAuctionsScreen extends StatefulWidget {
  const MyAuctionsScreen({super.key});

  @override
  State<MyAuctionsScreen> createState() => _MyAuctionsScreenState();
}

class _MyAuctionsScreenState extends State<MyAuctionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  // Firestore stream per status
  Stream<QuerySnapshot> _myAuctionsStream(String status) {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('auctions')
        .where('sellerId', isEqualTo: user.uid)
        .where('status', isEqualTo: status)
        .snapshots();
  }

  DateTime _parseEndTime(dynamic raw) {
    if (raw is Timestamp) return raw.toDate();
    if (raw is String) return DateTime.tryParse(raw) ?? DateTime.now();
    return DateTime.now();
  }

  // =======================
  // AUCTION CARD
  // =======================
  Widget _auctionCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final images = List<String>.from(data['imageUrls'] ?? []);
    final isEnglish = data['type'] == 'english'; // bids exist
    final isFixed = data['type'] == 'fixed'; // fixed price

    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('auctions').doc(doc.id).snapshots(),
      builder: (context, snapshot) {
        final currentData =
            snapshot.data?.data() as Map<String, dynamic>? ?? data;
        final endTime = _parseEndTime(currentData['endTime']);
        final bidderCount = (currentData['bidderIds'] as List?)?.length ?? 0;

        // Countdown text only for English auctions
        String? timeLeft;
        if (!isFixed) {
          final diff = endTime.difference(DateTime.now());
          if (diff.isNegative) {
            timeLeft = "Ended";
          } else if (diff.inDays > 0) {
            timeLeft = "${diff.inDays}d ${diff.inHours % 24}h left";
          } else if (diff.inHours > 0) {
            timeLeft = "${diff.inHours}h ${diff.inMinutes % 60}m left";
          } else if (diff.inMinutes > 0) {
            timeLeft = "${diff.inMinutes}m ${diff.inSeconds % 60}s left";
          } else {
            timeLeft = "${diff.inSeconds}s left";
          }
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE + Type Badge
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: images.isNotEmpty
                    ? Image.network(
                        images.first,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 160,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, size: 60),
                      ),
              ),

              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentData['title'] ?? '',
                          style: GoogleFonts.archivo(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        _pill(
                          isEnglish ? "ENGLISH" : "FIXED",
                          isEnglish
                              ? const Color(0xFF22CCB2)
                              : AppColors.primary,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // PRICE + TIME + BIDDERS (conditionally)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEnglish
                              ? "Highest Bid: \$${currentData['currentBid'] ?? 0}"
                              : "Price: \$${currentData['startingBid'] ?? 0}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        if (!isFixed)
                          Row(
                            children: [
                              if (timeLeft != null)
                                _pill(timeLeft, Colors.orange),
                              const SizedBox(width: 6),
                              _pill("Bidders: $bidderCount", Colors.purple),
                            ],
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // STATUS + ACTION
                    Row(
                      children: [
                        _statusBadge(currentData['status']),
                        const Spacer(),
                        Row(
                          children: [
                            if (currentData['status'] == 'active')
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue.withOpacity(0.1),
                                  child: IconButton(
                                    onPressed: () =>
                                        _handleEditAuction(doc.id, currentData),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            _deleteOrViewButton(doc, currentData),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    switch (status) {
      case 'active':
        return _pill("ACTIVE", Colors.green);
      case 'sold':
        return _pill("SOLD", Colors.blue);
      default:
        return _pill("ENDED", Colors.grey);
    }
  }

  Widget _deleteOrViewButton(DocumentSnapshot doc, Map<String, dynamic> data) {
    if (data['status'] == 'active') {
      return CircleAvatar(
        backgroundColor: AppColors.error.withOpacity(0.1),
        child: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _showDeleteDialog(doc.id),
        ),
      );
    }

    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AuctionDetailScreen(auctionId: doc.id),
          ),
        );
      },
      child: const Text("View"),
    );
  }

  void _handleEditAuction(String docId, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditAuctionScreen(auctionId: docId, data: data),
      ),
    );
  }

  Future<void> _showDeleteDialog(String auctionId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Auction"),
        content: const Text("Are you sure you want to delete this auction?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _firestore.collection('auctions').doc(auctionId).delete();
    }
  }

  Widget _tabBody(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: _myAuctionsStream(status),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text("No auctions found"));
        }

        docs.sort((a, b) {
          return _parseEndTime(
            (b.data() as Map)['endTime'],
          ).compareTo(_parseEndTime((a.data() as Map)['endTime']));
        });

        return ListView(
          padding: const EdgeInsets.all(16),
          children: docs.map(_auctionCard).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.scaffoldBg, // Removed to use Theme defaults
      appBar: AppBar(
        title: Text(
          "My Auctions",
          style: GoogleFonts.archivo(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: AppColors.primary,
          labelStyle: GoogleFonts.archivo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          labelColor: AppColors.primary,
          unselectedLabelColor: Theme.of(
            context,
          ).textTheme.bodyMedium?.color?.withOpacity(0.6),
          tabs: const [
            Tab(text: "Active"),
            Tab(text: "Sold"),
            Tab(text: "Ended"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: TabBarView(
          controller: _tabController,
          children: [_tabBody('active'), _tabBody('sold'), _tabBody('ended')],
        ),
      ),
    );
  }
}
