class UserModel {
  String uid;
  String name;
  String email;
  String profileImageUrl;
  bool isVerified; // optional, defaults to false
  DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImageUrl = '',
    this.isVerified = false, // optional
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      profileImageUrl: map['profileImageUrl'] ?? '',
      isVerified: map['isVerified'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
