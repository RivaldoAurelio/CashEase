import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/modeltabungan.dart';
// 🔹 Import Localization
import '../l10n/app_localizations.dart';

class EditTabungan extends StatefulWidget {
  final SavingGoal? goal;
  const EditTabungan({Key? key, this.goal}) : super(key: key);

  @override
  State<EditTabungan> createState() => _EditTabunganState();
}

class _EditTabunganState extends State<EditTabungan> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _initialDepositController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal?.title ?? '');
    _amountController = TextEditingController(
      text: widget.goal?.amount != null ? _formatNumber(widget.goal!.amount) : '',
    );
    _initialDepositController = TextEditingController(
      text: widget.goal != null
          ? _formatNumber((widget.goal!.amount * widget.goal!.progress).toInt())
          : '',
    );
    _descriptionController = TextEditingController(
      text: widget.goal?.description ?? '',
    );
    _selectedDate = widget.goal?.targetDate;
  }

  String _formatNumber(int number) {
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(number);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _initialDepositController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveGoal(AppLocalizations l10n) {
    if (_formKey.currentState!.validate()) {
      final int target = int.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
      final int initial = int.tryParse(_initialDepositController.text.replaceAll(',', '')) ?? 0;

      final newGoal = SavingGoal(
        title: _titleController.text.trim(),
        amount: target,
        progress: target > 0 ? (initial / target).clamp(0.0, 1.0) : 0.0,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        targetDate: _selectedDate,
      );
      Navigator.pop(context, newGoal);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Ambil l10n
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.goal == null ? l10n.addSavingGoal : l10n.editSavingGoal, // "Tambah Tabungan" / "Edit Tabungan"
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: l10n.savingName), // "Nama Tabungan"
                validator: (value) =>
                    value == null || value.trim().isEmpty ? l10n.enterSavingName : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: '${l10n.targetAmount} (Rp)', // "Jumlah Target (Rp)"
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ThousandsSeparatorInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return l10n.enterTargetAmount;
                  final clean = value.replaceAll(',', '');
                  final amount = int.tryParse(clean);
                  if (amount == null || amount <= 0) return l10n.validAmount; // "Masukkan jumlah yang valid"
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _initialDepositController,
                decoration: InputDecoration(
                  labelText: '${l10n.initialDeposit} (Rp)', // "Jumlah Setoran Awal"
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ThousandsSeparatorInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return l10n.enterInitialDeposit;
                  final clean = value.replaceAll(',', '');
                  final amount = int.tryParse(clean);
                  if (amount == null || amount < 0) return l10n.validAmount;
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.descriptionOptional, // "Deskripsi (Opsional)"
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(
                  _selectedDate == null
                      ? l10n.pickDate // "Pilih tanggal target"
                      : '${l10n.targetDate}: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _saveGoal(l10n),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  l10n.save, // "Simpan"
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return newValue;
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[digits.length - 1 - i]);
      if ((i + 1) % 3 == 0 && i + 1 != digits.length) {
        buffer.write(',');
      }
    }
    final formatted = buffer.toString().split('').reversed.join();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}