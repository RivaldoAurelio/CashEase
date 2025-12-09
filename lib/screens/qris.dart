import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // Tambahan

class QrisPage extends StatefulWidget {
  const QrisPage({super.key});

  @override
  State<QrisPage> createState() => _QrisPageState();
}

class _QrisPageState extends State<QrisPage> {
  // Controller scanner
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  bool _isFlashOn = false;

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

  void _handleScanResult(String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("QR Terdeteksi"),
        content: Text("Isi Kode: $code\n\nLanjut ke pembayaran?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.start(); // Scan lagi
            },
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Memproses pembayaran...")),
              );
              // Disini bisa navigasi ke halaman bayar atau kembali
              Navigator.pop(context); 
            },
            child: const Text("Bayar"),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header Purple
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            color: Colors.deepPurple.withOpacity(0.8), // Transparan dikit
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Scan QRIS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isFlashOn ? Icons.flash_on : Icons.flash_off, 
                        color: Colors.white
                      ),
                      onPressed: () {
                        setState(() {
                          _isFlashOn = !_isFlashOn;
                        });
                        controller.toggleTorch();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Kotak Fokus Scan
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent, width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Container(
                height: 1, 
                color: Colors.red.withOpacity(0.5), // Garis merah simulasi laser
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Arahkan kamera ke kode QR",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),

          const Spacer(),

          // Bottom Actions
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.black.withOpacity(0.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomAction(
                  icon: Icons.image,
                  label: "Galeri",
                  onPressed: () async {
                    // Logic ambil dari galeri (butuh integrasi ImagePicker + MobileScanner analyzeImage)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fitur Galeri belum aktif")),
                    );
                  },
                ),
                _BottomAction(
                  icon: Icons.qr_code,
                  label: "Kode Saya",
                  onPressed: () {
                     // Tampilkan kode QR user
                  },
                ),
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

  const _BottomAction({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }
}