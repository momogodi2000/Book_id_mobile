import 'package:cni/pages/panel/admin/admin_panel.dart';
import 'package:cni/pages/panel/clients/clients_panel.dart';
import 'package:cni/pages/panel/police/police_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cni/pages/SplashScreen.dart';
import 'package:cni/provider/ThemeNotifier.dart';

import '../Services/auth_services.dart';  // Import ThemeNotifier for managing themes



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(ThemeData.light()),  // Initialize with the light theme
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),  // Initialize language provider
        ),
        ChangeNotifierProvider(
          create: (_) => Authservices(),  // Initialize Authservices
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, LanguageProvider>(
      builder: (context, themeNotifier, languageProvider, child) {
        return MaterialApp(
          title: 'Appointment CNI',
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.theme,  // Apply current theme from ThemeNotifier
          locale: languageProvider.locale,  // Apply current locale from LanguageProvider
          supportedLocales: const [
            Locale('en', 'US'),  // English
            Locale('fr', 'FR'),  // French
            Locale('es', 'ES'),  // Spanish
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SplashScreen(),  // Set SplashScreen as the home page
          routes: {
            '/admin_panel': (context) => AdminPanelPage(),  // Admin Panel route
            '/police_panel': (context) => PolicePanelPage(),  // Police Panel route
            '/clients_panel': (context) => ClientsPanel(),  // Clients Panel route
          },
        );
      },
    );
  }
}

// LanguageProvider class to manage language settings
class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en', 'US');  // Default locale

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();  // Notify listeners when the locale changes
    }
  }
}
