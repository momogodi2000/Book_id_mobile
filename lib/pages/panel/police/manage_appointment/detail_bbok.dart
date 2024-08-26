import 'package:cni/pages/panel/police/manage_appointment/validation.dart';
import 'package:flutter/material.dart';

class DetailBookPage extends StatelessWidget {
  final Appointment appointment;

  const DetailBookPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(appointment.imageUrl, width: 100, height: 100),
            ),
            const SizedBox(height: 20),
            Text(
              'Name: ${appointment.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Date: ${appointment.date}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Payment Status: ${appointment.paymentStatus}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Accept Appointment Logic
                    sendEmail(appointment.name, 'accepted');
                    Navigator.pop(context);  // Return to previous page after action
                  },
                  child: const Text('Accept'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Reject Appointment Logic
                    sendEmail(appointment.name, 'rejected');
                    Navigator.pop(context);  // Return to previous page after action
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
