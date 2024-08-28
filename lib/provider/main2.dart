import 'package:cni/pages/panel/clients/setting/localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cni/pages/panel/clients/setting/color.dart';
import 'package:cni/provider/ThemeNotifier.dart';
import 'package:cni/pages/panel/clients/clients_panel.dart';
import 'package:cni/pages/panel/admin/admin_panel.dart';
import 'package:cni/pages/panel/police/police_panel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(ThemeData.light()),
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
          title: 'Flutter Navigation Demo',
          theme: themeNotifier.theme,
          locale: languageProvider.locale,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('fr', 'FR'),
            Locale('es', 'ES'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate, // Add the AppLocalizations delegate
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: '/admin',
          routes: {
            '/admin': (context) => const AdminPanelPage(),
            '/clients': (context) => const ClientsPanel(),
            '/police': (context) => const PolicePanelPage(),
          },
        );
      },
    );
  }
}

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en', 'US');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Settings'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.brightness_2, color: AppColors.darkThemeColor),
                            title: const Text('Dark Theme'),
                            onTap: () {
                              Provider.of<ThemeNotifier>(context, listen: false).setDarkTheme();
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.brightness_7, color: AppColors.lightThemeColor),
                            title: const Text('Light Theme'),
                            onTap: () {
                              Provider.of<ThemeNotifier>(context, listen: false).setLightTheme();
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.settings_brightness, color: AppColors.defaultThemeColor),
                            title: const Text('Default Theme'),
                            onTap: () {
                              Provider.of<ThemeNotifier>(context, listen: false).setDefaultTheme();
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.language, color: Colors.blue),
                            title: const Text('Change Language'),
                            onTap: () {
                              showLanguageDialog(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
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

  void showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
        return AlertDialog(
          title: const Text('Select Language'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('English'),
                  onTap: () {
                    languageProvider.setLocale(const Locale('en', 'US'));
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Français'),
                  onTap: () {
                    languageProvider.setLocale(const Locale('fr', 'FR'));
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Español'),
                  onTap: () {
                    languageProvider.setLocale(const Locale('es', 'ES'));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
