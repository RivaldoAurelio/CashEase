import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cashease.db');
    print('📍 Database path: $path');
    // Versi 3 untuk menambahkan tabel loans
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print('🔨 Creating database tables...');

    // Table users
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone TEXT UNIQUE NOT NULL,
        pin TEXT NOT NULL,
        balance INTEGER DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    // Table transactions
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_phone TEXT NOT NULL,
        type TEXT NOT NULL,
        amount INTEGER NOT NULL,
        description TEXT,
        recipient_phone TEXT,
        recipient_name TEXT,
        status TEXT DEFAULT 'success',
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_phone) REFERENCES users (phone)
      )
    ''');

    // Table beneficiaries
    await db.execute('''
      CREATE TABLE beneficiaries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_phone TEXT NOT NULL,
        beneficiary_name TEXT NOT NULL,
        beneficiary_phone TEXT NOT NULL,
        beneficiary_bank TEXT,
        beneficiary_account TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_phone) REFERENCES users (phone)
      )
    ''');

    // Table pockets
    await db.execute('''
      CREATE TABLE pockets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_phone TEXT NOT NULL,
        name TEXT NOT NULL,
        balance INTEGER DEFAULT 0,
        target_amount INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_phone) REFERENCES users (phone)
      )
    ''');

    // Table loans (New)
    await db.execute('''
      CREATE TABLE loans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_phone TEXT NOT NULL,
        type TEXT NOT NULL,
        amount INTEGER NOT NULL,
        term_months INTEGER NOT NULL,
        monthly_payment INTEGER NOT NULL,
        remaining_amount INTEGER NOT NULL,
        status TEXT DEFAULT 'active',
        next_due_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_phone) REFERENCES users (phone)
      )
    ''');

    print('✅ All tables created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('🔄 Upgrading database from version $oldVersion to $newVersion');

    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN balance INTEGER DEFAULT 0');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_phone TEXT NOT NULL,
          type TEXT NOT NULL,
          amount INTEGER NOT NULL,
          description TEXT,
          recipient_phone TEXT,
          recipient_name TEXT,
          status TEXT DEFAULT 'success',
          created_at TEXT NOT NULL,
          FOREIGN KEY (user_phone) REFERENCES users (phone)
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS beneficiaries (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_phone TEXT NOT NULL,
          beneficiary_name TEXT NOT NULL,
          beneficiary_phone TEXT NOT NULL,
          beneficiary_bank TEXT,
          beneficiary_account TEXT,
          created_at TEXT NOT NULL,
          FOREIGN KEY (user_phone) REFERENCES users (phone)
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS pockets (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_phone TEXT NOT NULL,
          name TEXT NOT NULL,
          balance INTEGER DEFAULT 0,
          target_amount INTEGER DEFAULT 0,
          created_at TEXT NOT NULL,
          FOREIGN KEY (user_phone) REFERENCES users (phone)
        )
      ''');
    }

    if (oldVersion < 3) {
      print('📦 Adding loans table...');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS loans (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_phone TEXT NOT NULL,
          type TEXT NOT NULL,
          amount INTEGER NOT NULL,
          term_months INTEGER NOT NULL,
          monthly_payment INTEGER NOT NULL,
          remaining_amount INTEGER NOT NULL,
          status TEXT DEFAULT 'active',
          next_due_date TEXT NOT NULL,
          created_at TEXT NOT NULL,
          FOREIGN KEY (user_phone) REFERENCES users (phone)
        )
      ''');
    }
  }

  // Hash PIN
  String _hashPin(String pin) {
    var bytes = utf8.encode(pin);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // ==================== USER METHODS ====================

  Future<bool> registerUser(String phone, String pin) async {
    try {
      final db = await database;
      final existingUser = await getUserByPhone(phone);
      if (existingUser != null) return false;

      final hashedPin = _hashPin(pin);
      await db.insert('users', {
        'phone': phone,
        'pin': hashedPin,
        'balance': 0,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('❌ Error registering user: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserByPhone(String phone) async {
    try {
      final db = await database;
      final results = await db.query('users', where: 'phone = ?', whereArgs: [phone]);
      if (results.isNotEmpty) return results.first;
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> validateLogin(String phone, String pin) async {
    try {
      final user = await getUserByPhone(phone);
      if (user == null) return false;
      return user['pin'] == _hashPin(pin);
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyPin(String phone, String pin) async {
    try {
      final db = await database;
      final results = await db.query(
        'users',
        where: 'phone = ? AND pin = ?',
        whereArgs: [phone, _hashPin(pin)],
      );
      return results.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePin(String phone, String newPin) async {
    try {
      final db = await database;
      await db.update('users', {'pin': _hashPin(newPin)}, where: 'phone = ?', whereArgs: [phone]);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ✅ Method yang sebelumnya hilang (Penyebab Error)
  Future<bool> isUserRegistered(String phone) async {
    final user = await getUserByPhone(phone);
    return user != null;
  }

  // ==================== BALANCE METHODS ====================

  Future<int> getUserBalance(String phone) async {
    try {
      final user = await getUserByPhone(phone);
      return user != null ? (user['balance'] as int? ?? 0) : 0;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> updateBalance(String phone, int newBalance) async {
    try {
      final db = await database;
      await db.update(
        'users',
        {'balance': newBalance},
        where: 'phone = ?',
        whereArgs: [phone],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addBalance(String phone, int amount, {String description = 'Top Up'}) async {
    try {
      final db = await database;
      final currentBalance = await getUserBalance(phone);
      final newBalance = currentBalance + amount;

      await db.update('users', {'balance': newBalance}, where: 'phone = ?', whereArgs: [phone]);
      await addTransaction(userPhone: phone, type: 'topup', amount: amount, description: description);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> subtractBalance(String phone, int amount, {String description = 'Payment'}) async {
    try {
      final db = await database;
      final currentBalance = await getUserBalance(phone);
      if (currentBalance < amount) return false;

      final newBalance = currentBalance - amount;
      await db.update('users', {'balance': newBalance}, where: 'phone = ?', whereArgs: [phone]);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== TRANSACTION METHODS ====================

  Future<int> addTransaction({
    required String userPhone,
    required String type,
    required int amount,
    String? description,
    String? recipientPhone,
    String? recipientName,
    String status = 'success',
  }) async {
    try {
      final db = await database;
      return await db.insert('transactions', {
        'user_phone': userPhone,
        'type': type,
        'amount': amount,
        'description': description,
        'recipient_phone': recipientPhone,
        'recipient_name': recipientName,
        'status': status,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getUserTransactions(String phone) async {
    try {
      final db = await database;
      return await db.query('transactions', where: 'user_phone = ?', whereArgs: [phone], orderBy: 'created_at DESC');
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getRecentTransactions(String phone, {int limit = 10}) async {
    try {
      final db = await database;
      return await db.query('transactions', where: 'user_phone = ?', whereArgs: [phone], orderBy: 'created_at DESC', limit: limit);
    } catch (e) {
      return [];
    }
  }

  // ==================== BENEFICIARY METHODS ====================

  Future<int> addBeneficiary({
    required String userPhone,
    required String beneficiaryName,
    required String beneficiaryPhone,
    String? beneficiaryBank,
    String? beneficiaryAccount,
  }) async {
    try {
      final db = await database;
      return await db.insert('beneficiaries', {
        'user_phone': userPhone,
        'beneficiary_name': beneficiaryName,
        'beneficiary_phone': beneficiaryPhone,
        'beneficiary_bank': beneficiaryBank,
        'beneficiary_account': beneficiaryAccount,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getUserBeneficiaries(String phone) async {
    try {
      final db = await database;
      return await db.query('beneficiaries', where: 'user_phone = ?', whereArgs: [phone], orderBy: 'created_at DESC');
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteBeneficiary(int id) async {
    try {
      final db = await database;
      final result = await db.delete('beneficiaries', where: 'id = ?', whereArgs: [id]);
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  // ==================== POCKET METHODS ====================

  Future<int> addPocket({
    required String userPhone,
    required String name,
    int balance = 0,
    int targetAmount = 0,
  }) async {
    try {
      final db = await database;
      return await db.insert('pockets', {
        'user_phone': userPhone,
        'name': name,
        'balance': balance,
        'target_amount': targetAmount,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getUserPockets(String phone) async {
    try {
      final db = await database;
      return await db.query('pockets', where: 'user_phone = ?', whereArgs: [phone], orderBy: 'created_at DESC');
    } catch (e) {
      return [];
    }
  }

  Future<bool> updatePocketBalance(int pocketId, int newBalance) async {
    try {
      final db = await database;
      await db.update('pockets', {'balance': newBalance}, where: 'id = ?', whereArgs: [pocketId]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePocket(int id) async {
    try {
      final db = await database;
      final result = await db.delete('pockets', where: 'id = ?', whereArgs: [id]);
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  // ==================== LOAN METHODS (New Feature) ====================

  Future<bool> applyLoan({
    required String userPhone,
    required String type,
    required int amount,
    required int termMonths,
  }) async {
    try {
      final db = await database;
      
      // Simulasi bunga flat 2% per bulan
      double interestRate = 0.02; 
      int totalInterest = (amount * interestRate * termMonths).round();
      int totalLoan = amount + totalInterest;
      int monthlyPayment = (totalLoan / termMonths).ceil();

      DateTime nextDue = DateTime.now().add(const Duration(days: 30));

      // 1. Catat Loan
      await db.insert('loans', {
        'user_phone': userPhone,
        'type': type,
        'amount': totalLoan,
        'term_months': termMonths,
        'monthly_payment': monthlyPayment,
        'remaining_amount': totalLoan,
        'status': 'active',
        'next_due_date': nextDue.toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });

      // 2. Cairkan Dana ke Saldo User
      await addBalance(userPhone, amount, description: 'Pencairan Pinjaman: $type');

      return true;
    } catch (e) {
      print('❌ Error applying loan: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getActiveLoans(String phone) async {
    try {
      final db = await database;
      return await db.query(
        'loans',
        where: 'user_phone = ? AND status = ?',
        whereArgs: [phone, 'active'],
        orderBy: 'created_at DESC',
      );
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> payLoanInstallment(int loanId, String phone, int amount) async {
    try {
      final db = await database;
      
      // 1. Cek saldo user
      int currentBalance = await getUserBalance(phone);
      if (currentBalance < amount) {
        return {'success': false, 'message': 'Saldo tidak cukup'};
      }

      // 2. Ambil data loan
      final loans = await db.query('loans', where: 'id = ?', whereArgs: [loanId]);
      if (loans.isEmpty) return {'success': false, 'message': 'Pinjaman tidak ditemukan'};
      
      int remaining = loans.first['remaining_amount'] as int;
      int newRemaining = remaining - amount;
      String newStatus = newRemaining <= 0 ? 'paid' : 'active';

      // 3. Kurangi Saldo User
      bool balanceUpdated = await subtractBalance(phone, amount, description: 'Bayar Cicilan Pinjaman');
      if (!balanceUpdated) return {'success': false, 'message': 'Gagal memotong saldo'};

      // 4. Catat Transaksi Pengeluaran
      await addTransaction(
        userPhone: phone, 
        type: 'expense', 
        amount: amount, 
        description: 'Pembayaran Cicilan #${loans.first['id']}'
      );

      // 5. Update Loan
      await db.update(
        'loans', 
        {
          'remaining_amount': newRemaining > 0 ? newRemaining : 0,
          'status': newStatus,
          'next_due_date': DateTime.now().add(const Duration(days: 30)).toIso8601String()
        },
        where: 'id = ?',
        whereArgs: [loanId]
      );

      return {'success': true, 'message': newStatus == 'paid' ? 'Pinjaman Lunas!' : 'Pembayaran Berhasil'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ==================== UTILITY METHODS ====================

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final db = await database;
      return await db.query('users');
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteUser(String phone) async {
    try {
      final db = await database;
      await db.delete('transactions', where: 'user_phone = ?', whereArgs: [phone]);
      await db.delete('beneficiaries', where: 'user_phone = ?', whereArgs: [phone]);
      await db.delete('pockets', where: 'user_phone = ?', whereArgs: [phone]);
      await db.delete('loans', where: 'user_phone = ?', whereArgs: [phone]); // Delete loans too
      await db.delete('users', where: 'phone = ?', whereArgs: [phone]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearAllData() async {
    try {
      final db = await database;
      await db.delete('transactions');
      await db.delete('beneficiaries');
      await db.delete('pockets');
      await db.delete('loans');
      await db.delete('users');
    } catch (e) {
      print('❌ Error clearing data: $e');
    }
  }
}