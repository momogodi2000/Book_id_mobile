import 'package:flutter/material.dart';
import '../../header/admin_header.dart';

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderPage(), // Using the imported HeaderPage
      drawer: const AdminDashboardDrawer(), // Using the imported AdminDashboardDrawer
      body: Center(
        child: Text(
          'Welcome to the Admin Panel',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: const AdminPanelPage(),
  ));
}
