import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIDoctorMatch extends StatefulWidget {
  @override
  _AIDoctorMatchState createState() => _AIDoctorMatchState();
}

class _AIDoctorMatchState extends State<AIDoctorMatch> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isRequestSent = false;
  List<String> bloodTypes = [];
  String? selectedBloodType;

  @override
  void initState() {
    super.initState();
    fetchBloodTypes();
  }

  Future<void> fetchBloodTypes() async {
    final response = await http.get(Uri.parse("https://67e6848c6530dbd311104dba.mockapi.io/blood_group"));
    if (response.statusCode == 200) {
      setState(() {
        final List<dynamic> responseData = json.decode(response.body);
        bloodTypes = responseData.map((item) => item["blood_group"].toString()).toList();
      });
    } else {
      print("Error fetching blood types: ${response.statusCode}");
    }
  }

  void sendRequest() async {
    if (nameController.text.isEmpty ||
        selectedBloodType == null ||
        contactController.text.isEmpty ||
        locationController.text.isEmpty ||
        emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("needblood").add({
      "name": nameController.text,
      "bloodType": selectedBloodType,
      "contact": contactController.text,
      "location": locationController.text,
      "email": emailController.text,
      "timestamp": Timestamp.now(),
    });

    setState(() {
      isRequestSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emergency SOS"), backgroundColor: Color(0xFF0EBE7E)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter Emergency Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Your Name", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedBloodType,
              items: bloodTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBloodType = value;
                });
              },
              decoration: InputDecoration(labelText: "Blood Type Needed", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: contactController,
              decoration: InputDecoration(labelText: "Contact Number", border: OutlineInputBorder()),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: "Location", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: sendRequest,
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0EBE7E)),
                child: Text("Send Emergency Request", style: TextStyle(color: Colors.white)),
              ),
            ),
            if (isRequestSent)
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    "Your request has been sent. You will be contacted soon!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}