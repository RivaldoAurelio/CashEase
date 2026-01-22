import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// 🔹 Import Localization
import '../l10n/app_localizations.dart';

class History extends StatefulWidget {
  final String phoneNumber;
  const History({super.key, required this.phoneNumber});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String? selectedStatus;
  String? selectedCategory;
  DateTime? selectedDate;
  bool showFilterPanel = false;

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  List<Map<String, dynamic>> allTransactions = [];
  bool _isLoading = true;
  List<Map<String, dynamic>> filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('user_phone', isEqualTo: widget.phoneNumber)
          .get();

      final dbTransactions = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      dbTransactions.sort((a, b) {
        String dateA = a['created_at'] ?? '';
        String dateB = b['created_at'] ?? '';
        return dateB.compareTo(dateA);
      });

      // Pass context/l10n later in map
      allTransactions = dbTransactions.map((dbT) => _mapTransactionToUI(dbT)).toList();
      filteredTransactions = List.from(allTransactions);
    } catch (e) {
      allTransactions = [];
      filteredTransactions = [];
    }
    setState(() => _isLoading = false);
  }

  // NOTE: This now returns raw data structure, localization happens in UI building
  Map<String, dynamic> _mapTransactionToUI(Map<String, dynamic> dbT) {
    String type = dbT['type'] as String? ?? 'unknown';
    String status = dbT['status'] as String? ?? 'pending';
    int amount = (dbT['amount'] is int) 
        ? dbT['amount'] 
        : (dbT['amount'] as double?)?.toInt() ?? 0;
        
    String description = dbT['description'] as String? ?? 'No Description';
    
    DateTime date = DateTime.now();
    if (dbT['created_at'] != null) {
      date = DateTime.tryParse(dbT['created_at'].toString()) ?? DateTime.now();
    }

    Color color;
    IconData icon;
    
    // Logic for color/icon stays same
    switch (type) {
      case 'topup':
        color = status == 'success' ? Colors.green : Colors.red;
        icon = Icons.arrow_upward;
        break;
      case 'transfer':
      case 'send_money':
        color = status == 'success' ? Colors.orange : Colors.red;
        icon = Icons.send;
        amount = -amount;
        break;
      case 'payment':
        color = status == 'success' ? Colors.blue : Colors.red;
        icon = Icons.shopping_cart;
        amount = -amount;
        break;
      case 'request':
        color = Colors.green;
        icon = Icons.call_received;
        break;
      case 'failed':
        color = Colors.red;
        icon = Icons.error;
        amount = 0;
        break;
      case 'saving_goal':
        color = Colors.purple;
        icon = Icons.savings;
        amount = 0;
        break;
      case 'withdraw':
        color = status == 'success' ? Colors.orange : Colors.red;
        icon = Icons.atm;
        amount = -amount;
        break;
      default:
        color = Colors.grey;
        icon = Icons.info;
    }

    // Keep raw data, we will translate in build()
    return {
      'type': type,
      'status': status,
      'description_raw': description, // Original text from DB
      'recipient_name': dbT['recipient_name'],
      'color': color,
      'icon': icon,
      'date': date,
      'amount': amount,
    };
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      filteredTransactions = allTransactions.where((transaction) {
        bool matchesSearch = searchQuery.isEmpty ||
            transaction['description_raw'].toLowerCase().contains(searchQuery.toLowerCase());

        bool matchesStatus = selectedStatus == null ||
            transaction['status'] == selectedStatus;

        bool matchesCategory = selectedCategory == null ||
            transaction['type'] == selectedCategory;

        bool matchesDate = selectedDate == null ||
            (transaction['date'].year == selectedDate!.year &&
                transaction['date'].month == selectedDate!.month &&
                transaction['date'].day == selectedDate!.day);

        return matchesSearch && matchesStatus && matchesCategory && matchesDate;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      selectedStatus = null;
      selectedCategory = null;
      selectedDate = null;
      _searchController.clear();
      searchQuery = '';
      filteredTransactions = List.from(allTransactions);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Ambil l10n
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.transNotif, // "Aktivitas Transaksi" / "Transaction Activity"
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: l10n.searchHint, // "Cari"
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showFilterPanel = !showFilterPanel;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.filter_list),
                  ),
                ),
              ],
            ),
          ),

          if (showFilterPanel)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.transactionStatus, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), // "Status Transaksi"
                  const SizedBox(height: 8),
                  _buildStatusFilter(l10n),
                  const SizedBox(height: 16),
                  Text(l10n.date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), // "Tanggal"
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2026),
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                          _applyFilters();
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate == null ? l10n.chooseDate : _formatDate(selectedDate!, 'dd/MM/yyyy'),
                            style: TextStyle(color: selectedDate == null ? Colors.grey : Colors.black),
                          ),
                          const Icon(Icons.calendar_today, color: Colors.deepPurple, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), // "Kategori"
                  const SizedBox(height: 8),
                  _buildCategoryFilter(l10n),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _resetFilters();
                            setState(() => showFilterPanel = false);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.deepPurple,
                            side: const BorderSide(color: Colors.deepPurple),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(l10n.reset), // "Reset"
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _applyFilters();
                            setState(() => showFilterPanel = false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(l10n.apply), // "Terapkan"
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(l10n.noTransactions, style: TextStyle(fontSize: 16, color: Colors.grey[600])), // "Tidak ada transaksi"
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      // Display raw description for now, or you can map types to l10n here
                      return Container(
                        margin: const EdgeInsets.only(bottom: 1),
                        color: Colors.white,
                        child: ListTile(
                          leading: Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(color: transaction['color'], shape: BoxShape.circle),
                            child: Icon(transaction['icon'], color: Colors.white),
                          ),
                          title: Text(
                            transaction['description_raw'],
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatDate(transaction['date'], 'dd MMM yyyy'),
                                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                              ),
                            ],
                          ),
                          trailing: transaction['amount'] != 0
                              ? Text(
                                  _formatCurrency(transaction['amount']),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: (transaction['amount'] as int) > 0 ? Colors.green : Colors.red,
                                  ),
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter(AppLocalizations l10n) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: [
        _buildFilterChip(l10n.all, null, isStatus: true),
        _buildFilterChip(l10n.success, 'success', isStatus: true),
        _buildFilterChip(l10n.cancelled, 'cancelled', isStatus: true),
        _buildFilterChip(l10n.inProgress, 'in_progress', isStatus: true),
        _buildFilterChip(l10n.failed, 'failed', isStatus: true),
        _buildFilterChip(l10n.approved, 'approved', isStatus: true),
      ],
    );
  }

  Widget _buildCategoryFilter(AppLocalizations l10n) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: [
        _buildFilterChip(l10n.all, null, isStatus: false),
        _buildFilterChip(l10n.menuBills, 'payment', isStatus: false), // Payment -> Bills
        _buildFilterChip(l10n.withdraw, 'withdraw', isStatus: false),
        _buildFilterChip(l10n.topUp, 'topup', isStatus: false),
        _buildFilterChip(l10n.request, 'request', isStatus: false),
        _buildFilterChip(l10n.menuTransfer, 'transfer', isStatus: false),
      ],
    );
  }

  Widget _buildFilterChip(String label, String? value, {required bool isStatus}) {
    final isSelected = isStatus ? selectedStatus == value : selectedCategory == value;
    return InkWell(
      onTap: () {
        setState(() {
          if (isStatus) {
            selectedStatus = value;
          } else {
            selectedCategory = value;
          }
          _applyFilters();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.deepPurple : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? Colors.deepPurple.withOpacity(0.1) : Colors.transparent,
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.deepPurple : Colors.black, fontSize: 12)),
      ),
    );
  }

  String _formatDate(DateTime date, String format) {
    if (format == 'dd/MM/yyyy') {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } else if (format == 'dd MMM yyyy') {
      return DateFormat('dd MMM yyyy').format(date);
    }
    return date.toString();
  }

  String _formatCurrency(int amount) {
    String prefix = 'Rp ';
    return '$prefix${NumberFormat('#,###', 'id_ID').format(amount.abs())}';
  }
}