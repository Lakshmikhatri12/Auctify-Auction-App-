import 'package:auctify/Notification/notification_screen.dart';
import 'package:auctify/controllers/user_controller.dart';
import 'package:auctify/login/firstScreen.dart';
import 'package:auctify/models/auction_model.dart';
import 'package:auctify/models/user_model.dart';

import 'package:auctify/screens/auction/auction_detail_screen.dart';
import 'package:auctify/screens/auction/my_auctions.dart';
import 'package:auctify/screens/auction/place_auction.dart';
import 'package:auctify/screens/bid_history/my_bids.dart';
import 'package:auctify/screens/home/auction_listing.dart';
import 'package:auctify/screens/order/order_history.dart';
import 'package:auctify/screens/profile/profile_screen.dart';
import 'package:auctify/screens/search/search_items.dart';
import 'package:auctify/utils/auctionCard.dart';

import 'package:auctify/utils/category_listView.dart';
import 'package:auctify/utils/constants.dart';
import 'package:auctify/utils/notification_Icon.dart';
import 'package:auctify/utils/recommended_auctions.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserController _userController = UserController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.scaffoldBg,
        drawer: Drawer(child: _drawer()),
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  // <--- prevents overflow
                  child: StreamBuilder<UserModel?>(
                    stream: _userController.streamCurrentUser(),
                    builder: (context, snapshot) {
                      final name = snapshot.data?.name ?? "User"; // fallback
                      return Text(
                        "Hello! $name",
                        overflow: TextOverflow.ellipsis, // ensures no overflow
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            NotificationIcon(),
            const SizedBox(width: 4),
            StreamBuilder<UserModel?>(
              stream: _userController.streamCurrentUser(),
              builder: (context, snapshot) {
                final user = snapshot.data;
                return CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: user?.profileImageUrl.isNotEmpty == true
                      ? NetworkImage(user!.profileImageUrl)
                      : null,
                  child: (user == null || user.profileImageUrl.isEmpty)
                      ? const Icon(Icons.person, size: 16)
                      : null,
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                /// --- SEARCH BAR ---
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            print("Search tapped!");
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SearchItems(),
                              ),
                            );
                          },
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: const [
                                Icon(Icons.search, color: Colors.grey),
                                SizedBox(width: 8),
                                Text(
                                  "Search auctions",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.primary,
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Optional: filter action
                        },
                        icon: const Icon(Icons.filter_alt, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                Text(
                  "Categories",
                  style: GoogleFonts.archivo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 15),
                CategoryListview(),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Auctions",
                      style: GoogleFonts.archivo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuctionListingScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "ViewAll",
                        style: GoogleFonts.archivo(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                /// --- Horizontal Auctions ---
                SizedBox(
                  height: 284,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('auctions')
                        // .where('status', isEqualTo: 'active') // REMOVE this line
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text("No auctions available"),
                        );
                      }

                      final auctions = snapshot.data!.docs
                          .map(
                            (doc) => AuctionModel.fromFirestore(
                              doc.data() as Map<String, dynamic>,
                              doc.id,
                            ),
                          )
                          .toList();

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: auctions.length,
                        itemBuilder: (context, index) {
                          final auctionModel = auctions[index];

                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: AuctionCard(
                              auctionModel: auctionModel,
                              width: 200,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AuctionDetailScreen(
                                      auctionId: auctionModel.auctionId,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),
                Text(
                  "Recommended",
                  style: GoogleFonts.archivo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(height: 190, child: RecommendedAuctions()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// DRAWER
  Widget _drawer() {
    return ListView(
      children: [
        StreamBuilder<UserModel?>(
          stream: _userController.streamCurrentUser(),
          builder: (context, snapshot) {
            final user = snapshot.data;

            // If user data is not yet available, show a placeholder
            if (user == null) {
              return const DrawerHeader(
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return DrawerHeader(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    user.name,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: GoogleFonts.archivo(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    backgroundImage: user.profileImageUrl.isNotEmpty == true
                        ? NetworkImage(user.profileImageUrl)
                        : null,
                    child: (user.profileImageUrl.isEmpty)
                        ? const Icon(Icons.person, size: 24)
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
        _textButton(text: "Home", onTap: () {}, icon: Icons.home),
        _textButton(text: "Browse", onTap: () {}, icon: Icons.search),
        _textButton(
          text: "MyBids",
          onTap: () {
            Navigator.pop(context);
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => MyBidsScreen()));
          },
          icon: Icons.hourglass_bottom,
        ),
        _textButton(
          text: "Auctions",
          onTap: () {
            Navigator.pop(context);
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => MyAuctionsScreen()));
          },
          icon: Icons.hourglass_bottom,
        ),
        _textButton(
          text: "Orders",
          onTap: () {
            Navigator.pop(context);
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => OrderHistoryScreen()));
          },
          icon: Icons.sell,
        ),
        _textButton(
          text: "Sell Item",
          onTap: () {
            Navigator.pop(context);
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => PlaceAuction()));
          },
          icon: Icons.sell,
        ),
        _textButton(
          text: "Profile",
          onTap: () {
            Navigator.pop(context);
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => ProfileScreen()));
          },
          icon: Icons.person,
        ),
        _textButton(
          text: "LogOut",
          onTap: () {
            Navigator.pop(context);
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => Firstscreen()));
          },
          icon: Icons.logout,
        ),
      ],
    );
  }

  Widget _textButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          TextButton(
            onPressed: onTap,
            child: Text(
              text,
              style: GoogleFonts.archivo(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textSecondary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
