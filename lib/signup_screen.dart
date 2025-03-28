import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'otp_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Country? selectedCountry;
  String countryCode = "+91"; // Default country code
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSigningUp = false;

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country;
        });
      },
    );
  }

  void _signUp() async {
    String fullName = nameController.text.trim();
    String phoneNumber = countryCode + phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (fullName.isEmpty || phoneController.text.isEmpty || email.isEmpty || password.isEmpty || selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all details")),
      );
      return;
    }

    setState(() {
      _isSigningUp = true; // Show "Signing Up..." on button
    });

    try {
      // ✅ Send OTP first (Don't wait for account creation)
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          print("Phone verification completed automatically");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification Failed: ${e.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("OTP Verification Failed: ${e.message}")),
          );
          setState(() {
            _isSigningUp = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          // ✅ Move to OTP screen immediately after OTP is sent
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                phoneNumber: phoneNumber,
                email: email,
                verificationId: verificationId,
                fullName: fullName,
                country: selectedCountry!.name,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Code retrieval timeout");
        },
      );

      // ✅ Create user account AFTER OTP screen is loaded (not before)
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: ${e.toString()}")),
      );
      setState(() {
        _isSigningUp = false; // Re-enable signup button
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text("Create Account",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[700])),
                SizedBox(height: 10),
                Text("Sign up to get started", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                SizedBox(height: 40),

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.person, color: Colors.green),
                  ),
                ),
                SizedBox(height: 20),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.email, color: Colors.green),
                  ),
                ),
                SizedBox(height: 20),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.lock, color: Colors.green),
                  ),
                ),
                SizedBox(height: 30),

                // Select User's Country (No Phone Code)
                GestureDetector(
                  onTap: _selectCountry,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedCountry != null ? selectedCountry!.name : "Select Country",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.green),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Phone Number with Country Code
                IntlPhoneField(
                  controller: phoneController,
                  initialCountryCode: 'IN',
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (phone) {
                    setState(() {
                      countryCode = phone.countryCode;
                    });
                  },
                ),
                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSigningUp ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSigningUp ? Colors.grey : Color(0xFF0EBE7E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: _isSigningUp
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        ),
                        SizedBox(width: 10),
                        Text("Signing Up...", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ],
                    )
                        : Text("Sign Up", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
