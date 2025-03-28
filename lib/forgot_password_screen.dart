import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool showOTPField = false;
  bool showNewPasswordField = false;
  String enteredOTP = "";

  void _submitEmail() {
    setState(() {
      showOTPField = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("OTP sent to ${emailController.text}")),
    );
  }

  void _verifyOTP(String otp) {
    if (otp.length == 6) {
      setState(() {
        showNewPasswordField = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP Verified Successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP! Try Again.")),
      );
    }
  }

  void _resetPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Password reset successfully!")),
    );
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
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
              Text("Forgot Password",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[700])),
              SizedBox(height: 20),
              if (!showOTPField)
                Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Enter Email",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(Icons.email, color: Colors.green),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0EBE7E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              if (showOTPField && !showNewPasswordField)
                Column(
                  children: [
                    SizedBox(height: 20),
                    Text("Enter OTP sent to ${emailController.text}",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                    SizedBox(height: 20),
                    OtpTextField(
                      numberOfFields: 6,
                      borderColor: Colors.green,
                      showFieldAsBox: true,
                      onSubmit: (String otp) {
                        _verifyOTP(otp);
                      },
                    ),
                  ],
                ),
              if (showNewPasswordField)
                Column(
                  children: [
                    SizedBox(height: 20),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "New Password",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(Icons.lock, color: Colors.green),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(Icons.lock, color: Colors.green),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0EBE7E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text("Reset Password", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}