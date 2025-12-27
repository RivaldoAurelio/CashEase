import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'password.dart';
import '../services/firestore_service.dart';
// 🔹 Import Localization
import '../l10n/app_localizations.dart'; 

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginComponen(); 
  }
}

class LoginComponen extends StatefulWidget {
  @override
  _LoginComponenState createState() => _LoginComponenState();
}

class _LoginComponenState extends State<LoginComponen> {
  final TextEditingController _phoneController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
  }

  void _validatePhone() {
    setState(() {
      _isValid = _phoneController.text.trim().length == 12;
    });
  }

  Future<void> _handleLogin() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.phoneError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final phone = '+62${_phoneController.text.trim()}';
    final userMap = await _firestoreService.getUserByPhone(phone);
    final isRegistered = userMap != null;

    setState(() => _isLoading = false);

    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Password(phoneNumber: phone, isNewUser: !isRegistered),
        ),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
            child: Column(
              children: [
                SizedBox(height: 40),
                Container(
                  width: 150, height: 150,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Center(
                    child: Icon(Icons.account_balance_wallet, size: 80, color: Colors.deepPurple),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  l10n.loginAppTitle,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 12),
                Text(
                  l10n.loginSubtitle,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 80),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.loginPrompt,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        l10n.loginSubPrompt,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text('+62', style: TextStyle(fontSize: 16)),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(12),
                              ],
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: l10n.phoneHint,
                              ),
                            ),
                          ),
                          Icon(
                            _phoneController.text.isEmpty || !_isValid ? Icons.cancel : Icons.check_circle,
                            color: _phoneController.text.isEmpty || !_isValid ? Colors.grey : Colors.green,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(
                                l10n.continueButton,
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}