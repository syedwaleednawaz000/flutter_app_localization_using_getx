import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_translation/Language/app_translation.dart';
import 'package:test_translation/Language/language_provider.dart';


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
    final controller = Provider.of<LanguageProvider>(context);
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
