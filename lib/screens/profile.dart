// lib/screens/profile.dart
import 'dart:io'; // Tambahan untuk File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart'; // Tambahan untuk Image Picker
import 'edit_profile.dart';
import 'edit_tabungan.dart';
import '../models/modeltabungan.dart';
import '../services/firestore_service.dart';

class ProfilePage extends StatefulWidget {
  final bool isPushed;
  final String userPhone;

  const ProfilePage({
    super.key,
    this.isPushed = false,
    required this.userPhone,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _showEditIcon = false;
  File? _selectedImage; // Variabel untuk menyimpan foto terpilih sementara

  List<SavingGoal> savingGoals = [
    SavingGoal(
      title: "Tabungan Darurat",
      amount: 25700000,
      progress: 0.71,
      description: "Dana darurat 6 bulan",
      targetDate: DateTime(2024, 6, 30),
    ),
  ];

  // FUNGSI BARU: Ambil Gambar
  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 50, // Kompresi agar ringan
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto profil berhasil dipilih (Lokal)')),
          );
        }
        // Catatan: Di real app, di sini Anda upload _selectedImage ke Firebase Storage
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto (Kamera)'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToEditProfile(Map<String, dynamic> userData) async {
    final String firstName = userData['first_name'] ?? "";
    final String lastName = userData['last_name'] ?? "";
    final String email = userData['email'] ?? "";
    final String gender = userData['gender'] ?? "Pria";

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfile(
          firstName: firstName,
          lastName: lastName,
          phoneNumber: widget.userPhone,
          email: email,
          gender: gender,
        ),
      ),
    );

    if (result is Map<String, dynamic>) {
      await _firestoreService.updateUserProfile(
        phone: widget.userPhone,
        firstName: result['firstName'],
        lastName: result['lastName'],
        email: result['email'],
        gender: result['gender'],
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil berhasil diperbarui!")),
        );
      }
    }
  }

  String _formatCurrency(num amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  void _showQRCodeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'QR PROFIL',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.userPhone.replaceRange(
                4,
                widget.userPhone.length - 2,
                '*' * (widget.userPhone.length - 6),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'asset/kodeqr.png',
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Ajak teman yang ada didekat kamu memindai\nkode QR ini untuk memulai transaksi.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Tutup",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddSaving() async {
    final newGoal = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditTabungan()),
    );

    if (newGoal is SavingGoal) {
      setState(() {
        savingGoals.add(newGoal);
      });
    }
  }

  void _navigateToEditSaving(int index) async {
    final updatedGoal = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTabungan(goal: savingGoals[index]),
      ),
    );

    if (updatedGoal is SavingGoal) {
      setState(() {
        savingGoals[index] = updatedGoal;
      });
    }
  }

  void _showGoalDialog(int index) {
    final goal = savingGoals[index];
    final TextEditingController depositController = TextEditingController();
    // ignore: unused_local_variable
    final depositFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(goal.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Jumlah: Rp ${_formatCurrency(goal.amount.toInt())}"),
              Text(
                "Progress: ${(goal.progress * 100).toStringAsFixed(1)}%",
              ),
              if (goal.description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text("Deskripsi: ${goal.description!}"),
                ),
              if (goal.targetDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "Target: ${goal.targetDate!.toIso8601String().split('T')[0]}",
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToEditSaving(index);
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () {
              setState(() => savingGoals.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tambah Tabungan'),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(int index) {
    final goal = savingGoals[index];
    return GestureDetector(
      onTap: () => _showGoalDialog(index),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      goal.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      goal.targetDate?.toIso8601String().split('T')[0] ??
                          "Tanpa target",
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.deepPurple.withOpacity(0.1),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Rp ${_formatCurrency((goal.amount * goal.progress).toInt())}",
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: goal.progress,
                color: Colors.deepPurple,
                backgroundColor: Colors.grey[200],
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${(goal.progress * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    "Rp ${_formatCurrency(goal.amount.toInt())}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionInfo(
    IconData icon,
    String label,
    double amount,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              "Rp ${_formatCurrency(amount.toInt())}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isPushed
          ? AppBar(
              backgroundColor: Colors.deepPurple,
              iconTheme: const IconThemeData(color: Colors.white),
            )
          : null,
      backgroundColor: Colors.deepPurple,
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestoreService.getUserStream(widget.userPhone),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Data User tidak ditemukan", style: TextStyle(color: Colors.white)));
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          
          String firstName = data['first_name'] ?? 'User';
          String lastName = data['last_name'] ?? '';
          String fullName = '$firstName $lastName'.trim();
          if (fullName.isEmpty) fullName = "User";
          
          String phoneDisplay = data['phone'] ?? widget.userPhone;
          double balance = (data['balance'] ?? 0).toDouble();
          double income = 0; 
          double expense = 0; 

          return Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: const Text(
                    "Personal",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Widget Profile MODIFIKASI FOTO
              ListTile(
                leading: MouseRegion(
                  onEnter: (_) => setState(() => _showEditIcon = true),
                  onExit: (_) => setState(() => _showEditIcon = false),
                  child: GestureDetector(
                    onTap: _showImageSourceDialog, // GANTI FOTO DI SINI
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          // Prioritaskan gambar lokal, lalu asset
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!) as ImageProvider
                              : const AssetImage('asset/foto.png'),
                        ),
                        if (_showEditIcon)
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt, // Icon kamera lebih sesuai
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                title: Text(
                  fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: GestureDetector(
                  onTap: () => _navigateToEditProfile(data), // Edit teks profil via tap teks
                  child: Row(
                    children: [
                      Text(
                        phoneDisplay,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.edit, color: Colors.white70, size: 14)
                    ],
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: _showQRCodeDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "QR CODE",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Balance Kamu",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Rp ${_formatCurrency(balance)}",
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        "Top Up",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24, thickness: 1),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildTransactionInfo(
                                      Icons.arrow_upward,
                                      "Income",
                                      income,
                                      Colors.green,
                                    ),
                                    _buildTransactionInfo(
                                      Icons.arrow_downward,
                                      "Expense",
                                      expense,
                                      Colors.red,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Tabungan Kamu",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _navigateToAddSaving,
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text("Tambah Tabungan Baru"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (savingGoals.isEmpty)
                          Column(
                            children: [
                              const Icon(
                                Icons.savings,
                                size: 60,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Belum ada tabungan",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: List.generate(
                              savingGoals.length,
                              (index) => _buildGoalCard(index),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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