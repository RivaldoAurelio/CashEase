// lib/screens/cair.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Ditambahkan untuk input format
import 'package:intl/intl.dart';
// MODIFIKASI: Gunakan FirestoreService
import '../services/firestore_service.dart';

class CairPage extends StatefulWidget {
  final String bankName;
  // Tambahkan phoneNumber untuk otentikasi dan transaksi
  final String phoneNumber;

  const CairPage({
    super.key,
    required this.bankName,
    required this.phoneNumber,
  });

  @override
  State<CairPage> createState() => _CairPageState();
}

class _CairPageState extends State<CairPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final NumberFormat _currencyFormat = NumberFormat.decimalPattern('id');
  
  // MODIFIKASI: Inisialisasi FirestoreService
  final FirestoreService _firestoreService = FirestoreService();
  
  static const int adminFee = 2000;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_formatCurrency);
  }

  void _formatCurrency() {
    // Memformat input dengan pemisah ribuan
    final value = _amountController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (value.isNotEmpty) {
      final formatted = _currencyFormat.format(int.parse(value));
      // Menggunakan replaceFirst untuk menghilangkan format di sisi Dart
      _amountController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  Future<void> _submitWithdrawal() async {
    // Bersihkan input dari format mata uang
    final rawAmountText = _amountController.text.replaceAll(
      RegExp(r'[^\d]'),
      '',
    );
    final pin = _pinController.text.trim();

    if (rawAmountText.isEmpty || pin.isEmpty) {
      _showSnackBar('Harap isi nominal dan PIN terlebih dahulu', Colors.red);
      return;
    }

    final int withdrawalAmount = int.tryParse(rawAmountText) ?? 0;
    final int totalDeduction = withdrawalAmount + adminFee;

    if (pin.length != 5) {
      _showSnackBar('PIN harus 5 digit', Colors.red);
      return;
    }

    if (withdrawalAmount <= 0) {
      _showSnackBar('Nominal penarikan harus lebih dari Rp 0', Colors.red);
      return;
    }

    setState(() => _isProcessing = true);

    // 1. Validasi PIN (ke Firestore)
    final isPinValid = await _firestoreService.validateLogin(widget.phoneNumber, pin);

    if (!isPinValid) {
      setState(() => _isProcessing = false);
      _showSnackBar('PIN yang Anda masukkan salah', Colors.red);
      _pinController.clear();
      return;
    }

    // 2. Cek Saldo (dari Firestore)
    // Ambil data user terbaru untuk memastikan saldo cukup
    final userMap = await _firestoreService.getUserByPhone(widget.phoneNumber);
    final int currentBalance = userMap != null ? (userMap['balance'] ?? 0) : 0;

    if (currentBalance < totalDeduction) {
      setState(() => _isProcessing = false);
      _showSnackBar(
        'Penarikan gagal: Saldo tidak mencukupi (Perlu Rp ${_formatNumber(totalDeduction)} termasuk biaya admin)',
        Colors.red,
      );
      return;
    }

    // 3. Proses Penarikan (Eksekusi di Firestore)
    // addTransaction otomatis mengurangi saldo jika type != 'topup'
    // Kita kirim jumlah TOTAL (pokok + admin) agar saldo berkurang sesuai
    final success = await _firestoreService.addTransaction(
      userPhone: widget.phoneNumber,
      type: 'withdraw',
      amount: totalDeduction, 
      description: 'Penarikan ke ${widget.bankName} (Pokok: ${_formatNumber(withdrawalAmount)} + Admin)',
      recipientName: widget.bankName,
    );

    setState(() => _isProcessing = false);

    if (success) {
      // Tampilkan notifikasi sukses
      await _showSuccessDialog(withdrawalAmount);

      // Kembali ke Home/WithdrawPage dan trigger refresh
      if (mounted) {
        Navigator.pop(context, true);
      }
    } else {
      _showSnackBar('Penarikan gagal karena masalah koneksi/sistem.', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  Future<void> _showSuccessDialog(int amount) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Penarikan Berhasil'),
            content: Text(
              'Dana sebesar Rp ${_formatNumber(amount)} berhasil ditarik ke ${widget.bankName}.\nBiaya admin: Rp ${_formatNumber(adminFee)}.',
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  String _formatNumber(int number) {
    final formatter = NumberFormat('#,##0', 'id_ID');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Form Penarikan',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Metode: ${widget.bankName}',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Nominal Penarikan (Min. Rp 10.000)',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                // Menggunakan FilteringTextInputFormatter.digitsOnly untuk menghilangkan format saat input
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Contoh: 100000',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.deepPurple.shade400,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixText: 'Rp ',
                  prefixStyle: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Biaya Admin: Rp ${_formatNumber(adminFee)}',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              const Text(
                'Masukkan PIN',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 5,
                inputFormatters: [LengthLimitingTextInputFormatter(5)],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '•••••',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.deepPurple.shade400,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _isProcessing ? null : _submitWithdrawal,
                  child:
                      _isProcessing
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.deepPurple,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text('Tarik Dana'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.removeListener(_formatCurrency);
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }
}