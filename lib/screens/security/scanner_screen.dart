import 'package:flutter/material.dart';
import 'package:joel_security_entry/database/database_helper.dart';
import 'package:joel_security_entry/widgets/student_card.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qrCodeController = TextEditingController();
  late final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Barcode result;
  bool showStudentCard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 2,
              child: showStudentCard
                  ? StudentCard(
                name: _nameController.text,
                grade: 'Grade 10', // Example grade, replace with actual data
                idNumber: '123456', // Example ID number, replace with actual data
                onConfirmCheckIn: _logCheckIn,
              )
                  : Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Student Name'),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _qrCodeController,
                    decoration: const InputDecoration(labelText: 'QR Code'),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: _manualCheckIn,
                    child: const Text('Manual Check-in'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
        showStudentCard = true;
      });

      String? scannedCode = result.code;
      Map<String, dynamic>? student = await DatabaseHelper.getStudentByQRCode(scannedCode!);

      if (student != null) {
        _nameController.text = student['name'];
        _qrCodeController.text = scannedCode;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid QR code!'),
          ),
        );
      }
    });
  }

  void _manualCheckIn() {
    String name = _nameController.text;
    String qrCode = _qrCodeController.text;

    if (name.isNotEmpty && qrCode.isNotEmpty) {
      setState(() {
        showStudentCard = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both name and QR code!'),
        ),
      );
    }
  }

  void _logCheckIn() async {
    // Log check-in time to database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Check-in logged successfully!'),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qrCodeController.dispose();
    super.dispose();
  }
}
