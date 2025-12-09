import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_contacts/flutter_contacts.dart'; // Tambahan
import 'passwordScreen.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../services/currency_service.dart';
import '../services/firestore_service.dart'; 

class Transfer {
  String name;
  String bankName;
  String accountNumber;
  String logoAssetPath;
  String alias;

  Transfer({
    required this.name,
    required this.bankName,
    required this.accountNumber,
    required this.logoAssetPath,
    this.alias = '',
  });
}

class TransferPage extends StatefulWidget {
  final String phoneNumber;

  const TransferPage({super.key, required this.phoneNumber});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final FirestoreService _firestoreService = FirestoreService();

  final List<String> _supportedCurrencies = [
    'IDR', 'JPY', 'AUD', 'CNY', 'USD', 'EUR',
  ];

  final Map<String, String> _currencySymbols = const {
    'IDR': 'Rp ', 'JPY': '¥ ', 'AUD': 'A\$ ', 'CNY': 'CN¥ ', 'USD': '\$ ', 'EUR': '€ ',
  };

  String _formatCurrency(int number) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return 'Rp ${formatter.format(number)}';
  }

  String _formatForeignCurrency(double number, String currencyCode) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '${_currencySymbols[currencyCode] ?? ''}${formatter.format(number)}';
  }

  final List<Transfer> _beneficiaries = [
    Transfer(
      name: 'John Doe',
      bankName: 'Bank BCA',
      accountNumber: '1234567890',
      logoAssetPath: 'asset/elogo1.png',
      alias: 'Ayah',
    ),
    // ... beneficiaries lain tetap sama ...
  ];

  List<Transfer> _filteredBeneficiaries = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredBeneficiaries = _beneficiaries;
    _searchController.addListener(_filterBeneficiaries);
  }

  void _filterBeneficiaries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBeneficiaries = _beneficiaries.where((b) {
        return b.name.toLowerCase().contains(query) ||
            b.accountNumber.contains(query) ||
            b.alias.toLowerCase().contains(query);
      }).toList();
    });
  }

  // FUNGSI BARU: Ambil Kontak dari HP
  Future<void> _pickContact() async {
    // 1. Minta izin
    if (await FlutterContacts.requestPermission()) {
      // 2. Buka picker bawaan HP
      final contact = await FlutterContacts.openExternalPick();

      if (contact != null) {
        if (contact.phones.isNotEmpty) {
          // Ambil nomor pertama
          String phone = contact.phones.first.number;
          // Bersihkan karakter aneh (-, spasi, dll)
          phone = phone.replaceAll(RegExp(r'[^\d+]'), '');
          
          // Masukkan ke search bar agar user bisa langsung lanjut
          setState(() {
            _searchController.text = phone;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text("Kontak terpilih: ${contact.displayName}")),
          );
        } else {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Kontak ini tidak memiliki nomor telepon.")),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin kontak ditolak.")),
      );
    }
  }

  Future<int> _fetchBalance() async {
    final userMap = await _firestoreService.getUserByPhone(widget.phoneNumber);
    if (userMap != null) {
      return userMap['balance'] ?? 0;
    }
    return 0;
  }

  // ... (Metode _showTransferDialog dan lainnya tetap sama seperti kode asli Anda) ...
  // Saya persingkat bagian ini karena tidak berubah, tapi pastikan copy-paste 
  // bagian logika transfer dialog yang Anda punya sebelumnya ke sini.
  
  void _showTransferDialog(Transfer transfer) {
      // Paste logika _showTransferDialog asli Anda di sini...
      // (Kode dialog transfer tidak berubah, hanya logika UI akses kontak yang berubah)
      // Untuk menghemat ruang response, saya asumsikan Anda memakai kode dialog lama.
      // Jika perlu saya tulis ulang full dialognya, beri tahu.
      // Kode di bawah ini Placeholder agar struktur valid:
      final TextEditingController amountController = TextEditingController();
      // ... (lanjutan kode asli) ...
      // Agar kode valid, saya sertakan versi ringkas yang bisa dicompile
      showDialog(context: context, builder: (ctx) => AlertDialog(title: Text("Transfer ke ${transfer.name}"), content: Text("Fitur Transfer Full ada di kode lama")));
  }

  void _deleteTransfer(int index) {
     // Paste logika delete asli...
     setState(() {
        _beneficiaries.removeAt(index);
        _filterBeneficiaries();
     });
  }

  void _navigateToAddTransfer() async {
    final newTransfer = await Navigator.push<Transfer>(
      context,
      MaterialPageRoute(builder: (_) => const AddTransferPage()),
    );

    if (newTransfer != null) {
      setState(() {
        _beneficiaries.add(newTransfer);
        _filterBeneficiaries();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transfer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(), // Search bar yang sudah dimodifikasi
          Expanded(
            child: _filteredBeneficiaries.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _filteredBeneficiaries.length,
                      itemBuilder: (context, index) {
                        final transfer = _filteredBeneficiaries[index];
                        return _buildTransferCard(transfer, index);
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTransfer,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // MODIFIKASI SEARCH BAR
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.deepPurple,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama, alias, atau rekening...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // TOMBOL KONTAK BARU
          Container(
            decoration: BoxDecoration(
              color: Colors.orange, // Warna pembeda
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.contacts, color: Colors.white),
              onPressed: _pickContact, // Panggil fungsi kontak
              tooltip: "Pilih dari Kontak",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferCard(Transfer transfer, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          backgroundImage: AssetImage(transfer.logoAssetPath),
        ),
        title: Text(
          transfer.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${transfer.alias.isNotEmpty ? '${transfer.alias} • ' : ''}${transfer.bankName} - ${transfer.accountNumber}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.money,
                color: Color.fromARGB(255, 9, 215, 9),
                size: 20,
              ),
              onPressed: () => _showTransferDialog(transfer),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: () => _deleteTransfer(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Penerima',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tekan tombol + untuk menambah penerima baru.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class AddTransferPage extends StatefulWidget {
  const AddTransferPage({super.key});

  @override
  State<AddTransferPage> createState() => _AddTransferPageState();
}

class _AddTransferPageState extends State<AddTransferPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _aliasController = TextEditingController();

  String? _selectedBank;
  final List<Map<String, String>> _banks = [
    {'name': 'Bank BCA', 'logo': 'asset/elogo1.png'},
    {'name': 'Bank Mandiri', 'logo': 'asset/elogo2.png'},
    {'name': 'Bank BNI', 'logo': 'asset/elogo5.png'},
    {'name': 'Permata Bank', 'logo': 'asset/elogo4.png'},
    {'name': 'Dana', 'logo': 'asset/elogo3.png'},
  ];

  String _getLogoPath(String bankName) {
    switch (bankName) {
      case 'Bank BCA':
        return 'asset/elogo1.png';
      case 'Bank Mandiri':
        return 'asset/elogo2.png';
      case 'Bank BNI':
        return 'asset/elogo5.png';
      case 'Dana':
        return 'asset/elogo3.png';
      default:
        return 'asset/elogo1.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Tambah Penerima',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(labelText: 'Nomor Rekening'),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Pilih Bank'),
                value: _selectedBank,
                items:
                    _banks.map((bank) {
                      return DropdownMenuItem(
                        value: bank['name'],
                        child: Row(
                          children: [
                            Image.asset(bank['logo']!, width: 24),
                            const SizedBox(width: 10),
                            Text(bank['name']!),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBank = value;
                  });
                },
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Pilih bank' : null,
              ),
              TextFormField(
                controller: _aliasController,
                decoration: const InputDecoration(
                  labelText: 'Alias (opsional)',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newTransfer = Transfer(
                      name: _nameController.text,
                      alias: _aliasController.text,
                      bankName: _selectedBank!,
                      accountNumber: _accountNumberController.text,
                      logoAssetPath: _getLogoPath(_selectedBank!),
                    );
                    Navigator.pop(context, newTransfer);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}