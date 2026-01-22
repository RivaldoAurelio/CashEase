// lib/screens/qris.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
// 🔹 Import Firestore Service
import '../services/firestore_service.dart';

class QrisPage extends StatefulWidget {
  final String? phoneNumber;
  final VoidCallback? onPaymentSuccess;

  const QrisPage({
    super.key, 
    this.phoneNumber, 
    this.onPaymentSuccess
  });

  @override
  State<QrisPage> createState() => _QrisPageState();
}

class _QrisPageState extends State<QrisPage> {
  // Controller scanner
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
    torchEnabled: false,
  );

  bool _isFlashOn = false;
  final ImagePicker _picker = ImagePicker();
  
  // 🔹 Instance Firestore
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. LAYER KAMERA (SCANNER)
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  controller.stop(); // Berhenti scan setelah dapat hasil
                  _handleScanResult(barcode.rawValue!);
                  break;
                }
              }
            },
          ),

          // 2. LAYER UI OVERLAY
          _buildOverlay(context),
        ],
      ),
    );
  }

  // 🔹 Logic Hasil Scan + Pembayaran
  void _handleScanResult(String code) {
    // Simulasi: Anggap code adalah Nama Merchant.
    // Di aplikasi nyata, biasanya code berisi string JSON/format bank.
    // Kita set harga dummy Rp 25.000 untuk simulasi.
    const int paymentAmount = 25000;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("QR Terdeteksi"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Merchant: $code"),
            const SizedBox(height: 10),
            const Text("Nominal: Rp 25.000 (Simulasi)"),
            const SizedBox(height: 20),
            const Text("Lanjut ke pembayaran?"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Tutup Dialog
              Future.delayed(const Duration(milliseconds: 500), () {
                controller.start(); // Mulai scan lagi
              });
            },
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx); // Tutup Dialog Konfirmasi
              
              if (widget.phoneNumber == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text("Error: User tidak teridentifikasi")),
                );
                return;
              }

              // 1. Tampilkan Loading
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Memproses pembayaran...")),
              );

              // 2. Proses Transaksi ke Firestore
              bool success = await _firestoreService.addTransaction(
                userPhone: widget.phoneNumber!,
                type: 'payment', // Tipe 'payment' agar muncul sebagai pengeluaran
                amount: paymentAmount,
                description: 'QRIS: $code',
                recipientName: code,
              );

              // 3. Handle Hasil
              if (success) {
                if (mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pembayaran Berhasil!"), backgroundColor: Colors.green),
                  );
                }
                
                // 🔹 Panggil callback untuk pindah ke tab History
                // Jangan pakai Navigator.pop(context) karena ini halaman TabView
                widget.onPaymentSuccess?.call();
                
              } else {
                 if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pembayaran Gagal. Saldo tidak cukup."), backgroundColor: Colors.red),
                  );
                  // Scan lagi kalau gagal
                  controller.start();
                }
              }
            },
            child: const Text("Bayar"),
          ),
        ],
      ),
    );
  }

  // 🔹 Fitur Galeri
  Future<void> _scanFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return; // Batal pilih

      final BarcodeCapture? capture = await controller.analyzeImage(image.path);

      if (capture != null && capture.barcodes.isNotEmpty) {
        final String? code = capture.barcodes.first.rawValue;
        if (code != null) {
          _handleScanResult(code);
        } else {
          _showErrorSnackBar("QR Code tidak terbaca.");
        }
      } else {
        _showErrorSnackBar("Tidak ditemukan QR Code pada gambar.");
      }
    } catch (e) {
      _showErrorSnackBar("Gagal memproses gambar.");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
  
  // 🔹 Fitur Kode Saya
  void _showMyQr() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Kode QR Saya", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Image.asset(
                  'asset/kodeqr.png', 
                  width: 200, height: 200, fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => const SizedBox(width: 200, height: 200, child: Center(child: Text("QR not found"))),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Tunjukkan kode ini untuk menerima pembayaran", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            color: Colors.deepPurple.withOpacity(0.8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tombol Back opsional (bisa dihilangkan jika tidak perlu)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                         // Panggil callback untuk pindah tab (misal kembali ke home/history)
                         // atau biarkan kosong jika user harus pakai navbar bawah
                         widget.onPaymentSuccess?.call(); 
                      },
                    ),
                    const Text('Scan QRIS', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
                      onPressed: () {
                        setState(() => _isFlashOn = !_isFlashOn);
                        controller.toggleTorch();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Fokus Area
          Container(
            width: 250, height: 250,
            decoration: BoxDecoration(border: Border.all(color: Colors.greenAccent, width: 3), borderRadius: BorderRadius.circular(20)),
            child: Center(child: Container(height: 1, color: Colors.red.withOpacity(0.5))),
          ),
          const SizedBox(height: 20),
          const Text("Arahkan kamera ke kode QR", style: TextStyle(color: Colors.white, fontSize: 14)),
          
          const Spacer(),
          
          // Bottom Actions
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.black.withOpacity(0.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomAction(icon: Icons.image, label: "Galeri", onPressed: _scanFromGallery),
                _BottomAction(icon: Icons.qr_code, label: "Kode Saya", onPressed: _showMyQr),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _BottomAction({required this.icon, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }
}