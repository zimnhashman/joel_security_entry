import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Import qr_flutter package for QR code generation

class GeneratedStudentCardScreen extends StatelessWidget {
  final String qrCodeData;

  const GeneratedStudentCardScreen({super.key, required this.qrCodeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Student Card'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: qrCodeData,
              version: QrVersions.auto,
              size: 200,
            ),
            const SizedBox(height: 20),
            const Text('Scan QR Code to Check-in'),
          ],
        ),
      ),
    );
  }
}
