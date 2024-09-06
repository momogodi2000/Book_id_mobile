import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = Locale('en'); // Default locale

  Locale get locale => _locale;

  void changeLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }
}



class ChangeLanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Language'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: const Text('English'),
            leading: Radio<String>(
              value: 'en',
              groupValue: languageProvider.locale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  languageProvider.changeLanguage(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('French'),
            leading: Radio<String>(
              value: 'fr',
              groupValue: languageProvider.locale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  languageProvider.changeLanguage(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Spanish'),
            leading: Radio<String>(
              value: 'es',
              groupValue: languageProvider.locale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  languageProvider.changeLanguage(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}