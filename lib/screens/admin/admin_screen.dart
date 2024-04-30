import 'package:flutter/material.dart';
import 'clock_in_records_page.dart'; // Import your Clock-In records page
import 'customize_student_page.dart'; // Import your Customize student page

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen', style: TextStyle(color: Colors.white),),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Admin Menu', style: TextStyle(color:Colors.white),),
            ),
            ListTile(
              title: const Text('Clock-In Records'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClockInRecordsPage()),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 100),
                child: SizedBox(
                  width: 275,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ClockInRecordsPage()),
                      );
                    },
                    child: const Card(
                      margin: EdgeInsets.all(10),
                      color: Colors.redAccent,
                      elevation: 5.0,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.history,
                                size: 50, color: Colors.white),
                            Text(
                              'Clock-In Records',
                              style: TextStyle(
                                color: Colors.white,
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),


            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 100),
                child: SizedBox(
                  width: 275,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CustomizeStudentPage(studentID: '')),
                      );
                    },
                    child: const Card(
                      margin: EdgeInsets.all(10),
                      color: Colors.redAccent,
                      elevation: 5.0,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.edit,
                                size: 50, color: Colors.white),
                            Text(
                              'Customize Student',
                              style: TextStyle(
                                color: Colors.white,
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Handle navigation based on index
          if (index == 0) {
            // Navigate to Clock-In Records page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ClockInRecordsPage()),
            );
          } else if (index == 1) {
            // Navigate to Customize Student page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CustomizeStudentPage(studentID: '')),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Clock-In Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Customize Student',
          ),
        ],
      ),
    );
  }
}
