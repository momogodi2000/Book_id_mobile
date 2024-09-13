import 'package:flutter/material.dart';
import '../../../../models/police_models/appointment.dart';
import 'Action_page.dart';


class AppointmentDetailPage extends StatelessWidget {
  final Appointment appointment;

  AppointmentDetailPage({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointment Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User: ${appointment.user.name}', style: TextStyle(fontSize: 18)),
            Text('Date: ${appointment.date}', style: TextStyle(fontSize: 16)),
            Text('Time: ${appointment.time}', style: TextStyle(fontSize: 16)),
            Text('Payment Status: ${appointment.paid ? 'Paid' : 'Not Paid'}', style: TextStyle(fontSize: 16)),
            Text('Documents: ${appointment.documents.join(", ")}', style: TextStyle(fontSize: 16)),
            Text('Status: ${appointment.status}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentActionPage(appointment: appointment, action: 'approve'),
                      ),
                    );
                  },
                  child: Text('Approve'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentActionPage(appointment: appointment, action: 'reject'),
                      ),
                    );
                  },
                  child: Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
