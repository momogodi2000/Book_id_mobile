import 'package:flutter/material.dart';

class IntegrationManagementSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildSection(
      'Integration Management',
      Column(
        children: [
          ListTile(
            leading: Icon(Icons.link, color: Colors.teal),
            title: Text('API Integration'),
            subtitle: Text('Manage external API integrations.'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to API Integration Page
            },
          ),
          ListTile(
            leading: Icon(Icons.code, color: Colors.red),
            title: Text('GitHub Integration'),
            subtitle: Text('Link GitHub repositories and manage issues.'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to GitHub Integration Page
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
