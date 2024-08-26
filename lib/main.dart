import 'package:cni/pages/panel/clients/clients_panel.dart';
import 'package:cni/pages/panel/admin/admin_panel.dart';
import 'package:cni/pages/panel/police/police_panel.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/admin',
      routes: {
        '/admin': (context) => const AdminPanelPage(),
        '/clients': (context) => const ClientsPanel(),
        '/police': (context) => const PolicePanelPage(),
      },
    );
  }
}



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Panel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/admin');
              },
              child: const Text('Go to Admin Panel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/clients');
              },
              child: const Text('Go to Clients Panel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/police');
              },
              child: const Text('Go to Police Panel'),
            ),
          ],
        ),
      ),
    );
  }
}

