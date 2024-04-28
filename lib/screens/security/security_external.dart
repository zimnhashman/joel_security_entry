import 'package:flutter/material.dart';
import 'package:joel_security_entry/database/database_helper.dart';

class ClockInRecordsInputPage extends StatefulWidget {
  const ClockInRecordsInputPage({Key? key}) : super(key: key);

  @override
  _ClockInRecordsInputPageState createState() => _ClockInRecordsInputPageState();
}

class _ClockInRecordsInputPageState extends State<ClockInRecordsInputPage> {
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock-In Records Input', style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10.0,),
            TextField(
              controller: _nationalIdController,
              decoration: const InputDecoration(labelText: 'National ID'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _logCheckIn(_nameController.text, _nationalIdController.text);
              },
              child: const Text('Save Clock-In Record'),
            ),
          ],
        ),
      ),
    );
  }

  void _logCheckIn(String name, String nationalID,) async {
    String currentDate = DateTime.now().toIso8601String(); // Get current date and time
    Map<String, dynamic> checkInData = {
      'studentID': nationalID,
      'name': name,
      'grade': 'EXTERNAL',
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
}
