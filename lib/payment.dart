import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> appointmentData;

  PaymentPage({required this.appointmentData});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isProcessing = false;

  void _processPayment() async {
    setState(() {
      isProcessing = true;
    });

    // Simulate payment delay
    await Future.delayed(Duration(seconds: 3));

    // ✅ Save full appointment (diagnose + date + time) to Firestore
    await _saveAppointmentToFirestore();

    setState(() {
      isProcessing = false;
    });

    // ✅ Show success dialog
    _showPaymentSuccessDialog();
  }

  Future<void> _saveAppointmentToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Map<String, dynamic> dataToUpload = {
        ...widget.appointmentData,
        'userId': user.uid,
        'timeZone': DateTime.now().timeZoneName,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('Appointments').add(dataToUpload);
      print('✅ Full appointment saved to Firestore after payment');
    } else {
      print('❌ User not found');
    }
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Payment Successful"),
        content: Text("Your appointment has been booked successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false,
              );
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
        backgroundColor: Color(0xFF0EBE7E),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Proceed with Payment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Icon(
              Icons.payment,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              "Select your preferred payment method to complete the booking.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0EBE7E),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: isProcessing
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Proceed to Payment", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "This is a temporary payment simulation. Remove this when integrating a real payment system.",
              style: TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
