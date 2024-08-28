import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  String get title => _title(locale.languageCode);

  String get english => _english(locale.languageCode);

  String get french => _french(locale.languageCode);

  String get spanish => _spanish(locale.languageCode);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

String _title(String languageCode) {
  switch (languageCode) {
    case 'fr':
      return 'Page de Sélection de Langue';
    case 'es':
      return 'Página de Selección de Idioma';
    default:
      return 'Language Selection Page';
  }
}

String _english(String languageCode) {
  switch (languageCode) {
    case 'fr':
      return 'Anglais';
    case 'es':
      return 'Inglés';
    default:
      return 'English';
  }
}

String _french(String languageCode) {
  switch (languageCode) {
    case 'fr':
      return 'Français';
    case 'es':
      return 'Francés';
    default:
      return 'French';
  }
}

String _spanish(String languageCode) {
  switch (languageCode) {
    case 'fr':
      return 'Espagnol';
    case 'es':
      return 'Español';
    default:
      return 'Spanish';
  }
}