import 'package:flutter/material.dart';
import '../../header/clients_header.dart';

class ClientsPanel extends StatelessWidget {
  const ClientsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ClientHeaderPage(), // Using the imported ClientHeaderPage
      drawer: const ClientDashboardDrawer(), // Using the imported ClientDashboardDrawer
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Welcome to the Clients Panel!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: const ClientsPanel(),
  ));
}
