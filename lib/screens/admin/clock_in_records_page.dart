import 'package:flutter/material.dart';
import 'package:joel_security_entry/database/database_helper.dart';
import 'package:joel_security_entry/models/clock_in_record.dart';
import 'package:joel_security_entry/widgets/fancy_list_tile.dart';
// Import your DatabaseHelper

class ClockInRecordsPage extends StatefulWidget {
  const ClockInRecordsPage({super.key});

  @override
  _ClockInRecordsPageState createState() => _ClockInRecordsPageState();
}

class _ClockInRecordsPageState extends State<ClockInRecordsPage> {
  late Future<List<ClockInRecord>> _clockInRecordsFuture;

  @override
  void initState() {
    super.initState();
    _fetchClockInRecords();
  }

  Future<void> _fetchClockInRecords() async {
    _clockInRecordsFuture = DatabaseHelper.getAllClockInRecords().then((List<Map<String, dynamic>> records) {
      return records.map((record) {
        return ClockInRecord(
          id: record['id'] as int?,
          studentID: record['studentID'],
          name: record['name'],
          grade: record['grade'],
          checkInTime: record['checkInTime'],
          date: record['date'],
        );
      }).toList();
    });
  }

 deconstructDate(checkInTime) {
    String dateTimeString = checkInTime;

    // Split the date and time parts
    List<String> dateTimeParts = dateTimeString.split('T');
    String datePart = dateTimeParts[0];
    String timePart = dateTimeParts[1];

    // Split the date into year, month, and day
    List<String> dateParts = datePart.split('-');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    // Split the time into hour, minute, second, and millisecond
    List<String> timeParts = timePart.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    double second = double.parse(timeParts[2].split('.')[0]);
    int millisecond = int.parse(timeParts[2].split('.')[1]);

    String simpleDateFormat = '${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-$year';
    return simpleDateFormat;
  }

  deconstructTime(checkInTime) {
    String dateTimeString = checkInTime;

    // Split the date and time parts
    List<String> dateTimeParts = dateTimeString.split('T');
    String datePart = dateTimeParts[0];
    String timePart = dateTimeParts[1];

    // Split the date into year, month, and day
    List<String> dateParts = datePart.split('-');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    // Split the time into hour, minute, second, and millisecond
    List<String> timeParts = timePart.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    double second = double.parse(timeParts[2].split('.')[0]);
    int millisecond = int.parse(timeParts[2].split('.')[1]);

    String simpleTimeFormat = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    return simpleTimeFormat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock-In Records', style: TextStyle(color: Colors.white),),
      ),
      body: FutureBuilder<List<ClockInRecord>>(
        future: _clockInRecordsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ClockInRecord> records = snapshot.data!;
            return ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                ClockInRecord record = records[index];
                return FancyListTile(
                  name: '${record.name}',
                  grade: record.grade == 'EXTERNAL' ? 'EXTERNAL' : 'Grade: ${record.grade}',
                  id: 'Student ID: ${record.studentID}',
                  time: deconstructTime(record.checkInTime),
                  date: deconstructDate(record.checkInTime),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data: ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }



}
