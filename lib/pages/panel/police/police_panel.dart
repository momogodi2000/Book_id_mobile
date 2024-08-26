import 'package:flutter/material.dart';
import '../../header/police_header.dart';



class PolicePanelPage extends StatelessWidget {
  const PolicePanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PoliceHeaderPage(), // Using the imported PoliceHeaderPage
      drawer: const PoliceDashboardDrawer(), // Using the imported PoliceDashboardDrawer
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to the Police Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'This is the main area where you can manage all police-related tasks. '
                    'Use the drawer to navigate through different sections such as managing appointments, '
                    'user information, notifications, and more.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: const PolicePanelPage(),
  ));
}
