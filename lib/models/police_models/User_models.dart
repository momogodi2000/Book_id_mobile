class User {
  final String email;
  final String role;
  final String name;
  final String phone;
  final String address;
  final String profilePicture;

  User({
    required this.email,
    required this.role,
    required this.name,
    required this.phone,
    required this.address,
    required this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      role: json['role'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'] ?? 'No Address',
      profilePicture: json['profile_picture'] ?? '',
    );
  }

  toJson() {}
}
