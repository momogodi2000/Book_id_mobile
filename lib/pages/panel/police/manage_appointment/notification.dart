import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<NotificationModel> notifications = [
    NotificationModel(title: 'Appointment Accepted', message: 'Your appointment on 2024-08-25 has been accepted.'),
    NotificationModel(title: 'Appointment Rejected', message: 'Your appointment on 2024-08-26 has been rejected.'),
  ];

   NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationCard(notification: notifications[index]);
        },
      ),
    );
  }
}

class NotificationModel {
  final String title;
  final String message;

  NotificationModel({required this.title, required this.message});
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(notification.title),
        subtitle: Text(notification.message),
      ),
    );
  }
}
