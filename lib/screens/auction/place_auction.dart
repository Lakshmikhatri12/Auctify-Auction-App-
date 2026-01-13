import 'dart:io';
import 'package:auctify/controllers/auction_controller.dart';
import 'package:auctify/models/auction_model.dart';
import 'package:auctify/screens/auction/auction_detail_screen.dart';
import 'package:auctify/utils/constants.dart';
import 'package:auctify/utils/custom_appbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaceAuction extends StatefulWidget {
  const PlaceAuction({super.key});

  @override
  State<PlaceAuction> createState() => _PlaceAuctionState();
}

class _PlaceAuctionState extends State<PlaceAuction>
    with SingleTickerProviderStateMixin {
  final AuctionController _auctionController = AuctionController();
  List<File> selectedImages = [];
  late TabController tabController;

  final _englishFormKey = GlobalKey<FormState>();
  final _fixedFormKey = GlobalKey<FormState>();

  int? auctionDuration;
  String? selectedCategory;
  bool _isLoading = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startingPriceController =
      TextEditingController();
  final TextEditingController _fixedPriceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _startingPriceController.dispose();
    _fixedPriceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Place Auction",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        actions: const [
          Icon(Icons.search, color: AppColors.primary),
          SizedBox(width: 8),
          Icon(Icons.notifications_outlined, color: AppColors.primary),
          SizedBox(width: 12),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: GoogleFonts.archivo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: "English Auction"),
                Tab(text: "Fixed Auction"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [_englishAuction(), _fixedAuction()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- ENGLISH AUCTION ----------------
  Widget _englishAuction() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _englishFormKey,
        child: Column(
          children: [
            _header(),
            _imageSection(),
            _textFields(isEnglish: true),
            _categoryDropdown(),
            _durationDropdown(),
            _locationField(),
            const SizedBox(height: 16),
            _submitButton(isEnglish: true),
          ],
        ),
      ),
    );
  }

  // ---------------- FIXED AUCTION ----------------
  Widget _fixedAuction() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _fixedFormKey,
        child: Column(
          children: [
            _header(),
            _imageSection(),
            _textFields(isEnglish: false),
            _categoryDropdown(),
            _locationField(),
            const SizedBox(height: 16),
            _submitButton(isEnglish: false),
          ],
        ),
      ),
    );
  }

  Widget _header() => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF6C63FF), Color(0xFF9C88FF)],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: const [
        Icon(Icons.gavel_rounded, color: Colors.white, size: 30),
        SizedBox(width: 12),
        Text(
          "Create a New Auction",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  Widget _imageSection() => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upload at least one photo",
            style: GoogleFonts.archivo(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _imageBox(Icons.add),
              const SizedBox(width: 10),
              _imageBox2(Icons.add_a_photo),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _imageBox(IconData icon) => Expanded(
    child: GestureDetector(
      onTap: _pickImages,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.textLight, width: 2),
        ),
        child: selectedImages.isEmpty
            ? Icon(icon, color: AppColors.primary, size: 30)
            : Image.file(selectedImages[0], fit: BoxFit.cover),
      ),
    ),
  );

  Widget _imageBox2(IconData icon) => Expanded(
    child: GestureDetector(
      onTap: _pickImages,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.textLight, width: 2),
        ),
        child: selectedImages.length > 1
            ? Image.file(selectedImages[1], fit: BoxFit.cover)
            : Icon(icon, color: AppColors.primary, size: 30),
      ),
    ),
  );

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedImages.addAll(result.paths.map((path) => File(path!)));
      });
    }
  }

  Widget _textFields({required bool isEnglish}) => Card(
    child: Column(
      children: [
        _inputField(
          controller: _titleController,
          label: "Auction Title",
          icon: Icons.title,
          validator: (v) => v == null || v.isEmpty ? "Title required" : null,
        ),
        _inputField(
          controller: _descriptionController,
          label: "Description",
          icon: Icons.message,
          maxLines: 3,
        ),
        _inputField(
          controller: isEnglish
              ? _startingPriceController
              : _fixedPriceController,
          label: isEnglish ? "Starting Price" : "Fixed Price",
          icon: Icons.monetization_on,
          keyboard: TextInputType.number,
          validator: (v) {
            final value = double.tryParse(v ?? "");
            return value == null || value <= 0 ? "Enter valid price" : null;
          },
        ),
      ],
    ),
  );

  Widget _locationField() => Card(
    child: _inputField(
      controller: _locationController,
      label: "Location",
      icon: Icons.location_city,
    ),
  );

  Widget _categoryDropdown() => Card(
    child: DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.category, color: AppColors.primary),
        labelText: "Category",
        border: InputBorder.none,
      ),
      value: selectedCategory,
      items: categoriesList
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: (v) => setState(() => selectedCategory = v),
      validator: (v) => v == null ? "Select category" : null,
    ),
  );

  Widget _durationDropdown() => Card(
    child: DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.hourglass_bottom, color: AppColors.primary),
        labelText: "Auction Duration (hours)",
        border: InputBorder.none,
      ),
      items: [1, 2, 4, 6, 12, 24, 36, 48]
          .map((h) => DropdownMenuItem(value: h, child: Text("$h hours")))
          .toList(),
      value: auctionDuration,
      onChanged: (v) => setState(() => auctionDuration = v),
    ),
  );

  Widget _submitButton({required bool isEnglish}) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accent,
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    onPressed: _isLoading
        ? null
        : () async {
            final key = isEnglish ? _englishFormKey : _fixedFormKey;
            if (key.currentState!.validate()) {
              if (selectedImages.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please select at least one image"),
                  ),
                );
                return;
              }

              setState(() {
                _isLoading = true; // start loading
              });

              try {
                AuctionModel auction;

                if (isEnglish) {
                  auction = await _auctionController.createEnglishAuction(
                    title: _titleController.text.trim(),
                    description: _descriptionController.text.trim(),
                    startingBid: double.parse(
                      _startingPriceController.text.trim(),
                    ),
                    durationHours: auctionDuration ?? 24,
                    category: selectedCategory ?? 'Others',
                    location: _locationController.text.trim(),
                    images: selectedImages,
                  );
                } else {
                  auction = await _auctionController.createFixedAuction(
                    title: _titleController.text.trim(),
                    description: _descriptionController.text.trim(),
                    fixedPrice: double.parse(_fixedPriceController.text.trim()),
                    quantity: 1,
                    category: selectedCategory ?? 'Others',
                    location: _locationController.text.trim(),
                    images: selectedImages,
                  );
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AuctionDetailScreen(auctionId: auction.auctionId),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Error: $e")));
              } finally {
                setState(() {
                  _isLoading = false; // stop loading
                });
              }
            }
          },
    child: _isLoading
        ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          )
        : Text(
            "Start Auction",
            style: GoogleFonts.archivo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
  );

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboard,
      validator: validator,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.textLight),
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon, color: AppColors.primary),
        labelText: label,
        border: InputBorder.none,
      ),
    );
  }
}
