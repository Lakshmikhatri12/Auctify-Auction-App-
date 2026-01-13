// import 'package:auctify/Notification/notification_screen.dart';
// import 'package:auctify/utils/custom_appbar.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:auctify/screens/auction/auction_detail_screen.dart';
// import 'package:auctify/utils/constants.dart';

// class SearchItems extends StatefulWidget {
//   const SearchItems({super.key});

//   @override
//   State<SearchItems> createState() => _SearchItemsState();
// }

// class _SearchItemsState extends State<SearchItems> {
//   final TextEditingController _searchController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   String _searchQuery = '';
//   String _selectedCategory = '';
//   List<String> _recentSearches = [];

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Stream<QuerySnapshot> _searchStream() {
//     if (_searchQuery.isEmpty && _selectedCategory.isEmpty)
//       return const Stream.empty();

//     Query collectionQuery = _firestore
//         .collection('auctions')
//         .where('status', isEqualTo: 'active');

//     if (_searchQuery.isNotEmpty) {
//       collectionQuery = collectionQuery
//           .orderBy('title') // 🔹 needs composite index with 'status'
//           .startAt([_searchQuery])
//           .endAt(['$_searchQuery\uf8ff']);
//     }

//     if (_selectedCategory.isNotEmpty) {
//       collectionQuery = collectionQuery.where(
//         'category',
//         isEqualTo: _selectedCategory,
//       );
//     }

//     return collectionQuery.snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: CustomAppBar(
//         title: "Search",
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => NotificationScreen()),
//               );
//             },
//             icon: Icon(Icons.notifications_none, color: AppColors.primary),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Column(
//           children: [
//             _buildSearchBar(),
//             const SizedBox(height: 12),
//             _buildCategoryChips(),
//             const SizedBox(height: 12),
//             Expanded(
//               child: _searchQuery.isEmpty && _selectedCategory.isEmpty
//                   ? SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildRecentSearches(),
//                           const SizedBox(height: 12),
//                           _buildPopularAuctions(),
//                         ],
//                       ),
//                     )
//                   : StreamBuilder<QuerySnapshot>(
//                       stream: _searchStream(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }

//                         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                           return const Center(
//                             child: Text(
//                               'No results found.',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           );
//                         }

//                         final auctions = snapshot.data!.docs;

//                         return ListView.builder(
//                           padding: const EdgeInsets.all(8),
//                           itemCount: auctions.length,
//                           itemBuilder: (context, index) {
//                             final data =
//                                 auctions[index].data() as Map<String, dynamic>;
//                             return _buildAuctionCard(data);
//                           },
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryChips() {
//     return SizedBox(
//       height: 40,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: categoriesList.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 8),
//         itemBuilder: (context, index) {
//           final cat = categoriesList[index];
//           final isSelected = cat == _selectedCategory;
//           return ChoiceChip(
//             label: Text(cat),
//             selected: isSelected,
//             onSelected: (selected) {
//               setState(() {
//                 _selectedCategory = selected ? cat : '';
//               });
//             },
//             selectedColor: AppColors.primary,
//             backgroundColor: Colors.grey.shade200,
//             labelStyle: TextStyle(
//               color: isSelected ? Colors.white : AppColors.textPrimary,
//               fontWeight: FontWeight.w600,
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildAuctionCard(Map<String, dynamic> data) {
//     final title = data['title'] ?? '';
//     final description = data['description'] ?? '';
//     final currentBid = data['currentBid'] ?? 0.0;
//     final imageUrl = (data['imageUrls'] as List?)?.first ?? '';

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => AuctionDetailScreen(auctionId: data['auctionId']),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade300,
//               blurRadius: 8,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(12),
//                   bottomLeft: Radius.circular(12),
//                 ),
//                 child: imageUrl.isNotEmpty
//                     ? Image.network(
//                         imageUrl,
//                         width: 100,
//                         height: 100,
//                         fit: BoxFit.cover,
//                       )
//                     : Container(
//                         width: 100,
//                         height: 100,
//                         color: Colors.grey.shade200,
//                         child: const Icon(Icons.image, size: 40),
//                       ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: GoogleFonts.archivo(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       description,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.archivo(
//                         color: Colors.grey.shade600,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "\$${currentBid.toStringAsFixed(2)}",
//                       style: TextStyle(
//                         color: AppColors.primary,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRecentSearches() {
//     if (_recentSearches.isEmpty) return const SizedBox.shrink();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Recent Searches",
//           style: GoogleFonts.archivo(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         const SizedBox(height: 6),
//         Wrap(
//           spacing: 8,
//           runSpacing: 4,
//           children: _recentSearches.map((term) {
//             return ActionChip(
//               label: Text(term),
//               onPressed: () {
//                 _searchController.text = term;
//                 setState(() {
//                   _searchQuery = term;
//                 });
//               },
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildPopularAuctions() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore
//           .collection('auctions')
//           .where('status', isEqualTo: 'active')
//           .orderBy('currentBid', descending: true)
//           .limit(5)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const SizedBox.shrink();
//         }
//         final auctions = snapshot.data!.docs;
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Popular Auctions",
//               style: GoogleFonts.archivo(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 8),
//             ...auctions.map((doc) {
//               return _buildAuctionCard(doc.data() as Map<String, dynamic>);
//             }).toList(),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: _searchController,
//         decoration: InputDecoration(
//           hintText: 'Search auctions...',
//           prefixIcon: const Icon(Icons.search),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(vertical: 14),
//         ),
//         onChanged: (value) {
//           setState(() {
//             _searchQuery = value.trim();
//             if (value.trim().isNotEmpty &&
//                 !_recentSearches.contains(value.trim())) {
//               _recentSearches.insert(0, value.trim());
//               if (_recentSearches.length > 5) _recentSearches.removeLast();
//             }
//           });
//         },
//       ),
//     );
//   }
// }

import 'package:auctify/Notification/notification_screen.dart';
import 'package:auctify/utils/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auctify/screens/auction/auction_detail_screen.dart';
import 'package:auctify/utils/constants.dart';

class SearchItems extends StatefulWidget {
  const SearchItems({super.key});

  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _searchQuery = '';
  String _selectedCategory = '';
  List<String> _recentSearches = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Firestore query for search
  Stream<QuerySnapshot> _searchStream() {
    Query collectionQuery = _firestore
        .collection('auctions')
        .where('status', isEqualTo: 'active'); // always active

    // Category filter
    if (_selectedCategory.isNotEmpty) {
      collectionQuery = collectionQuery.where(
        'category',
        isEqualTo: _selectedCategory,
      );
    }

    // Search by title
    if (_searchQuery.isNotEmpty) {
      // Firestore requires a composite index for this
      collectionQuery = collectionQuery
          .orderBy('title')
          .startAt([_searchQuery])
          .endAt(['$_searchQuery\uf8ff']);
    } else {
      collectionQuery = collectionQuery.orderBy('currentBid', descending: true);
    }

    return collectionQuery.snapshots();
  }

  // Popular auctions
  Stream<QuerySnapshot> _popularAuctionsStream() {
    return _firestore
        .collection('auctions')
        .where('status', isEqualTo: 'active')
        .orderBy('currentBid', descending: true)
        .limit(5)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: CustomAppBar(
        title: "Search",
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationScreen()),
              );
            },
            icon: Icon(Icons.notifications_none, color: AppColors.primary),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 12),
            _buildCategoryChips(),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _searchStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final auctions = snapshot.data?.docs ?? [];

                  if (_searchQuery.isEmpty &&
                      _selectedCategory.isEmpty &&
                      auctions.isEmpty) {
                    // Show recent + popular if nothing searched yet
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRecentSearches(),
                          const SizedBox(height: 12),
                          _buildPopularAuctions(),
                        ],
                      ),
                    );
                  }

                  if (auctions.isEmpty) {
                    return const Center(
                      child: Text(
                        'No results found.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: auctions.length,
                    itemBuilder: (context, index) {
                      final data =
                          auctions[index].data() as Map<String, dynamic>;
                      return _buildAuctionCard(data);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Category chips
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categoriesList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categoriesList[index];
          final isSelected = cat == _selectedCategory;
          return ChoiceChip(
            label: Text(cat),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedCategory = selected ? cat : '';
              });
            },
            selectedColor: AppColors.primary,
            backgroundColor: Colors.grey.shade200,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          );
        },
      ),
    );
  }

  // Auction card
  Widget _buildAuctionCard(Map<String, dynamic> data) {
    final title = data['title'] ?? '';
    final description = data['description'] ?? '';
    final currentBid = data['currentBid'] ?? 0.0;
    final imageUrl = (data['imageUrls'] as List?)?.first ?? '';
    final status = data['status'] ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AuctionDetailScreen(auctionId: data['auctionId']),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 110,
                      height: 110,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, size: 40),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.archivo(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.archivo(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "\$${currentBid.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: status == 'active'
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: status == 'active'
                              ? AppColors.primary
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Recent searches
  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Searches",
          style: GoogleFonts.archivo(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _recentSearches.map((term) {
            return ActionChip(
              label: Text(term),
              onPressed: () {
                _searchController.text = term;
                setState(() {
                  _searchQuery = term;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // Popular auctions
  Widget _buildPopularAuctions() {
    return StreamBuilder<QuerySnapshot>(
      stream: _popularAuctionsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }
        final auctions = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Popular Auctions",
              style: GoogleFonts.archivo(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ...auctions.map((doc) {
              return _buildAuctionCard(doc.data() as Map<String, dynamic>);
            }).toList(),
          ],
        );
      },
    );
  }

  // Search bar
  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search auctions...',
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.trim();
            if (value.trim().isNotEmpty &&
                !_recentSearches.contains(value.trim())) {
              _recentSearches.insert(0, value.trim());
              if (_recentSearches.length > 5) _recentSearches.removeLast();
            }
          });
        },
      ),
    );
  }
}
