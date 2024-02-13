import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Localization Demo',
      translations: AppTranslations(), // your translations
      locale: Get.locale ?? Locale('en', 'US'), // initial locale
      fallbackLocale: Locale('en', 'US'), // fallback locale
      home: HomePage(),
    );
  }
}

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'greeting': 'Hello',
      'selectLanguage': 'Select Language',
      'english': 'English',
      'spanish': 'Spanish',
    },
    'es_ES': {
      'greeting': 'Hola',
      'selectLanguage': 'Seleccionar Idioma',
      'english': 'Inglés',
      'spanish': 'Español',
    },
    'ur_PK': {
      'greeting': 'ہیلو',
      'selectLanguage': 'زبان منتخب کریں',
      'english': 'انگریزی',
      'spanish': 'سپینش',
    },
    'ar_SA': {
      'greeting': 'مرحبا',
      'selectLanguage': 'اختر اللغة',
      'english': 'الإنجليزية',
      'spanish': 'الإسبانية',
    },
    'ko_KR': {
      'greeting': '안녕하세요',
      'selectLanguage': '언어 선택',
      'english': '영어',
      'spanish': '스페인어',
    },
  };
}

class LanguageController extends GetxController {
  final _selectedLanguage = Rx<Locale?>(null);

  Locale? get selectedLanguage => _selectedLanguage.value;

  @override
  void onInit() {
    super.onInit();
    _loadSelectedLanguage();
  }

  void _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    final countryCode = prefs.getString('country_code') ?? 'US';
    _selectedLanguage.value = Locale(languageCode, countryCode);
    // Update Get locale when app restarts
    if (_selectedLanguage.value != null) {
      Get.updateLocale(_selectedLanguage.value!);
    }
  }

  Future<void> updateLanguage(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', newLocale.languageCode);
    await prefs.setString('country_code', newLocale.countryCode!);
    _selectedLanguage.value = newLocale;
    Get.updateLocale(newLocale);
  }
}



class HomePage extends StatelessWidget {
  final LanguageController _languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localization Demo'.tr),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'greeting'.tr,
              style: TextStyle(fontSize: 20),
            ),Text(
              'selectLanguage'.tr,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            LanguageDropDown(controller: _languageController),
          ],
        ),
      ),
    );
  }
}

class LanguageDropDown extends StatelessWidget {
  final LanguageController controller;

  LanguageDropDown({required this.controller});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: controller.selectedLanguage,
      onChanged: (Locale? locale) {
        if (locale != null) {
          controller.updateLanguage(locale);
        }
      },
      items: [
        DropdownMenuItem(
          value: Locale('en', 'US'),
          child: Text('english'.tr),
        ),
        DropdownMenuItem(
          value: Locale('es', 'ES'),
          child: Text('spanish'.tr),
        ),
        DropdownMenuItem(
          value: Locale('ur', 'PK'),
          child: Text('urdu'.tr),
        ),
        DropdownMenuItem(
          value: Locale('ar', 'SA'),
          child: Text('arabic'.tr),
        ),
        DropdownMenuItem(
          value: Locale('ko', 'KR'),
          child: Text('korean'.tr),
        ),
      ],
    );
  }
}
