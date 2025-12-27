import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('id'); // Default Bahasa Indonesia

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadLanguage();
  }

  // Ambil bahasa yang tersimpan di HP
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('language_code');
    
    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
      notifyListeners(); // Kabari semua halaman untuk berubah
    }
  }

  // Ganti bahasa baru
  Future<void> changeLanguage(Locale newLocale) async {
    _currentLocale = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', newLocale.languageCode);
    
    notifyListeners(); // Kabari semua halaman untuk berubah
  }
}