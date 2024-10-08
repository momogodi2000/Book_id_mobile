import 'package:cni/Services/auth_services.dart';
import 'package:flutter/material.dart';
import '../../../../models/police_models/appointment.dart';

class AppointmentActionPage extends StatefulWidget {
  final Appointment appointment;
  final String action;

  AppointmentActionPage({required this.appointment, required this.action});

  @override
  _AppointmentActionPageState createState() => _AppointmentActionPageState();
}

class _AppointmentActionPageState extends State<AppointmentActionPage> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.action == "approve" ? "Approve" : "Reject"} Appointment'),
        backgroundColor: Colors.blue,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.action == "approve" ? "Approval Message:" : "Rejection Reason:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Enter your message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await Authservices().takeAction(
                  widget.appointment.id,
                  widget.action,
                  _messageController.text,
                );
                if (success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Appointment ${widget.action}d successfully!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to ${widget.action} appointment'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('${widget.action == "approve" ? "Approve" : "Reject"}'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: widget.action == "approve" ? Colors.green : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}