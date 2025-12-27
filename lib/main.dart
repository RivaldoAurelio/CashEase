import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 
import 'package:google_mobile_ads/google_mobile_ads.dart'; // 🔹 IMPORT ADMOB
import 'firebase_options.dart';
import 'screens/screen.dart';
import 'l10n/app_localizations.dart'; // Pastikan path ini benar

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔹 INISIALISASI ADMOB SEBELUM RUNAPP
  await MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // 🔹 FUNGSI INI YANG DIPANGGIL DARI SETTINGS UNTUK GANTI BAHASA
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('id'); // Default Indonesia

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale; // Ini memicu rebuild seluruh aplikasi
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 🔹 KONFIGURASI PENTING
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Screen(),
    );
  }
}