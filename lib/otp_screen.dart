import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final String email;
  final String verificationId;
  final String fullName;
  final String country;

  OTPScreen({
    required this.phoneNumber,
    required this.email,
    required this.verificationId,
    required this.fullName,
    required this.country,
  });

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String _enteredOTP = "";
  bool _isButtonEnabled = false;
  bool _isVerifying = false;

  void _verifyOTP() async {
    if (_enteredOTP.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid 6-digit OTP!")),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _enteredOTP,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      String userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection("Signup Details").doc(userId).set({
        "userId": userId,
        "fullName": widget.fullName,
        "email": widget.email,
        "phone": widget.phoneNumber,
        "country": widget.country,
        "createdAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP Verified & User Registered Successfully!")),
      );

      Future.delayed(Duration(seconds: 0), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP! Try Again.")),
      );
      setState(() {
        _isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green[700]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text("Verify OTP",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[700])),
              SizedBox(height: 10),
              Text("Enter the OTP sent to\n${widget.phoneNumber}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              SizedBox(height: 40),
              OtpTextField(
                numberOfFields: 6,
                borderColor: Colors.green,
                showFieldAsBox: true,
                onSubmit: (String otp) {
                  setState(() {
                    _enteredOTP = otp;
                    _isButtonEnabled = otp.length == 6;
                  });
                },
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isButtonEnabled && !_isVerifying ? _verifyOTP : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled ? Color(0xFF0EBE7E) : Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _isVerifying
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text("Verifying...", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ],
                  )
                      : Text("Verify", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
