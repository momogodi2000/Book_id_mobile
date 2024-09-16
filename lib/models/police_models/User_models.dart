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
      id: json['id'],
      email: json['email'],
      role: json['role'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'] ?? 'No Address',
      profilePicture: json['profile_picture'] ?? '',
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