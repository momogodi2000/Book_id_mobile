import 'package:flutter/material.dart';

class SystemSettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildSection(
      'System Settings',
      Column(
        children: [
          ListTile(
            leading: Icon(Icons.access_time, color: Colors.orange),
            title: Text('Configure Appointment Duration'),
            subtitle: Text('Set the duration for each appointment.'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Appointment Duration Settings Page
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.purple),
            title: Text('Set Working Hours'),
            subtitle: Text('Define working hours for the system.'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Working Hours Settings Page
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.red),
            title: Text('Notification Settings'),
            subtitle: Text('Manage notification preferences.'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Notification Settings Page
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          content,
        ],
      ),
    );
  }
}
