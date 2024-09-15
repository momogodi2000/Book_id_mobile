class User {
  final String id; // Add an ID field
  final String email;
  final String role;
  final String name;
  final String phone;
  final String address;
  final String profilePicture;

  User({
    required this.id, // Require ID in the constructor
    required this.email,
    required this.role,
    required this.name,
    required this.phone,
    required this.address,
    required this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // Assuming your API returns an ID
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