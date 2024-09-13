class MissingIDCard {
  final String name;
  final String email;
  final String phone;
  final String dateFound;
  final String idCardImage;

  MissingIDCard({
    required this.name,
    required this.email,
    required this.phone,
    required this.dateFound,
    required this.idCardImage,
  });

  factory MissingIDCard.fromJson(Map<String, dynamic> json) {
    return MissingIDCard(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      dateFound: json['date_found'] ?? '',
      idCardImage: json['id_card_image'] ?? '',
    );
  }
}
