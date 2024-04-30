import 'package:flutter/material.dart';
import 'package:joel_security_entry/database/database_helper.dart';
import 'package:joel_security_entry/widgets/student_card.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:math' as math;

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State
    with SingleTickerProviderStateMixin {
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _studentIdController = TextEditingController();
  late final TextEditingController _gradeController = TextEditingController();
  late final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Barcode result;
  bool showStudentCard = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showQR = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _gradeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Page', style: TextStyle(
          color: Colors.white,
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002) // Perspective
                    ..rotateY(-math.pi * _animation.value), // Rotation
                  alignment: Alignment.center,
                  child: _showQR ? _buildQRContainer() : _buildStudentCard(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRContainer() {
    return Container(
      width: 300,
      height: 300,
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  Widget _buildStudentCard() {
    return Transform.flip(
      flipX: true,
      child: StudentCard(
        name: _nameController.text,
        grade: _gradeController.text,
        idNumber: _studentIdController.text,
        onConfirmCheckIn: () => _logCheckIn(
          _nameController.text,
          _studentIdController.text,
          _gradeController.text,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
        _showQR = false; // Hide QR code container
      });

      String? scannedCode = result.code;
      _processScannedData(scannedCode!);

      // Trigger the flip animation
      _controller.forward().then((_) {
        setState(() {
          showStudentCard = true;
        });
      });
    });
  }

  void _processScannedData(String data) {
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
    String name = _nameController.text.trim();
    String studentID = _studentIdController.text.trim();
    String grade = _gradeController.text.trim();

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
      'name': name,
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

    _nameController.clear();
    _studentIdController.clear();
    _gradeController.clear();
    setState(() {
      showStudentCard = false;
    });
  }
}
