import 'dart:io';
import 'package:auctify/screens/Notification/notification_helper.dart';
import 'package:auctify/services/auction_service.dart';
import 'package:auctify/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAuctionScreen extends StatefulWidget {
  final String auctionId;
  final Map<String, dynamic> data;

  const EditAuctionScreen({
    super.key,
    required this.auctionId,
    required this.data,
  });

  @override
  State<EditAuctionScreen> createState() => _EditAuctionScreenState();
}

class _EditAuctionScreenState extends State<EditAuctionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auctionService = AuctionService();
  final _notificationHelper = NotificationHelper();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;

  DateTime? _selectedEndTime;
  List<String> _existingImages = [];
  List<File> _newImages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data['title']);
    _descriptionController = TextEditingController(
      text: widget.data['description'],
    );
    _locationController = TextEditingController(text: widget.data['location']);

    _existingImages = List<String>.from(widget.data['imageUrls'] ?? []);

    final rawEndTime = widget.data['endTime'];
    if (rawEndTime is Timestamp) {
      _selectedEndTime = rawEndTime.toDate();
    } else if (rawEndTime is String) {
      _selectedEndTime = DateTime.tryParse(rawEndTime);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _newImages.addAll(result.paths.map((path) => File(path!)));
      });
    }
  }

  Future<void> _pickEndTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedEndTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedEndTime ?? DateTime.now()),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _selectedEndTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _updateAuction() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an end time")),
      );
      return;
    }

    if (_selectedEndTime!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("End time must be in the future")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Merge existing and new images
      List<String> finalImageUrls = [..._existingImages];
      if (_newImages.isNotEmpty) {
        final newUrls = await _auctionService.uploadImages(_newImages);
        finalImageUrls.addAll(newUrls);
      }

      // Prepare update data
      Map<String, dynamic> updateData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'endTime': Timestamp.fromDate(_selectedEndTime!),
        'imageUrls': finalImageUrls,
        'status': 'active', // keep auction active
        'winnerId': null, // clear previous winner
        'paymentStatus': null, // reset payment
        'soldAt': null,
        'paidAt': null,
      };

      // Update Firestore
      await _firestore
          .collection('auctions')
          .doc(widget.auctionId)
          .update(updateData);

      // Notify previous bidders
      final bidsSnapshot = await _firestore
          .collection('auctions')
          .doc(widget.auctionId)
          .collection('bids')
          .get();

      final uniqueBidderIds = bidsSnapshot.docs
          .map((doc) => doc.data()['userId'] as String?)
          .where((id) => id != null)
          .toSet();

      // for (final userId in uniqueBidderIds) {
      //   await _notificationHelper.notifyAuctionRestarted(
      //     userId: userId!,
      //     auctionTitle: _titleController.text.trim(),
      //     auctionId: widget.auctionId,
      //     newEndTime: _selectedEndTime!,
      //   );
      // }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Auction updated successfully!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error updating auction: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Future<void> _updateAuction() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   if (_selectedEndTime == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please select an end time")),
  //     );
  //     return;
  //   }
  //   if (_selectedEndTime!.isBefore(DateTime.now())) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("End time must be in the future")),
  //     );
  //     return;
  //   }

  //   setState(() => _isLoading = true);

  //   try {
  //     List<String> finalImageUrls = [..._existingImages];

  //     // Upload new images
  //     if (_newImages.isNotEmpty) {
  //       final newUrls = await _auctionService.uploadImages(_newImages);
  //       finalImageUrls.addAll(newUrls);
  //     }

  //     final bool isRestarting =
  //         widget.data['status'] == 'ended' ||
  //         (widget.data['status'] == 'active' &&
  //             (widget.data['endTime'] as Timestamp)
  //                 .toDate()
  //                 .isBefore(DateTime.now()));

  //     Map<String, dynamic> updateData = {
  //       'title': _titleController.text.trim(),
  //       'description': _descriptionController.text.trim(),
  //       'location': _locationController.text.trim(),
  //       'endTime': Timestamp.fromDate(_selectedEndTime!),
  //       'imageUrls': finalImageUrls,
  //       'status': 'active', // Ensure active status
  //     };

  //     // If restarting, clear winner and payment status
  //     if (isRestarting) {
  //       updateData['winnerId'] = null;
  //       updateData['paymentStatus'] = null;
  //       updateData['soldAt'] = null;
  //       updateData['paidAt'] = null;
  //     }

  //     await _firestore.collection('auctions').doc(widget.auctionId).update(updateData);

  //     // Notify previous bidders if restarting
  //     if (isRestarting) {
  //       final bidsSnapshot = await _firestore
  //           .collection('auctions')
  //           .doc(widget.auctionId)
  //           .collection('bids')
  //           .get();

  //       final uniqueBidderIds = bidsSnapshot.docs
  //           .map((doc) => doc.data()['userId'] as String?)
  //           .where((id) => id != null)
  //           .toSet();

  //       for (final userId in uniqueBidderIds) {
  //         await _notificationHelper.notifyAuctionRestarted(
  //           userId: userId!,
  //           auctionTitle: _titleController.text.trim(),
  //           auctionId: widget.auctionId,
  //           newEndTime: _selectedEndTime!,
  //         );
  //       }
  //     }

  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Auction updated successfully!")),
  //       );
  //       Navigator.pop(context);
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Error updating auction: $e")),
  //       );
  //     }
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Auction",
          style: GoogleFonts.archivo(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Auction Details"),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _titleController,
                      label: "Title",
                      validator: (v) => v!.isEmpty ? "Enter title" : null,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _descriptionController,
                      label: "Description",
                      maxLines: 3,
                      validator: (v) => v!.isEmpty ? "Enter description" : null,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _locationController,
                      label: "Location",
                      validator: (v) => v!.isEmpty ? "Enter location" : null,
                    ),
                    const SizedBox(height: 20),
                    _sectionTitle("End Time"),
                    const SizedBox(height: 10),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _selectedEndTime == null
                            ? "Select End Time"
                            : _selectedEndTime.toString(),
                        style: GoogleFonts.lato(fontSize: 16),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _pickEndTime,
                    ),
                    const SizedBox(height: 20),
                    _sectionTitle("Images"),
                    const SizedBox(height: 10),
                    _buildImageSection(),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _updateAuction,
                        child: const Text(
                          "Update Auction",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.archivo(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: validator,
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        if (_existingImages.isNotEmpty || _newImages.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ..._existingImages.map((url) => _imagePreview(url: url)),
                ..._newImages.map((file) => _imagePreview(file: file)),
              ],
            ),
          ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.add_a_photo),
          label: const Text("Add Images"),
        ),
      ],
    );
  }

  Widget _imagePreview({String? url, File? file}) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: url != null
                  ? NetworkImage(url)
                  : FileImage(file!) as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (url != null) {
                  _existingImages.remove(url);
                } else {
                  _newImages.remove(file);
                }
              });
            },
            child: Container(
              color: Colors.black54,
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
