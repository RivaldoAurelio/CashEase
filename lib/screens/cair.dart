import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
// 🔹 Import Localization
import '../l10n/app_localizations.dart';

class CairPage extends StatefulWidget {
  final String bankName;
  final String phoneNumber;

  const CairPage({super.key, required this.bankName, required this.phoneNumber});

  @override
  State<CairPage> createState() => _CairPageState();
}

class _CairPageState extends State<CairPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final NumberFormat _currencyFormat = NumberFormat.decimalPattern('id');
  final FirestoreService _firestoreService = FirestoreService();
  
  static const int adminFee = 2000;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_formatCurrency);
  }

  void _formatCurrency() {
    final value = _amountController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (value.isNotEmpty) {
      final formatted = _currencyFormat.format(int.parse(value));
      _amountController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  Future<void> _submitWithdrawal() async {
    final l10n = AppLocalizations.of(context)!; // Akses Bahasa
    final rawAmountText = _amountController.text.replaceAll(RegExp(r'[^\d]'), '');
    final pin = _pinController.text.trim();

    if (rawAmountText.isEmpty || pin.isEmpty) {
      _showSnackBar(l10n.failed, Colors.red);
      return;
    }

    final int withdrawalAmount = int.tryParse(rawAmountText) ?? 0;
    final int totalDeduction = withdrawalAmount + adminFee;

    if (pin.length != 5) {
      _showSnackBar(l10n.failed, Colors.red);
      return;
    }

    setState(() => _isProcessing = true);

    final isPinValid = await _firestoreService.validateLogin(widget.phoneNumber, pin);

    if (!isPinValid) {
      setState(() => _isProcessing = false);
      _showSnackBar(l10n.failed, Colors.red);
      _pinController.clear();
      return;
    }

    final userMap = await _firestoreService.getUserByPhone(widget.phoneNumber);
    final int currentBalance = userMap != null ? (userMap['balance'] ?? 0) : 0;

    if (currentBalance < totalDeduction) {
      setState(() => _isProcessing = false);
      _showSnackBar("${l10n.failed}: ${l10n.balance}", Colors.red);
      return;
    }

    final success = await _firestoreService.addTransaction(
      userPhone: widget.phoneNumber,
      type: 'withdraw',
      amount: totalDeduction, 
      description: '${l10n.withdraw} ${widget.bankName}',
      recipientName: widget.bankName,
    );

    setState(() => _isProcessing = false);

    if (success) {
      await _showSuccessDialog(withdrawalAmount, l10n);
      if (mounted) Navigator.pop(context, true);
    } else {
      _showSnackBar(l10n.failed, Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  Future<void> _showSuccessDialog(int amount, AppLocalizations l10n) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.success), // "Berhasil!"
        content: Text('${l10n.withdraw} Rp ${_formatNumber(amount)} \n${l10n.adminFee}: Rp ${_formatNumber(adminFee)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.confirm), // "Konfirmasi"
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
    // 🔹 Ambil l10n
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(l10n.withdraw, style: const TextStyle(color: Colors.white)), // "Tarik"
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l10n.chooseOption}: ${widget.bankName}', style: const TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 20),
              Text(l10n.amount, style: const TextStyle(fontSize: 16, color: Colors.white)), // "Jumlah"
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '100000',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.deepPurple.shade400,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixText: 'Rp ',
                  prefixStyle: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Text('${l10n.adminFee}: Rp ${_formatNumber(adminFee)}', style: const TextStyle(fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 20),
              Text(l10n.pinTitle, style: const TextStyle(fontSize: 16, color: Colors.white)), // "Masukkan PIN"
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: _isProcessing ? null : _submitWithdrawal,
                  child: _isProcessing
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.deepPurple, strokeWidth: 2))
                      : Text(l10n.withdraw), // "Tarik"
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