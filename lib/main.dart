import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // 🔹 IMPORT ADMOB
import 'package:provider/provider.dart'; // 🔹 TAMBAH PROVIDER
import 'firebase_options.dart';
import 'screens/screen.dart';
import 'l10n/app_localizations.dart'; // Pastikan path ini benar
import 'providers/language_provider.dart'; // 🔹 TAMBAH LANGUAGE PROVIDER

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔹 INISIALISASI ADMOB SEBELUM RUNAPP
  await MobileAds.instance.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 DENGARKAN PERUBAHAN BAHASA DARI LANGUAGEPROVIDER
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'CashEase',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          // 🔹 KONFIGURASI PENTING
          locale: languageProvider.currentLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Screen(),
        );
      },
    );
  }
}