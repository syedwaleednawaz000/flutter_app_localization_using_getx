import 'package:flutter/material.dart';
import 'package:test_translation/Language/AllLanguageTranslation/arabic.dart';
import 'package:test_translation/Language/AllLanguageTranslation/korean.dart';

import 'AllLanguageTranslation/english.dart';
import 'AllLanguageTranslation/spanish.dart';
import 'AllLanguageTranslation/urdu.dart';

class AppTranslations {
  final Locale locale;

  AppTranslations(this.locale);

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations)!;
  }

  static  final Map<String, Map<String, String>> _translations = {
    'en': English.english,
    'es': Spanish.spanish,
    'ur': Urdu.urdu,
    'ar': Arabic.arabic,
    'ko': Korean.korean,
  };

  String get greeting => _translations[locale.languageCode]?['greeting'] ?? '';
  String get selectLanguage => _translations[locale.languageCode]?['selectLanguage'] ?? '';
}