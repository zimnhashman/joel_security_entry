import 'package:flutter/material.dart';
import 'package:joel_security_entry/screens/security/scanner_screen.dart';
import 'package:joel_security_entry/screens/security/security_external.dart';


class SecurityDashboard extends StatefulWidget {
  const SecurityDashboard({super.key});

  @override
  State<SecurityDashboard> createState() => _SecurityDashboardState();
}

class _SecurityDashboardState extends State<SecurityDashboard> {

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Dashboard', style: TextStyle(color: Colors.white),),
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
                        MaterialPageRoute(builder: (context) => const SecurityPage()),
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
                              'Internal Check In',
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
                        MaterialPageRoute(builder: (context) => const ClockInRecordsInputPage()),
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
                              'External Check-In',
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
              MaterialPageRoute(builder: (context) => const SecurityPage()),
            );
          } else if (index == 1) {
            // Navigate to Customize Student page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ClockInRecordsInputPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Internal Check-In',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'External Check-In',
          ),
        ],
      ),
    );
  }
}
