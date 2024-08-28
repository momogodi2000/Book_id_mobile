import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cni/pages/SplashScreen.dart';
import 'package:cni/provider/ThemeNotifier.dart';  // Import ThemeNotifier for managing themes
import 'Services/auth_services.dart';  // Import Authservices

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