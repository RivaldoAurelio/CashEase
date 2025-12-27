// lib/screens/home.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'beneficiary.dart';
import 'creditcard.dart';
import 'history.dart';
import 'inbox.dart';
import 'kirim_uang.dart';
import 'loan.dart';
import 'login.dart';
import 'minta_uang.dart';
import 'pocket.dart';
import 'profile.dart';
import 'qris.dart';
import 'settings.dart';
import 'taxes.dart';
import 'topup.dart';
import 'transfer.dart';
import 'withdraw.dart';

// Import AppLocalizations & Firestore
import '../l10n/app_localizations.dart';
import '../services/firestore_service.dart';

class Home extends StatefulWidget {
  final String phoneNumber;

  const Home({super.key, required this.phoneNumber});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
        HomePageContent(
          phoneNumber: widget.phoneNumber,
          onBalanceChanged: _refreshPage,
        ),
        History(phoneNumber: widget.phoneNumber),
        const QrisPage(),
        const Pocket(),
        ProfilePage(userPhone: widget.phoneNumber),
      ];

  void _refreshPage() {
    setState(() {});
  }

  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInPhone');

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => Login()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil Localization di root build agar Drawer & BottomNav ikut berubah
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: _buildNavigationDrawer(l10n),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(l10n),
    );
  }

  // ---------------------------------------------------------------------------
  // DRAWER
  // ---------------------------------------------------------------------------

  Widget _buildNavigationDrawer(AppLocalizations l10n) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'C',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'CashEase',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.phoneNumber,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          _buildDrawerItem(
            icon: Icons.home,
            title: l10n.homeTitle,
            onTap: () async {
              Navigator.pop(context);
              setState(() => _selectedIndex = 0);
            },
          ),
          _buildDrawerItem(
            icon: Icons.person,
            title: l10n.profileTitle,
            onTap: () async {
              Navigator.pop(context);
              setState(() => _selectedIndex = 4);
            },
          ),
          _buildDrawerItem(
            icon: Icons.account_balance_wallet,
            title: l10n.pocketTitle,
            onTap: () async {
              Navigator.pop(context);
              setState(() => _selectedIndex = 3);
            },
          ),
          _buildDrawerItem(
            icon: Icons.history,
            title: l10n.transactionHistory,
            onTap: () async {
              Navigator.pop(context);
              setState(() => _selectedIndex = 1);
            },
          ),

          const Divider(),
          _buildDrawerSection(l10n.services),

          _buildDrawerItem(
            icon: Icons.attach_money,
            title: l10n.send,
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => KirimUangPage(phoneNumber: widget.phoneNumber),
                ),
              );
              if (result == true) _refreshPage();
            },
          ),
          _buildDrawerItem(
            icon: Icons.request_page,
            title: l10n.request,
            onTap: () async {
              Navigator.pop(context);
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BagiUangPage()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.qr_code_scanner,
            title: 'QR Scanner',
            onTap: () async {
              Navigator.pop(context);
              setState(() => _selectedIndex = 2);
            },
          ),
          _buildDrawerItem(
            icon: Icons.atm,
            title: l10n.withdraw,
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WithdrawPage(phoneNumber: widget.phoneNumber),
                ),
              );
              if (result == true) _refreshPage();
            },
          ),

          const Divider(),
          _buildDrawerSection(l10n.financial),

          _buildDrawerItem(
            icon: Icons.receipt_long,
            title: l10n.menuTaxes,
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TaxesPage()),
              );
              if (result == true) _refreshPage();
            },
          ),
          _buildDrawerItem(
            icon: Icons.account_balance,
            title: l10n.menuLoan,
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoanPage()),
              );
              if (result == true) _refreshPage();
            },
          ),
          _buildDrawerItem(
            icon: Icons.savings,
            title: l10n.savings,
            onTap: () async {},
          ),

          const Divider(),
          _buildDrawerSection(l10n.utilities),

          _buildDrawerItem(
            icon: Icons.receipt,
            title: l10n.menuBills,
            onTap: () async {},
          ),
          _buildDrawerItem(
            icon: Icons.phone_android,
            title: l10n.mobilePrepaid,
            onTap: () async {},
          ),
          _buildDrawerItem(
            icon: Icons.mail,
            title: l10n.inbox,
            onTap: () async {
              Navigator.pop(context);
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Inbox()),
              );
            },
          ),

          const Divider(),
          _buildDrawerSection(l10n.support),

          _buildDrawerItem(
            icon: Icons.help_outline,
            title: l10n.helpSupport,
            onTap: () async {},
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: l10n.settingsTitle,
            onTap: () async {
              Navigator.pop(context);
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            title: l10n.logout,
            onTap: () async {
              Navigator.pop(context);
              _showLogoutDialog(context, l10n);
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Future<void> Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleLogout(context);
            },
            child: Text(
              l10n.logout,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM NAV
  // ---------------------------------------------------------------------------

  Widget _buildBottomNavBar(AppLocalizations l10n) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: l10n.homeTitle,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.history),
          label: l10n.transactionHistory,
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
              size: 20,
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.account_balance_wallet),
          label: l10n.pocketTitle,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: l10n.profileTitle,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// HOME HEADER & BODY
// ---------------------------------------------------------------------------

class HomePageContent extends StatelessWidget {
  final String phoneNumber;
  final VoidCallback onBalanceChanged;

  const HomePageContent({
    super.key,
    required this.phoneNumber,
    required this.onBalanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return HomeHeaderBody(
      phoneNumber: phoneNumber,
      onBalanceChanged: onBalanceChanged,
    );
  }
}

class HomeHeaderBody extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback onBalanceChanged;

  const HomeHeaderBody({
    super.key,
    required this.phoneNumber,
    required this.onBalanceChanged,
  });

  @override
  State<HomeHeaderBody> createState() => _HomeHeaderBodyState();
}

class _HomeHeaderBodyState extends State<HomeHeaderBody> {
  bool _isAmountVisible = true;
  int _currentBalance = 0;
  String _firstName = 'User';

  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final userMap =
        await _firestoreService.getUserByPhone(widget.phoneNumber);

    if (!mounted) return;

    setState(() {
      if (userMap != null) {
        _currentBalance = userMap['balance'] ?? 0;
        _firstName = userMap['first_name'] ?? 'User';
      }
      _isLoading = false;
    });
  }

  Future<void> _refreshBalance() async {
    await _loadBalance();
    widget.onBalanceChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        _buildPurpleHeader(l10n),
        Expanded(
          child: SingleChildScrollView(
            child: _buildMenuGrid(context, l10n),
          ),
        ),
      ],
    );
  }

  Widget _buildPurpleHeader(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(color: Colors.deepPurple),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.welcomeUser(_firstName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Inbox()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.mail,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  _isAmountVisible
                      ? 'Rp. ${NumberFormat('#,###', 'id_ID').format(_currentBalance)}'
                      : '••••••••••••',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () =>
                      setState(() => _isAmountVisible = !_isAmountVisible),
                  child: Icon(
                    _isAmountVisible
                        ? Icons.lock_open
                        : Icons.lock_outline,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildHeaderButtons(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButtons(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHeaderButton(Icons.add, l10n.topUp, () async {
          // [FIX] Menggunakan bool untuk cek sukses/gagal
          final success = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => TopUpPage(
                currentBalance: _currentBalance,
                phoneNumber: widget.phoneNumber,
              ),
            ),
          );
          // [FIX] Tidak perlu addTransaction lagi, cukup refresh balance
          if (success == true) {
            await _refreshBalance();
          }
        }),
        _buildHeaderButton(Icons.attach_money, l10n.send, () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => KirimUangPage(phoneNumber: widget.phoneNumber),
            ),
          );
          if (result == true) await _refreshBalance();
        }),
        _buildHeaderButton(Icons.request_page, l10n.request, () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BagiUangPage()),
          );
        }),
        _buildHeaderButton(Icons.atm, l10n.withdraw, () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WithdrawPage(phoneNumber: widget.phoneNumber),
            ),
          );
          if (result == true) await _refreshBalance();
        }),
      ],
    );
  }

  Widget _buildHeaderButton(
    IconData icon,
    String text,
    Future<void> Function() onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 5),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  void _showTaxesLoanDrawer(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.chooseOption,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.receipt_long, color: Colors.white),
              ),
              title: Text(l10n.menuTaxes,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(l10n.menuTaxesDesc),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TaxesPage()),
                );
                if (result == true) await _refreshBalance();
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance, color: Colors.white),
              ),
              title: Text(l10n.menuLoan,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(l10n.menuLoanDesc),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoanPage()),
                );
                if (result == true) await _refreshBalance();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context, AppLocalizations l10n) {
    // Definisi item menu
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.account_balance,
        'label': l10n.menuTransfer,
        'onTap': () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TransferPage(phoneNumber: widget.phoneNumber),
            ),
          );
          if (result == true) await _refreshBalance();
        },
      },
      {
        'icon': Icons.credit_card,
        'label': l10n.menuCreditCard,
        'onTap': () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreditCardPaymentPage()),
          );
          if (result == true) await _refreshBalance();
        },
      },
      {
        'icon': Icons.account_box,
        'label': l10n.menuBeneficiary,
        'onTap': () async => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BeneficiaryPage()),
        ),
      },
      {
        'icon': Icons.receipt,
        'label': l10n.menuBills,
        'onTap': () async {}, // Placeholder
      },
      {
        'icon': Icons.attach_money,
        'label': l10n.menuTaxesLoan,
        'onTap': () async => _showTaxesLoanDrawer(context, l10n),
      },
      {
        'icon': Icons.phone_android,
        'label': l10n.topUp,
        'onTap': () async {
          // [FIX] Gunakan bool
          final success = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => TopUpPage(
                currentBalance: _currentBalance,
                phoneNumber: widget.phoneNumber,
              ),
            ),
          );
          if (success == true) {
            await _refreshBalance();
          }
        },
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: GridView.builder(
        itemCount: menuItems.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          
          return GestureDetector(
            // [FIX] Casting yang lebih aman agar tidak merah
            onTap: item['onTap'] == null 
                ? null 
                : () => (item['onTap'] as Function)(),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: Colors.deepPurple, 
                    size: 30
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['label'] as String,
                  style: const TextStyle(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}