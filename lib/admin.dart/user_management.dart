import 'package:auctify/models/user_model.dart';
import 'package:auctify/services/user_service.dart';
import 'package:auctify/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageUsersScreen extends StatelessWidget {
  ManageUsersScreen({super.key});

  final UserService _userService = UserService();

  Future<void> _deleteUser(BuildContext context, String uid) async {
    await _userService.updateUserFields(uid, {'deleted': true});
    // or: FirebaseFirestore.instance.collection('users').doc(uid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Manage Users',
          style: GoogleFonts.archivo(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: _userService.streamAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final users = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: user.profileImageUrl.isNotEmpty
                        ? NetworkImage(user.profileImageUrl)
                        : null,
                    child: user.profileImageUrl.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.email),
                      const SizedBox(height: 6),
                      Chip(
                        label: Text(
                          user.role.toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: user.role == 'admin'
                            ? Colors.red.shade100
                            : Colors.orange.shade100,
                      ),
                    ],
                  ),
                  trailing: user.role == 'admin'
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: Text('Delete ${user.name}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              _deleteUser(context, user.uid);
                            }
                          },
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
