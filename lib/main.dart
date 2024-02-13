import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_translation/Language/app_trans_delegat.dart';
import 'package:test_translation/Language/language_provider.dart';
import 'package:test_translation/home_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (_, controller, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Localization Demo',
          locale: controller.selectedLanguage,
          supportedLocales: controller.supportedLanguages,
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

