import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todoapi/my_app.dart';

void main ()async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      // <-- change the path of the translation files
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}
