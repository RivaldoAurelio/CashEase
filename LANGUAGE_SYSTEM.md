# Sistem Bahasa Otomatis CashEase

## 📋 Cara Kerja Sistem

Aplikasi CashEase sekarang dilengkapi dengan sistem perubahan bahasa **otomatis dan real-time** tanpa perlu restart aplikasi.

### Komponen Utama:

1. **LanguageProvider** (`lib/providers/language_provider.dart`)
   - Mengelola state bahasa menggunakan `ChangeNotifier`
   - Menyimpan bahasa pilihan ke `SharedPreferences`
   - Otomatis memuat bahasa terakhir saat aplikasi dibuka

2. **MyApp** (`lib/main.dart`)
   - Menggunakan `Consumer<LanguageProvider>` untuk mendengarkan perubahan bahasa
   - Otomatis rebuild UI saat bahasa berubah

3. **Settings Screen** (`lib/screens/settings.dart`)
   - Interface untuk memilih bahasa
   - Menampilkan nama bahasa yang sedang aktif
   - Trigger perubahan bahasa melalui `Provider`

## 🌐 Bahasa yang Didukung

- 🇮🇩 Bahasa Indonesia (`id`)
- 🇬🇧 English (`en`)
- 🇯🇵 日本語 - Japanese (`ja`)
- 🇰🇷 한국어 - Korean (`ko`)
- 🇨🇳 中文 - Chinese (`zh`)

## 🔄 Alur Perubahan Bahasa

```
User memilih bahasa di Settings
         ↓
_buildLanguageItem() → provider.changeLanguage(code)
         ↓
LanguageProvider.changeLanguage()
  • Update _currentLocale
  • Simpan ke SharedPreferences
  • notifyListeners() ← PENTING!
         ↓
Consumer<LanguageProvider> di MyApp mendengarkan
         ↓
MyApp rebuild dengan locale baru
         ↓
AppLocalizations otomatis menyesuaikan teks
         ↓
UI di seluruh app berubah bahasa secara real-time ✅
```

## 📁 File-file Penting

```
lib/
├── main.dart                          # Entry point dengan Provider setup
├── providers/
│   └── language_provider.dart         # State management bahasa
├── screens/
│   └── settings.dart                  # UI untuk memilih bahasa
└── l10n/
    ├── app_en.arb                     # Teks English
    ├── app_id.arb                     # Teks Indonesia
    ├── app_ja.arb                     # Teks Japanese
    ├── app_ko.arb                     # Teks Korean
    ├── app_zh.arb                     # Teks Chinese
    └── app_localizations.dart         # Generated file
```

## 💻 Cara Menggunakan di Screen

### 1. Mengakses Teks Bahasa

```dart
// Dapatkan AppLocalizations
final l10n = AppLocalizations.of(context)!;

// Gunakan teks dari file .arb
Text(l10n.settingsTitle)        // "Settings" / "Pengaturan" / dll
Text(l10n.changeLanguage)       // "Change Language" / "Ganti Bahasa" / dll
```

### 2. Mendengarkan Perubahan Bahasa (Optional)

```dart
final languageProvider = Provider.of<LanguageProvider>(context);
String currentLanguage = languageProvider.currentLocale.languageCode;
```

### 3. Mengubah Bahasa Secara Programatic

```dart
final provider = Provider.of<LanguageProvider>(context, listen: false);
await provider.changeLanguage('en'); // Ubah ke English
```

## ✨ Fitur-Fitur

✅ **Perubahan Real-time** - Semua UI terupdate otomatis tanpa restart  
✅ **Persistent** - Bahasa tersimpan dan dimuat saat aplikasi dibuka  
✅ **Smooth** - Menggunakan Provider untuk state management yang efisien  
✅ **5 Bahasa** - Support ID, EN, JA, KO, ZH  
✅ **Simple API** - Mudah diintegrasikan dengan screen manapun  

## 🚀 Testing

Untuk menguji:

1. Buka Settings Screen
2. Tap "변경 언어" / "Change Language" 
3. Pilih bahasa pilihan
4. Lihat UI otomatis berubah di seluruh aplikasi!

---

**Note**: Pastikan `pubspec.yaml` sudah include `provider: ^6.0.0` sebelum menjalankan aplikasi.
