// lib/screens/password.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan ini untuk Session
import 'SecurtyCode.dart';
import 'forgotpin.dart';
import '../services/firestore_service.dart';

class Password extends StatelessWidget {
  final String phoneNumber;
  final bool isNewUser;

  const Password({
    super.key, 
    required this.phoneNumber, 
    required this.isNewUser
  });

  @override
  Widget build(BuildContext context) {
    return PasswordComponen(phoneNumber: phoneNumber, isNewUser: isNewUser);
  }
}

class PasswordComponen extends StatefulWidget {
  final String phoneNumber;
  final bool isNewUser;

  const PasswordComponen({
    super.key,
    required this.phoneNumber,
    required this.isNewUser,
  });

  @override
  State<PasswordComponen> createState() => _PasswordComponenState();
}

class _PasswordComponenState extends State<PasswordComponen> {
  // 5 Digit PIN Controller
  final List<TextEditingController> _pinControllers = List.generate(
    5,
    (_) => TextEditingController(),
  );
  
  // Instance Firestore Service
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  void _handleKeypadInput(String value) {
    for (final controller in _pinControllers) {
      if (controller.text.isEmpty) {
        setState(() {
          controller.text = value;
        });
        break;
      }
    }
  }

  void _handleDelete() {
    for (int i = _pinControllers.length - 1; i >= 0; i--) {
      if (_pinControllers[i].text.isNotEmpty) {
        setState(() {
          _pinControllers[i].clear();
        });
        break;
      }
    }
  }

  bool _isPinComplete() {
    return _pinControllers.every((controller) => controller.text.isNotEmpty);
  }

  String _getPin() {
    return _pinControllers.map((c) => c.text).join();
  }

  // Fungsi menyimpan sesi login agar user tidak perlu login berulang kali
  Future<void> _saveLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInPhone', widget.phoneNumber);
  }

  Future<void> _handleContinue() async {
    // 1. Validasi Input PIN
    if (!_isPinComplete()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan PIN 5 digit lengkap terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final pin = _getPin();
    bool success = false;
    String message = '';

    try {
      if (widget.isNewUser) {
        // 🔹 KASUS 1: REGISTER USER BARU KE FIRESTORE
        success = await _firestoreService.registerUser(widget.phoneNumber, pin);
        message = success 
            ? 'Akun berhasil dibuat! Selamat datang.' 
            : 'Gagal membuat akun. Nomor mungkin sudah terdaftar.';
      } else {
        // 🔹 KASUS 2: LOGIN VALIDASI KE FIRESTORE
        success = await _firestoreService.validateLogin(widget.phoneNumber, pin);
        message = success 
            ? 'Login berhasil!' 
            : 'PIN salah atau akun tidak ditemukan.';
      }
    } catch (e) {
      message = 'Terjadi kesalahan jaringan. Coba lagi.';
      success = false;
    }

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Simpan sesi login lokal
      await _saveLoginSession();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );

      // Navigasi ke Security Code / Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SecurtyCode(phoneNumber: widget.phoneNumber),
        ),
      );
    } else {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );

      // Jika Login Gagal, bersihkan PIN agar user bisa coba lagi
      if (!widget.isNewUser) {
        for (var controller in _pinControllers) {
          controller.clear();
        }
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isNewUser ? 'Buat PIN Baru' : 'Masukkan PIN',
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 22, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.phoneNumber,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 30),
            
            // PIN Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _pinControllers.map((controller) => Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  controller: controller,
                  readOnly: true,
                  textAlign: TextAlign.center,
                  obscureText: true, // Sembunyikan PIN (opsional, ganti false jika ingin terlihat)
                  obscuringCharacter: '●',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                  decoration: InputDecoration(
                    counterText: '',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              )).toList(),
            ),

            const SizedBox(height: 20),
            
            // Forgot PIN (Hanya muncul jika login)
            if (!widget.isNewUser)
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPinPage(phoneNumber: widget.phoneNumber),
                    ),
                  );
                },
                child: const Text(
                  'Lupa PIN?', 
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white
                  )
                ),
              ),

            const SizedBox(height: 30),
            
            // Keypad
            _buildKeypad(),
            
            const SizedBox(height: 30),
            
            // Action Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                minimumSize: const Size(200, 50),
              ),
              onPressed: _isLoading ? null : _handleContinue,
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
                      widget.isNewUser ? 'Daftar Sekarang' : 'Masuk',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final buttons = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          final text = buttons[index];
          if (text == '') return const SizedBox.shrink();
          if (text == '⌫') {
            return _keypadButton(
              icon: Icons.backspace_outlined, 
              onPressed: _handleDelete
            );
          }
          return _keypadButton(
            text: text, 
            onPressed: () => _handleKeypadInput(text)
          );
        },
      ),
    );
  }

  Widget _keypadButton({String? text, IconData? icon, required VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Center(
          child: text != null
              ? Text(
                  text,
                  style: const TextStyle(
                    fontSize: 28, 
                    color: Colors.white, 
                    fontWeight: FontWeight.w500
                  ),
                )
              : Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}