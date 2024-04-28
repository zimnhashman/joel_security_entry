import 'package:flutter/material.dart';
import 'package:joel_security_entry/database/database_helper.dart';

class CustomizeStudentPage extends StatefulWidget {
  final String studentID;

  const CustomizeStudentPage({super.key, required this.studentID});

  @override
  _CustomizeStudentPageState createState() => _CustomizeStudentPageState();
}

class _CustomizeStudentPageState extends State<CustomizeStudentPage> {
  String? _studentName;
  String? _studentGrade;
  bool _isCheckInDisabled = true;

  @override
  void initState() {
    super.initState();
    // Fetch student details when the page is initialized
    _fetchStudentDetails();
  }

  Future<void> _fetchStudentDetails() async {
    // Fetch student details from the database based on the student ID
    Map<String, dynamic>? student = await DatabaseHelper.getStudentById(widget.studentID);
    if (student != null) {
      setState(() {
        _studentName = student['name'];
        _studentGrade = student['grade'];
        _isCheckInDisabled = student['isCheckInDisabled'] == 1;
      });
    }
  }

  Future<void> _updateStudentDetails() async {
    // Update student details in the database
    await DatabaseHelper.updateStudent({
      'studentID': widget.studentID,
      'name': _studentName,
      'grade': _studentGrade,
      'isCheckInDisabled': _isCheckInDisabled ? 1 : 0,
    });
    // Show a snackbar or toast to indicate successful update
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Student details updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Student', style: TextStyle(
          color: Colors.white,
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Student ID: ${widget.studentID}'),
            TextFormField(
              initialValue: _studentName,
              onChanged: (value) => _studentName = value,
              decoration: const InputDecoration(labelText: 'Student Name'),
            ),
            TextFormField(
              initialValue: _studentGrade,
              onChanged: (value) => _studentGrade = value,
              decoration: const InputDecoration(labelText: 'Grade'),
            ),
            Row(
              children: [
                const Text('Disable Check-In:'),
                Switch(
                  value: _isCheckInDisabled,
                  onChanged: (value) => setState(() => _isCheckInDisabled = value),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _updateStudentDetails,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
