import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'dart:io';
import 'home_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactEmailController = TextEditingController(); // Added Contact Email field
  File? _image;
  String? loggedInUser;
  String? selectedGender;
  String countryName = "Select Country";
  List<String> genderList = ["Male", "Female", "Other"];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return;

    DocumentSnapshot userDoc = await _firestore.collection("Signup Details").doc(userId).get();
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        nameController.text = userData["fullName"] ?? "";
        phoneController.text = userData["phone"] ?? "";
        countryName = userData["country"] ?? "Select Country";
        selectedGender = userData.containsKey("gender") ? userData["gender"] : null;
        addressController.text = userData.containsKey("address") ? userData["address"] : "";
        contactEmailController.text = userData.containsKey("contactEmail") ? userData["contactEmail"] : ""; // Load contact email
      });
    }
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          countryName = country.name;
        });
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        countryName == "Select Country" ||
        selectedGender == null ||
        addressController.text.trim().isEmpty ||
        contactEmailController.text.trim().isEmpty) { // Ensure contact email is not empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = _auth.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not found! Please log in again.")),
      );
      return;
    }

    await _firestore.collection("Profile Details").doc(userId).set({
      "fullName": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "country": countryName,
      "gender": selectedGender!,
      "address": addressController.text.trim(),
      "contactEmail": contactEmailController.text.trim(), // Save contact email
      "profileCompleted": true,
    }, SetOptions(merge: true));

    await prefs.setBool('profileCompleted_$userId', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Complete Your Profile", style: TextStyle(color: Colors.green[700])),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green[700]),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? Icon(Icons.camera_alt, size: 30) : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: contactEmailController,
              decoration: InputDecoration(
                labelText: "Contact Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
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
                      countryName,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.green),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedGender,
              items: genderList.map((gender) {
                return DropdownMenuItem(value: gender, child: Text(gender));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0EBE7E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text("Save & Continue", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}