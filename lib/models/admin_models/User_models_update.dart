class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String profilePicture;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.profilePicture,
  });

  // Factory constructor to create a User from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(), // Converting id to String
      name: json['name'] ?? 'No name', // Fallback to default value if null
      email: json['email'] ?? 'No email', // Fallback to default value if null
      role: json['role'] ?? 'No role', // Fallback to default value if null
      profilePicture: json['profile_picture'] ?? '', // Fallback to an empty string if null
    );
  }
}
