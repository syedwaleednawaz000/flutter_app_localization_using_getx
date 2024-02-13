import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageController>(
      builder: (_, controller, __) {
        return MaterialApp(
          title: 'Localization Demo',
          locale: controller.selectedLanguage,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('es', 'ES'),
            Locale('ur', 'PK'),
            Locale('ar', 'SA'),
            Locale('ko', 'KR'),
          ],
          localizationsDelegates: [
            AppTranslationsDelegate(controller.selectedLanguage),
            ...GlobalMaterialLocalizations.delegates,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: HomePage(),
        );
      },
    );
  }
}

class AppTranslationsDelegate extends LocalizationsDelegate<AppTranslations> {
  final Locale overriddenLocale;

  const AppTranslationsDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'ur', 'ar', 'ko'].contains(locale.languageCode);
  }

  @override
  Future<AppTranslations> load(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    final countryCode = prefs.getString('country_code') ?? 'US';
    final savedLocale = Locale(languageCode, countryCode);
    return AppTranslations(savedLocale);
  }

  @override
  bool shouldReload(AppTranslationsDelegate old) {
    return overriddenLocale != old.overriddenLocale;
  }
}

class AppTranslations {
  final Locale locale;

  AppTranslations(this.locale);

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations)!;
  }

  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'greeting': 'Hello',
      'selectLanguage': 'Select Language',
    },
    'es': {
      'greeting': 'Hola',
      'selectLanguage': 'Seleccionar Idioma',
    },
    'ur': {
      'greeting': 'ہیلو',
      'selectLanguage': 'زبان منتخب کریں',
    },
    'ar': {
      'greeting': 'مرحبا',
      'selectLanguage': 'اختر اللغة',
    },
    'ko': {
      'greeting': '안녕하세요',
      'selectLanguage': '언어 선택',
    },
  };

  String get greeting => _translations[locale.languageCode]?['greeting'] ?? '';
  String get selectLanguage =>
      _translations[locale.languageCode]?['selectLanguage'] ?? '';
}

class LanguageController extends ChangeNotifier {
  Locale _selectedLanguage = Locale('en', 'US');

  LanguageController() {
    _loadSelectedLanguage();
  }

  Locale get selectedLanguage => _selectedLanguage;

  void _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    final countryCode = prefs.getString('country_code') ?? 'US';
    _selectedLanguage = Locale(languageCode, countryCode);
    notifyListeners();
  }

  Future<void> updateLanguage(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', newLocale.languageCode);
    await prefs.setString('country_code', newLocale.countryCode!);
    _selectedLanguage = newLocale;
    notifyListeners();
  }
}


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.of(context).greeting),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppTranslations.of(context).selectLanguage,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            LanguageDropDown(),
          ],
        ),
      ),
    );
  }
}

class LanguageDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LanguageController>(context);
    final selectedLanguage = controller.selectedLanguage;
    return DropdownButton<Locale>(
      value: selectedLanguage,
      onChanged: (Locale? locale) {
        if (locale != null) {
          controller.updateLanguage(locale);
        }
      },
      items: [
        DropdownMenuItem(
          value: Locale('en', 'US'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: Locale('es', 'ES'),
          child: Text('Spanish'),
        ),
        DropdownMenuItem(
          value: Locale('ur', 'PK'),
          child: Text('Urdu'),
        ),
        DropdownMenuItem(
          value: Locale('ar', 'SA'),
          child: Text('Arabic'),
        ),
        DropdownMenuItem(
          value: Locale('ko', 'KR'),
          child: Text('Korean'),
        ),
      ],
    );
  }
}
