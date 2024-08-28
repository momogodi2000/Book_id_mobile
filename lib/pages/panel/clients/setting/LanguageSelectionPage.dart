import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cni/provider/language_provider.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('English'),
            onTap: () {
              languageProvider.setLocale(const Locale('en', 'US'));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Français'),
            onTap: () {
              languageProvider.setLocale(const Locale('fr', 'FR'));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Español'),
            onTap: () {
              languageProvider.setLocale(const Locale('es', 'ES'));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
