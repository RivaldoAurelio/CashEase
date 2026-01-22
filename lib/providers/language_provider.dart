import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('id'); // Default Bahasa Indonesia

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadLanguage();
  }

  // Ambil bahasa yang tersimpan dari SharedPreferences
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('language_code');
    
    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
      notifyListeners(); // Kabari semua listener untuk update UI
    }
  }

  // Ganti ke bahasa baru dan simpan ke SharedPreferences
  Future<void> changeLanguage(String languageCode) async {
    _currentLocale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    
    notifyListeners(); // Kabari semua listener untuk update UI secara otomatis
  }

  // Dapatkan nama bahasa untuk ditampilkan
  String getLanguageName(String code) {
    switch (code) {
      case 'id':
        return 'Bahasa Indonesia';
      case 'en':
        return 'English';
      case 'ja':
        return '日本語 (Japanese)';
      case 'ko':
        return '한국어 (Korean)';
      case 'zh':
        return '中文 (Chinese)';
      default:
        return 'Indonesia';
    }
  }
}