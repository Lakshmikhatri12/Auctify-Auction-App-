import 'package:auctify/layout/layout.dart';
import 'package:auctify/login/firstScreen.dart';
import 'package:auctify/login/login_page.dart';
import 'package:auctify/login/signup_page.dart';
import 'package:auctify/screens/auction/auction_won.dart';
import 'package:auctify/screens/auction/my_auctions.dart';
import 'package:auctify/screens/auction/place_auction.dart';
import 'package:auctify/screens/bid_history/bid_history.dart';

import 'package:auctify/screens/home/auction_listing.dart';
import 'package:auctify/screens/home/home_screen.dart';
import 'package:auctify/screens/profile/profile_screen.dart';
import 'package:auctify/screens/watchlist.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // Route names
  static const fScreen = '/f_screen';
  static const login = '/login';
  static const signup = '/signup';
  static const layout = '/layout';
  static const home = '/home';
  static const watchList = '/watchlist';
  static const placeAuction = '/place_auction';
  static const profile = '/profile';
  static const auctionListing = '/auctionListing';
  static const auctionWon = '/auction_won';
  static const myAuctions = '/my_auctions';
  static const auctionDetail = '/auction_detail';
  static const bidHistory = '/bid_history';
  static const myBids = '/my_bids';
  static const category = '/category';

  static final Map<String, WidgetBuilder> routes = {
    fScreen: (_) => const Firstscreen(),
    login: (_) => const LoginPage(),
    signup: (_) => const SignUpPage(),
    layout: (_) => const Layout(),
    home: (_) => HomeScreen(),
    watchList: (_) => WatchList(),
    placeAuction: (_) => const PlaceAuction(),
    profile: (_) => const ProfileScreen(),
    myAuctions: (_) => MyAuctionsScreen(),

    // auctionDetail: (_) => AuctionDetailScreen(),
    bidHistory: (_) => const BidHistory(),
    // myBids: (_) => const MyBids(),
    //category: (_) => CategoryScreen(categoryName: ""),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case auctionWon:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => AuctionWonScreen(
            productName: args['productName'] ?? '',
            productImage: args['productImage'] ?? '',
            finalPrice: args['finalPrice'] ?? 0,
            bidTime: args['bidTime'] ?? '',
          ),
        );
    }
    return null;
  }
}
