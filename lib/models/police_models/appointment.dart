import 'User_models.dart';

class Appointment {
  final int id;
  final User? user;  // Nullable, user could be null
  final User? officer; // Nullable, officer could be null
  final String office;
  final String date;
  final String time;
  final bool paid;
  final String status;
  final String cardStatus;
  final List<String> documents;

  Appointment({
    required this.id,
    this.user,
    this.officer,
    required this.office,
    required this.date,
    required this.time,
    required this.paid,
    required this.status,
    required this.cardStatus,
    required this.documents,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      user: json['user'] is Map<String, dynamic> ? User.fromJson(json['user']) : null,
      officer: json['officer'] is Map<String, dynamic> ? User.fromJson(json['officer']) : null,
      office: json['office'].toString(),  // Convert to String
      date: json['date'].toString(),      // Convert to String
      time: json['time'].toString(),      // Convert to String
      paid: json['paid'] == 1,            // Boolean conversion if necessary
      status: json['status'].toString(),
      cardStatus: json['card_status'].toString(),
      documents: List<String>.from(json['documents'] ?? []),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(), // Nullable: include only if not null
      'officer': officer?.toJson(), // Nullable: include only if not null
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
