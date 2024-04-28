import 'package:flutter/material.dart';
import 'package:joel_security_entry/database/database_helper.dart'; // Import your database helper
import 'package:joel_security_entry/models/clock_in_record.dart'; // Import your clock-in records model

class ClockInRecordsPage extends StatefulWidget {
  const ClockInRecordsPage({super.key});

  @override
  _ClockInRecordsPageState createState() => _ClockInRecordsPageState();
}

class _ClockInRecordsPageState extends State<ClockInRecordsPage> {
  List<ClockInRecord> _clockInRecords = [];
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7)); // Default start date
  DateTime _endDate = DateTime.now(); // Default end date

  @override
  void initState() {
    super.initState();
    _fetchClockInRecords();
  }

  Future<void> _fetchClockInRecords()  async {
    List<Map<String, dynamic>> records =  await DatabaseHelper.getAllClockInRecords();
    List<ClockInRecord> clockInRecords = records.map((record) {
      return ClockInRecord(
        studentName: record['studentName'],
        clockInTime: record['clockInTime'],
        date: record['date'],
      );
    }).toList();

    setState(() {
      _clockInRecords = clockInRecords;
    });
  }

  void _filterRecords(DateTime startDate, DateTime endDate) {
    List<ClockInRecord> filteredRecords = _clockInRecords.where((record) {
      DateTime recordDate = DateTime.parse(record.date);
      return recordDate.isAfter(startDate) && recordDate.isBefore(endDate);
    }).toList();

    setState(() {
      _clockInRecords = filteredRecords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock-In Records', style: TextStyle(
          color: Colors.white,
        ),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showDatePicker(context, true); // Show start date picker
                  },
                  child: Text('Start Date: ${_startDate.toString().split(' ')[0]}'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showDatePicker(context, false); // Show end date picker
                  },
                  child: Text('End Date: ${_endDate.toString().split(' ')[0]}'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _filterRecords(_startDate, _endDate); // Apply filter
                  },
                  child: const Text('Apply Filter'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _clockInRecords.length,
              itemBuilder: (context, index) {
                ClockInRecord record = _clockInRecords[index];
                return ListTile(
                  title: Text(record.studentName),
                  subtitle: Text('Clock-In Time: ${record.clockInTime} - Date: ${record.date}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context, bool isStartDate) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }
}
