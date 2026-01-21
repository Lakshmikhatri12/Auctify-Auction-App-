import 'package:auctify/Notification/notification_screen.dart';
import 'package:auctify/models/auction_model.dart';
import 'package:auctify/screens/auction/auction_detail.dart';
import 'package:auctify/utils/auctionCard.dart';
import 'package:auctify/utils/constants.dart';
import 'package:auctify/utils/custom_appbar.dart';
import 'package:auctify/utils/notification_Icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // Focus node to manage keyboard
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Firestore query for search
  Stream<List<AuctionModel>> _searchStream() {
    Query collectionQuery = _firestore
        .collection('auctions')
        .where('status', isEqualTo: 'active');

    // Category filter
    if (_selectedCategory.isNotEmpty) {
      collectionQuery = collectionQuery.where(
        'category',
        isEqualTo: _selectedCategory,
      );
    }

    // Search by title
    if (_searchQuery.isNotEmpty) {
      // Note: Firestore requires a composite index for equality (category) + range (title)
      // If index is missing, this might throw an error in debug mode with a link to create it.
      collectionQuery = collectionQuery
          .orderBy('title')
          .startAt([_searchQuery])
          .endAt(['$_searchQuery\uf8ff']);
    } else {
      collectionQuery = collectionQuery.orderBy('currentBid', descending: true);
    }

    return collectionQuery.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AuctionModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // Popular auctions stream
  Stream<List<AuctionModel>> _popularAuctionsStream() {
    return _firestore
        .collection('auctions')
        .where('status', isEqualTo: 'active')
        .orderBy('currentBid', descending: true)
        .limit(4)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return AuctionModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Search",
        actions: [NotificationIcon(), SizedBox(width: 5)],
        // showBackArrow: false, // It's a tab usually, or allow back if pushed
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSearchBar(),
            ),
            const SizedBox(height: 16),

            // CATEGORY CHIPS
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: _buildCategoryChips(),
            ),
            const SizedBox(height: 20),

            // CONTENT BODY
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    // 1. Show Search Results if query or category is active
    if (_searchQuery.isNotEmpty || _selectedCategory.isNotEmpty) {
      return StreamBuilder<List<AuctionModel>>(
        stream: _searchStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final auctions = snapshot.data ?? [];

          if (auctions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "No results found",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Try adjusting your filters",
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.58, // Adjusted height for card content
            ),
            itemCount: auctions.length,
            itemBuilder: (context, index) {
              final auction = auctions[index];
              return AuctionCard(
                auctionModel: auction,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AuctionDetailScreen(auctionId: auction.auctionId),
                    ),
                  );
                },
              );
            },
          );
        },
      );
    }

    // 2. Default State: Recent + Popular
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecentSearches(),
          const SizedBox(height: 24),
          _buildPopularSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Searches",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (_recentSearches.isNotEmpty)
              TextButton(
                onPressed: () {
                  setState(() {
                    _recentSearches.clear();
                  });
                },
                child: Text(
                  "Clear",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.error,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _recentSearches.map((term) {
            return InkWell(
              onTap: () {
                _searchController.text = term;
                _focusNode.unfocus();
                setState(() {
                  _searchQuery = term;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.history, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      term,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Popular Auctions",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<AuctionModel>>(
          stream: _popularAuctionsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final auctions = snapshot.data ?? [];
            if (auctions.isEmpty) return const SizedBox.shrink();

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.58,
              ),
              itemCount: auctions.length,
              itemBuilder: (context, index) {
                final auction = auctions[index];
                return AuctionCard(
                  auctionModel: auction,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AuctionDetailScreen(auctionId: auction.auctionId),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: "Search items, collections...",
          hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.trim();
          });
        },
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            setState(() {
              if (!_recentSearches.contains(value.trim())) {
                _recentSearches.insert(0, value.trim());
                if (_recentSearches.length > 5) _recentSearches.removeLast();
              }
            });
          }
        },
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none, // Allow shadow to show
        itemCount: categoriesList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categoriesList[index];
          final isSelected = cat == _selectedCategory;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = isSelected ? '' : cat;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                cat,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
