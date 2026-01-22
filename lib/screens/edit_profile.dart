import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
// 🔹 Import Localization
import '../l10n/app_localizations.dart';

class EditProfile extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String gender;

  const EditProfile({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.gender,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirestoreService _firestoreService = FirestoreService();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  String _selectedGender = 'Pria';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _emailController = TextEditingController(text: widget.email);
    _selectedGender = widget.gender;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile(AppLocalizations l10n) async {
    setState(() => _isLoading = true);
    bool success = await _firestoreService.updateUserProfile(
      phone: widget.phoneNumber,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      gender: _selectedGender,
    );
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.success), backgroundColor: Colors.green));
      Navigator.pop(context); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.failed), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Ambil l10n
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(color: Colors.deepPurple.shade100, shape: BoxShape.circle, border: Border.all(color: Colors.deepPurple, width: 2)),
                child: const Icon(Icons.person, size: 60, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(controller: _firstNameController, label: l10n.firstName, icon: Icons.person_outline),
            const SizedBox(height: 15),
            _buildTextField(controller: _lastNameController, label: l10n.lastName, icon: Icons.person_outline),
            const SizedBox(height: 15),
            TextField(
              readOnly: true,
              controller: TextEditingController(text: widget.phoneNumber),
              decoration: InputDecoration(
                labelText: l10n.phoneNumber, // "Nomor Telepon"
                prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true, fillColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 15),
            _buildTextField(controller: _emailController, label: l10n.email, icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 15),
            // Gender Dropdown (Simpel, jika mau ditranslate bisa pakai logika l10n)
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              onChanged: (val) => setState(() => _selectedGender = val!),
              items: ['Pria', 'Wanita'].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _saveProfile(l10n),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(l10n.save, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.deepPurple, width: 2)),
      ),
    );
  }
}