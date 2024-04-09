import 'package:flutter/material.dart';
import 'clock_in_records_page.dart'; // Import your Clock-In records page
import 'customize_student_page.dart'; // Import your Customize student page

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Admin Menu'),
            ),
            ListTile(
              title: const Text('Clock-In Records'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClockInRecordsPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Customize Student'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CustomizeStudentPage(studentID: '',)),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Welcome to the Admin Screen!'),
      ),
    );
  }
}
