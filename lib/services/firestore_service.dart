// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class FirestoreService {
  // Instance Firestore
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Nama Collection
  final String _colUsers = 'users';
  final String _colTransactions = 'transactions';
  final String _colBeneficiaries = 'beneficiaries';
  final String _colPockets = 'pockets';

  // Hash PIN (sama seperti logika lokal Anda)
  String _hashPin(String pin) {
    var bytes = utf8.encode(pin);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // ==================== USER METHODS ====================

  // Registrasi User Baru
  // Di Firestore, kita gunakan No. HP sebagai Document ID agar unik & mudah dicari
  Future<bool> registerUser(String phone, String pin) async {
    try {
      final userDoc = _db.collection(_colUsers).doc(phone);
      
      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        print('❌ User already exists in Firestore!');
        return false;
      }

      await userDoc.set({
        'phone': phone,
        'pin': _hashPin(pin),
        'balance': 0,
        'created_at': DateTime.now().toIso8601String(),
        // Field default agar tidak null saat ditampilkan pertama kali
        'first_name': 'Pengguna',
        'last_name': 'Baru',
        'email': '',
        'gender': 'Pria',
      });

      print('✅ User registered in Firestore: $phone');
      return true;
    } catch (e) {
      print('❌ Error registering user to Firestore: $e');
      return false;
    }
  }

  // Get User (Login check)
  Future<Map<String, dynamic>?> getUserByPhone(String phone) async {
    try {
      final docSnapshot = await _db.collection(_colUsers).doc(phone).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null;
    } catch (e) {
      print('❌ Error getting user: $e');
      return null;
    }
  }

  // Validasi Login
  Future<bool> validateLogin(String phone, String pin) async {
    try {
      final user = await getUserByPhone(phone);
      if (user == null) return false;

      final hashedPin = _hashPin(pin);
      return user['pin'] == hashedPin;
    } catch (e) {
      return false;
    }
  }

  // ==================== PROFILE METHODS (BARU) ====================

  // Update Data Profil User (Nama, Email, Gender)
  Future<bool> updateUserProfile({
    required String phone,
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
  }) async {
    try {
      await _db.collection(_colUsers).doc(phone).update({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'gender': gender,
        'updated_at': DateTime.now().toIso8601String(),
      });
      print('✅ Profile updated for: $phone');
      return true;
    } catch (e) {
      print('❌ Error updating profile: $e');
      return false;
    }
  }

  // Stream User Data (Untuk Real-time Update di UI Profile)
  Stream<DocumentSnapshot> getUserStream(String phone) {
    return _db.collection(_colUsers).doc(phone).snapshots();
  }

  // ==================== BALANCE & TRANSACTION METHODS ====================

  // Update Balance & Catat Transaksi (Atomic Operation dengan Batch)
  Future<bool> addTransaction({
    required String userPhone,
    required String type, // 'topup', 'transfer', dll
    required int amount,
    String? description,
    String? recipientPhone,
    String? recipientName,
  }) async {
    // Mulai Write Batch (Transaksi Database)
    WriteBatch batch = _db.batch();
    
    try {
      DocumentReference userRef = _db.collection(_colUsers).doc(userPhone);
      DocumentReference txRef = _db.collection(_colTransactions).doc(); // ID otomatis

      // Ambil data user terbaru untuk cek saldo
      DocumentSnapshot userSnap = await userRef.get();
      if (!userSnap.exists) return false;

      int currentBalance = (userSnap.data() as Map<String, dynamic>)['balance'] ?? 0;
      int newBalance = currentBalance;

      // Hitung saldo baru
      if (type == 'topup' || type == 'income') {
        newBalance += amount;
      } else {
        // Pengeluaran
        if (currentBalance < amount) {
          print('❌ Insufficient balance');
          return false; 
        }
        newBalance -= amount;
      }

      // 1. Update Saldo User
      batch.update(userRef, {'balance': newBalance});

      // 2. Buat Record Transaksi
      batch.set(txRef, {
        'user_phone': userPhone,
        'type': type,
        'amount': amount,
        'description': description,
        'recipient_phone': recipientPhone,
        'recipient_name': recipientName,
        'status': 'success',
        'created_at': DateTime.now().toIso8601String(),
        'timestamp': FieldValue.serverTimestamp(), // Untuk sorting yang akurat
      });

      // Commit semua perubahan
      await batch.commit();
      print('✅ Transaction & Balance updated in Firestore');
      return true;
    } catch (e) {
      print('❌ Transaction failed: $e');
      return false;
    }
  }

  // Get History Transaksi (Real-time Stream atau Future)
  Stream<QuerySnapshot> getTransactionStream(String phone) {
    return _db
        .collection(_colTransactions)
        .where('user_phone', isEqualTo: phone)
        .orderBy('created_at', descending: true)
        .snapshots();
  }
}