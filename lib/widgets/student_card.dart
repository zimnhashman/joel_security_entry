import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final String name;
  final String grade;
  final String idNumber;
  final VoidCallback onConfirmCheckIn;

  const StudentCard({
    required this.name,
    required this.grade,
    required this.idNumber,
    required this.onConfirmCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Grade: $grade'),
            Text('ID Number: $idNumber'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onConfirmCheckIn,
              child: const Text('Confirm Check-in'),
            ),
          ],
        ),
      ),
    );
  }
}
