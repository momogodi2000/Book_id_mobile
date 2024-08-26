import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  final Map<String, String> user;

  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${user['username']}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Email: ${user['email']}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Role: ${user['role']}', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
