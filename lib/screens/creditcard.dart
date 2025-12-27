import 'package:flutter/material.dart';
// 🔹 Import Localization
import '../l10n/app_localizations.dart';

class CreditCardPaymentPage extends StatefulWidget {
  @override
  _CreditCardPaymentPageState createState() => _CreditCardPaymentPageState();
}

class _CreditCardPaymentPageState extends State<CreditCardPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedBank = 'BCA';

  final List<Map<String, dynamic>> _banks = [
    {'name': 'BCA', 'logo': 'asset/elogo1.png'},
    {'name': 'Mandiri', 'logo': 'asset/elogo2.png'},
    {'name': 'BNI', 'logo': 'asset/elogo5.png'},
    {'name': 'Permata Bank', 'logo': 'asset/elogo3.png'},
  ];

  List<Map<String, String>> _history = [];

  void _submitPayment(AppLocalizations l10n) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _history.insert(0, {
          'bank': _selectedBank ?? '',
          'card': _cardNumberController.text,
          'amount': _amountController.text,
          'date': DateTime.now().toString().substring(0, 16),
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.success)));
      _cardNumberController.clear();
      _amountController.clear();
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Widget _buildBankDropdown(AppLocalizations l10n) {
    return DropdownButtonFormField<String>(
      value: _selectedBank,
      decoration: InputDecoration(labelText: l10n.bankName, border: InputBorder.none, contentPadding: EdgeInsets.zero),
      items: _banks.map((bank) {
        return DropdownMenuItem<String>(
          value: bank['name'],
          child: Row(
            children: [
              Image.asset(bank['logo']!, width: 28, height: 28, errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_balance)),
              const SizedBox(width: 8),
              Text(bank['name']!, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedBank = value),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black, fontSize: 16),
      dropdownColor: Colors.white,
    );
  }

  Widget _buildHistory(AppLocalizations l10n) {
    if (_history.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32, left: 8, bottom: 8),
          child: Text(l10n.transactionHistory, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        ..._history.map((item) => Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.credit_card, color: Colors.deepPurple),
            title: Text('${item['bank']} - ${item['card']}'),
            subtitle: Text('Rp ${item['amount']} • ${item['date']}'),
          ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Ambil l10n
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C3AED),
        elevation: 0,
        title: Text(l10n.menuCreditCard, style: const TextStyle(color: Colors.white)), // "Credit Card"
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Container(color: const Color(0xFF7C3AED), padding: const EdgeInsets.only(bottom: 32), child: const SizedBox(height: 0)),
            Transform.translate(
              offset: const Offset(0, -32),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE0D7F3))),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBankDropdown(l10n),
                        const SizedBox(height: 18),
                        Text(l10n.cardNumber, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black87)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _cardNumberController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '1234 5678 ...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                          validator: (value) => (value == null || value.length < 16) ? l10n.failed : null,
                        ),
                        const SizedBox(height: 16),
                        Text(l10n.amount, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black87)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixText: 'Rp ',
                            prefixStyle: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold),
                            hintText: '0',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                          validator: (value) => (value == null || value.isEmpty) ? l10n.failed : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: () => _submitPayment(l10n),
                  child: Text(l10n.pay, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildHistory(l10n)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}