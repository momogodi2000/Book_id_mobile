import 'User_models.dart'; // Make sure this import is correct

class Appointment {
  final int id;
  final User user; // Changed to User object
  final User? officer; // Changed to User object and made nullable
  final String office;
  final String date;
  final String time;
  final bool paid;
  final String status;
  final String cardStatus;
  final List<String> documents;

  Appointment({
    required this.id,
    required this.user, // Changed to User object
    this.officer, // Changed to User object
    required this.office,
    required this.date,
    required this.time,
    required this.paid,
    required this.status,
    required this.cardStatus,
    required this.documents,
  });

  // Factory method to create an Appointment object from JSON
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      user: User.fromJson(json['user']), // Convert user JSON to User object
      officer: json['officer'] != null ? User.fromJson(json['officer']) : null, // Convert officer JSON to User object if exists
      office: json['office'],
      date: json['date'],
      time: json['time'],
      paid: json['paid'],
      status: json['status'],
      cardStatus: json['card_status'],
      documents: List<String>.from(json['documents'] ?? []),
    );
  }

  // Method to convert Appointment object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(), // Convert User object to JSON
      'officer': officer?.toJson(), // Convert User object to JSON if exists
      'office': office,
      'date': date,
      'time': time,
      'paid': paid,
      'status': status,
      'card_status': cardStatus,
      'documents': documents,
    };
  }
}
