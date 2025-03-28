import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const BloodManagementApp());
}

class BloodManagementApp extends StatelessWidget {
  const BloodManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Management App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
    );
  }
}
