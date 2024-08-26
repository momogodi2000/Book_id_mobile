import 'package:flutter/material.dart';
import 'detail_bbok.dart';

class ValidationPage extends StatelessWidget {
  final List<Appointment> appointments = [
    Appointment(date: '2024-08-25', name: 'John Doe', paymentStatus: 'Paid', imageUrl: 'assets/images/momo.jpg'),
    Appointment(date: '2024-08-26', name: 'Jane Smith', paymentStatus: 'Pending', imageUrl: 'assets/images/momo.jpg'),
  ];

   ValidationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validate Appointments'),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return AppointmentCard(appointment: appointments[index]);
        },
      ),
    );
  }
}

class Appointment {
  final String date;
  final String name;
  final String paymentStatus;
  final String imageUrl;

  Appointment({required this.date, required this.name, required this.paymentStatus, required this.imageUrl});
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          // Navigate to DetailBookPage with the selected appointment details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailBookPage(appointment: appointment),
            ),
          );
        },
        child: Column(
          children: [
            ListTile(
              leading: Image.asset(appointment.imageUrl, width: 50, height: 50),
              title: Text(appointment.name),
              subtitle: Text('Date: ${appointment.date}\nPayment: ${appointment.paymentStatus}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Accept Appointment Logic
                    sendEmail(appointment.name, 'accepted');
                  },
                  child: const Text('Accept'),
                ),
                TextButton(
                  onPressed: () {
                    // Reject Appointment Logic
                    sendEmail(appointment.name, 'rejected');
                  },
                  child: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void sendEmail(String name, String status) {
    // Placeholder for email sending logic
    print('Email sent to $name: Appointment $status');
  }
}
