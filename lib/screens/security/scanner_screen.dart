import 'package:flutter/material.dart';
import 'package:joel_security_entry/database/database_helper.dart';
import 'package:joel_security_entry/widgets/student_card.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
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
                grade: _gradeController.text,
                idNumber: _studentIdController.text,
                onConfirmCheckIn: () => _logCheckIn(
                  _nameController.text,
                  _studentIdController.text,
                  _gradeController.text,
                ),
              )
                  : Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Student Name'),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _studentIdController,
                    decoration: const InputDecoration(labelText: 'Student ID'),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _gradeController,
                    decoration: const InputDecoration(labelText: 'Grade'),
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
      _processScannedData(scannedCode!);
    });
  }

  void _processScannedData(String data) {
    // Assuming the data format is "Name-StudentID-Grade"
    List<String> parts = data.split('-');

    if (parts.length == 3) {
      String name = parts[0];
      String studentID = parts[1];
      String grade = parts[2];

      setState(() {
        _nameController.text = name;
        _studentIdController.text = studentID;
        _gradeController.text = grade;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid QR code format!'),
        ),
      );
    }
  }

  void _manualCheckIn() {
    String name = _nameController.text;
    String studentID = _studentIdController.text;
    String grade = _gradeController.text;

    if (name.isNotEmpty && studentID.isNotEmpty && grade.isNotEmpty) {
      setState(() {
        showStudentCard = true;
      });

      _logCheckIn(name, studentID, grade);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter name, student ID, and grade!'),
        ),
      );
    }
  }

  void _logCheckIn(String name, String studentID, String grade) async {
    String currentDate = DateTime.now().toIso8601String(); // Get current date and time
    Map<String, dynamic> checkInData = {
      'studentID': studentID,
      'grade': grade,
      'checkInTime': currentDate,
      'date': DateTime.now().toString().split(' ')[0], // Get current date
    };

    await DatabaseHelper.insertCheckIn(checkInData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Check-in logged successfully!'),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _gradeController.dispose();
    super.dispose();
  }
}
