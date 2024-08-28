import 'package:flutter/material.dart';

class UserRolesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildSection(
      'User Roles and Permissions',
      Column(
        children: [
          ListTile(
            leading: Icon(Icons.person_outline, color: Colors.blue),
            title: Text('Manage User Roles'),
            subtitle: Text('Assign roles like admin, staff, super admin.'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to User Roles Management Page
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: Colors.green),
            title: Text('Assign Permissions'),
            subtitle: Text('Set permissions for each role.'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Permissions Management Page
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
