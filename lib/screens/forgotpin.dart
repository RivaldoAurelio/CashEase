import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// 🔹 Ganti DatabaseHelper dengan FirestoreService
import '../services/firestore_service.dart';
// 🔹 Import Localization
import '../l10n/app_localizations.dart';

class ForgotPinPage extends StatefulWidget {
  final String phoneNumber;
  const ForgotPinPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<ForgotPinPage> createState() => _ForgotPinPageState();
}

class _ForgotPinPageState extends State<ForgotPinPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController newPinController = TextEditingController();
  
  // Instance Firestore Service
  final FirestoreService _firestoreService = FirestoreService();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Hilangkan prefix +62 jika ada, agar bersih di TextField
    String cleanPhone = widget.phoneNumber;
    if (cleanPhone.startsWith('+62')) {
      cleanPhone = cleanPhone.substring(3);
    } else if (cleanPhone.startsWith('62')) {
      cleanPhone = cleanPhone.substring(2);
    }
    phoneController.text = cleanPhone;
  }

  Future<void> _handleReset(AppLocalizations l10n) async {
    // Format ulang nomor hp jadi +62... untuk dikirim ke Firestore
    final rawPhone = phoneController.text.trim();
    final phone = '+62$rawPhone';
    final pin = newPinController.text.trim();

    // Validasi dasar
    if (rawPhone.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.phoneError), backgroundColor: Colors.red),
      );
      return;
    }

    if (pin.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pinLengthError), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Cek apakah user terdaftar di Firestore
      final userMap = await _firestoreService.getUserByPhone(phone);
      final isRegistered = userMap != null;

      if (!isRegistered) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.phoneNotRegistered), backgroundColor: Colors.red),
          );
        }
        return;
      }

      // 2. Update PIN ke Firestore
      final success = await _firestoreService.updatePin(phone, pin);

      setState(() => _isLoading = false);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.pinChangedSuccess),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          // Tunggu sebentar lalu kembali ke login/sebelumnya
          await Future.delayed(const Duration(seconds: 1));
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.failed), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      print("Error reset pin: $e");
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Terjadi kesalahan. Coba lagi."), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    newPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ambil l10n
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: Text(l10n.resetPin, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.lock_reset, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                l10n.resetPinTitle, // "Reset PIN Anda"
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                l10n.resetPinSubtitle, // "Konfirmasi nomor..."
                style: const TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Input Phone
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade400,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '+62',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(13), // Panjang max no hp
                      ],
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: l10n.phoneHint,
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.deepPurple.shade400,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Input New PIN
              TextField(
                controller: newPinController,
                obscureText: true,
                maxLength: 5,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: l10n.newPin, // "PIN Baru"
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.deepPurple.shade400,
                  prefixIcon: const Icon(Icons.lock, color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Button
              ElevatedButton(
                onPressed: _isLoading ? null : () => _handleReset(l10n),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        l10n.resetPin, // "Reset PIN"
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}