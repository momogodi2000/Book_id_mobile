import 'package:flutter/material.dart';
import '../../header/clients_header.dart';

class ClientsPanel extends StatelessWidget {
  const ClientsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ClientHeaderPage(), // Using the imported ClientHeaderPage
      drawer: ClientDashboardDrawer(), // Using the imported ClientDashboardDrawer
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
  runApp(const MaterialApp(
    home: ClientsPanel(),
  ));
}
