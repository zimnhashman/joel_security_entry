import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminPage'),
      ),
      body: const Center(
        child: Text('Welcome to the Admin Page!'),
      ),
    );
  }
}
