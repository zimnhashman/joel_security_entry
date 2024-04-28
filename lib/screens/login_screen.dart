import 'package:flutter/material.dart';
import 'package:joel_security_entry/screens/admin/admin_screen.dart';
import 'package:joel_security_entry/screens/security/scanner_screen.dart';
import 'package:joel_security_entry/screens/security/security_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    if (username == 'security' && password == 'security') {
      const SnackBar(
        content: Text('Security Logged In'),
        duration: Duration(seconds: 3),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SecurityDashboard()),
      );
    } else if (username == 'admin' && password == 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Administrator Logged In'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter correct credentials'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Joel Security Scanner', style: TextStyle(
            color: Colors.white,
          ),),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/trust_academy_logo.jpg',
                height: 175,
                width: 175,
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username/Email'),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


