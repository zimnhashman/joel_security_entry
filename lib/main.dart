import 'package:flutter/material.dart';
import 'package:joel_security_entry/database/database_helper.dart';
import 'package:joel_security_entry/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joel Security',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: Colors.red,
          iconTheme: IconThemeData(
            color: Colors.white, // Change the app bar icon color here
          ),
        ),
      ),
      home:  const LoginPage(),
    );
  }
}
