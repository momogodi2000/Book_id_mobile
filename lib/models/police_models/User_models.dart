import 'dart:io';

class User {
  final String id;
  final String email;
  final String role;
  final String name;
  final String phone;
  final String address;
  final String profilePicture;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.name,
    required this.phone,
    required this.address,
    required this.profilePicture,
  });

  // Getter for profileImage
  File? get profileImage => profilePicture.isNotEmpty ? File(profilePicture) : null;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',  // Default to empty string if null
      email: json['email'] ?? 'No Email',  // Default email if null
      role: json['role'] ?? 'No Role',  // Default role if null
      name: json['name'] ?? 'No Name',  // Default name if null
      phone: json['phone'] ?? 'No Phone',  // Default phone if null
      address: json['address'] ?? 'No Address',  // Keep default address
      profilePicture: json['profile_picture'] ?? '',  // Default profile picture path if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'name': name,
      'phone': phone,
      'address': address,
      'profile_picture': profilePicture,
    };
  }
}
