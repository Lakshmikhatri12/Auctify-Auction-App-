import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import '../models/auction_model.dart';

class AuctionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Dio _dio = Dio();
  final String collection = 'auctions';

  // Upload single image to Cloudinary
  Future<String> uploadImage(File file) async {
    const cloudName = 'dzatmbj31';
    const uploadPreset = 'auction_bucket';

    final response = await _dio.post(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      data: FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'upload_preset': uploadPreset,
      }),
    );

    return response.data['secure_url'];
  }

  // Upload multiple images
  Future<List<String>> uploadImages(List<File> files) async {
    List<String> urls = [];
    for (final file in files) {
      urls.add(await uploadImage(file));
    }
    return urls;
  }

  // Create auction
  Future<void> createAuction(AuctionModel auction) async {
    await _firestore
        .collection(collection)
        .doc(auction.auctionId)
        .set(auction.toMap());
  }

  // Stream all auctions
  Stream<List<AuctionModel>> streamAllAuctions() {
    return _firestore
        .collection(collection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AuctionModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // Stream auctions by category
  Stream<List<AuctionModel>> streamAuctionsByCategory(String category) {
    return _firestore
        .collection(collection)
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AuctionModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // Stream single auction
  Stream<AuctionModel> streamAuction(String id) {
    return _firestore
        .collection(collection)
        .doc(id)
        .snapshots()
        .map((doc) => AuctionModel.fromFirestore(doc.data()!, doc.id));
  }

  Future<AuctionModel?> getAuctionById(String auctionId) async {
    final doc = await _firestore.collection('auctions').doc(auctionId).get();
    if (!doc.exists) return null;
    return AuctionModel.fromFirestore(doc.data()!, doc.id);
  }
}
