// lib/screens/loan.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../services/database_helper.dart';

class LoanPage extends StatefulWidget {
  const LoanPage({super.key});

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  // Controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  // State Variables
  String? currentUserPhone;
  String selectedTerm = '12 months';
  String selectedType = 'Personal Loan';
  bool isLoading = false;
  int estimatedMonthlyPayment = 0;

  // Static Data Options
  final List<String> loanTerms = ['6 months', '12 months', '24 months', '36 months'];
  final List<String> loanTypes = ['Personal Loan', 'Business Loan', 'Emergency Loan'];

  // Data List
  List<Map<String, dynamic>> activeLoans = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadUserData();
    _amountController.addListener(_calculateEstimation);
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    // Ambil nomor HP user yang login.
    // Jika null (belum login), gunakan default dummy untuk testing atau redirect ke login
    String? phone = prefs.getString('user_phone');
    
    // Fallback jika testing tanpa login
    phone ??= "08123456789"; 

    setState(() {
      currentUserPhone = phone;
    });
    
    _fetchActiveLoans();
  }

  Future<void> _fetchActiveLoans() async {
    if (currentUserPhone == null) return;
    final loans = await _dbHelper.getActiveLoans(currentUserPhone!);
    setState(() {
      activeLoans = loans;
    });
  }

  void _calculateEstimation() {
    String cleanAmount = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanAmount.isEmpty) {
      setState(() => estimatedMonthlyPayment = 0);
      return;
    }
    
    int amount = int.tryParse(cleanAmount) ?? 0;
    int months = int.parse(selectedTerm.split(' ')[0]); // Ambil angka dari "12 months"
    
    // Rumus Bunga Flat 2% per bulan (Harus sama dengan di DatabaseHelper)
    double interestRate = 0.02; 
    int totalInterest = (amount * interestRate * months).round();
    
    setState(() {
      estimatedMonthlyPayment = ((amount + totalInterest) / months).ceil();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.menuLoan, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: [
            Tab(text: "Ajukan"), // Bisa ganti l10n.apply jika tersedia
            Tab(text: "Aktif"),
            Tab(text: "Riwayat"),
            Tab(text: "Tagihan"),
          ],
        ),
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : TabBarView(
            controller: _tabController,
            children: [
              _buildApplyTab(l10n),
              _buildActiveLoansTab(l10n),
              const Center(child: Text("Riwayat Pinjaman Kosong")), // Placeholder
              const Center(child: Text("Tidak ada tagihan tertunda")), // Placeholder
            ],
          ),
    );
  }

  // ================== TAB 1: FORM PENGAJUAN ==================

  Widget _buildApplyTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.menuLoan, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                
                // Input Amount
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Jumlah Pinjaman", // l10n.amount
                    prefixText: "Rp ",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 15),

                // Dropdown Type
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: InputDecoration(
                    labelText: "Tipe Pinjaman",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: loanTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  onChanged: (val) => setState(() => selectedType = val!),
                ),
                const SizedBox(height: 15),

                // Dropdown Term
                DropdownButtonFormField<String>(
                  value: selectedTerm,
                  decoration: InputDecoration(
                    labelText: "Durasi (Tenor)",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: loanTerms.map((term) => DropdownMenuItem(value: term, child: Text(term))).toList(),
                  onChanged: (val) {
                    setState(() => selectedTerm = val!);
                    _calculateEstimation();
                  },
                ),
                const SizedBox(height: 15),

                // Input Purpose
                TextField(
                  controller: _purposeController,
                  decoration: InputDecoration(
                    labelText: "Tujuan Penggunaan",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 20),

                // Estimation Box
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Estimasi Cicilan/Bulan:", style: TextStyle(fontSize: 12)),
                      Text(
                        NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(estimatedMonthlyPayment),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitApplication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(l10n.continueButton, style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.monetization_on, color: Colors.white, size: 40),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Butuh dana cepat?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text("Ajukan pinjaman dengan bunga rendah dan proses cepat.", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================== TAB 2: LIST PINJAMAN AKTIF ==================

  Widget _buildActiveLoansTab(AppLocalizations l10n) {
    if (activeLoans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Text("Tidak ada pinjaman aktif", style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: activeLoans.length,
      itemBuilder: (context, index) {
        final loan = activeLoans[index];
        final currency = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
        
        // Hitung progress pembayaran
        final double progress = 1.0 - (loan['remaining_amount'] / loan['amount']);
        final String percent = (progress * 100).toStringAsFixed(0);

        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(loan['type'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(4)),
                      child: Text("Aktif", style: TextStyle(color: Colors.green[800], fontSize: 12)),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                
                // Sisa Tagihan Utama
                const Text("Sisa Tagihan", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  currency.format(loan['remaining_amount']), 
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent)
                ),
                
                const SizedBox(height: 15),
                
                // Progress Bar
                LinearProgressIndicator(
                  value: progress, 
                  backgroundColor: Colors.grey[200], 
                  color: Colors.blue,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$percent% Lunas", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text("Total: ${currency.format(loan['amount'])}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                
                const Divider(height: 30),
                
                // Footer Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Cicilan Bulanan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(currency.format(loan['monthly_payment']), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => _showPaymentDialog(loan),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Bayar", style: TextStyle(color: Colors.white)),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // ================== LOGIC METHODS ==================

  void _submitApplication() async {
    if (_amountController.text.isEmpty || currentUserPhone == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi jumlah pinjaman')),
      );
      return;
    }
    
    setState(() => isLoading = true);

    int amount = int.parse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), ''));
    int months = int.parse(selectedTerm.split(' ')[0]);

    // Panggil Database
    bool success = await _dbHelper.applyLoan(
      userPhone: currentUserPhone!,
      type: selectedType,
      amount: amount,
      termMonths: months,
    );

    setState(() => isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengajuan berhasil! Dana dicairkan ke saldo Anda.'), backgroundColor: Colors.green),
        );
        _amountController.clear();
        _purposeController.clear();
        _calculateEstimation();
        _fetchActiveLoans(); // Refresh data
        _tabController.animateTo(1); // Pindah ke tab Active
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengajukan pinjaman. Cek log error.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showPaymentDialog(Map<String, dynamic> loan) {
    final currency = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Pembayaran"),
          content: Text("Anda akan membayar cicilan sebesar ${currency.format(loan['monthly_payment'])}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text("Batal")
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Tutup dialog dulu
                _processPayment(loan);
              },
              child: const Text("Bayar Sekarang"),
            )
          ],
        );
      },
    );
  }

  void _processPayment(Map<String, dynamic> loan) async {
    setState(() => isLoading = true);
    
    final result = await _dbHelper.payLoanInstallment(
      loan['id'], 
      currentUserPhone!, 
      loan['monthly_payment']
    );

    setState(() => isLoading = false);

    if (mounted) {
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message']), backgroundColor: Colors.green),
        );
        _fetchActiveLoans(); // Refresh list agar sisa tagihan berkurang
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
        );
      }
    }
  }
}