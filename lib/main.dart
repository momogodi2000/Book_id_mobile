import 'package:cni/pages/panel/clients/clients_panel.dart';
import 'package:cni/pages/panel/admin/admin_panel.dart';
import 'package:cni/pages/panel/police/police_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/police',
      routes: {
        '/admin': (context) => const AdminPanelPage(),
        '/clients': (context) => const ClientsPanel(),
        '/police': (context) => const PolicePanelPage(),
      },
    );
  }
}



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Panel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/admin');
              },
              child: Text('Go to Admin Panel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/clients');
              },
              child: Text('Go to Clients Panel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/police');
              },
              child: Text('Go to Police Panel'),
            ),
          ],
        ),
      ),
    );
  }
}

