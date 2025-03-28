import 'package:flutter/material.dart';
import 'admin/admin_dashboard.dart';
import 'user/user_details.dart';
import 'blood_bank/blood_bank_dashboard.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Management System'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModuleButton(context, 'Admin Dashboard', AdminDashboard()),
            const SizedBox(height: 20),
            _buildModuleButton(context, 'User Details', UserDetailsPage()),
            const SizedBox(height: 20),
            _buildModuleButton(context, 'Blood Bank Dashboard', BloodBankDashboard()),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleButton(BuildContext context, String title, Widget page) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        backgroundColor: Colors.redAccent,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
