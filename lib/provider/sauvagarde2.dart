import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cni/pages/SplashScreen.dart';
import 'package:cni/provider/ThemeNotifier.dart';  // Import the ThemeNotifier
import 'package:cni/pages/panel/clients/setting/color.dart';  // Import color.dart

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(ThemeData.light()),  // Initialize with the light theme
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
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
          theme: themeNotifier.theme,  // Use the current theme from the notifier
          locale: languageProvider.locale,  // Use the current locale from the provider
          supportedLocales: [
            Locale('en', 'US'),
            Locale('fr', 'FR'),
            Locale('es', 'ES'),
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SplashScreen(),
        );
      },
    );
  }
}

class LanguageProvider with ChangeNotifier {
  Locale _locale = Locale('en', 'US');  // Default locale

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
    }
  }
}
