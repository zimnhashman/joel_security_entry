import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        title: const Text('Clock-In Records Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nationalIdController,
              decoration: const InputDecoration(labelText: 'National ID'),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _saveClockInRecord();
              },
              child: const Text('Save Clock-In Record'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveClockInRecord() async {
    String nationalId = _nationalIdController.text;
    String name = _nameController.text;

    if (nationalId.isNotEmpty && name.isNotEmpty) {
      String currentDate = DateTime.now().toIso8601String();
      Map<String, dynamic> clockInRecord = {
        'nationalId': nationalId,
        'name': name,
        'clockInTime': currentDate,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? clockInRecordsJson = prefs.getStringList('clock_in_records');
      List<Map<String, dynamic>> clockInRecords =
          clockInRecordsJson?.map((json) => jsonDecode(json)).cast<Map<String, dynamic>>().toList() ?? [];
      clockInRecords.add(clockInRecord);
      await prefs.setStringList('clock_in_records', clockInRecords.map((record) => jsonEncode(record)).toList());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clock-In Record saved successfully!'),
        ),
      );

      // Clear the text fields after saving
      _nationalIdController.clear();
      _nameController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter National ID and Name!'),
        ),
      );
    }
  }
}
