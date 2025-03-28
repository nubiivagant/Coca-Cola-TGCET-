import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'book_appointment.dart'; // Import the new page
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class SummaryPage extends StatelessWidget {
  final Map<String, dynamic> formData;
  final List<PlatformFile> uploadedFiles;

  SummaryPage({required this.formData, required this.uploadedFiles});

  Future<void> saveData(BuildContext context) async {
    // Uncomment when Firebase is ready
    /*
    await FirebaseFirestore.instance.collection('patients').add({
      "fullName": formData["fullName"],
      "age": formData["age"],
      "gender": formData["gender"],
      "country": formData["country"],
      "phone": formData["phone"],
      "email": formData["email"],
      "condition": formData["condition"],
      "severity": formData["severity"],
      "chronicConditions": formData["chronicConditions"],
      "allergies": formData["allergies"],
      "medications": formData["medications"],
      "files": uploadedFiles.map((file) => file.name).toList(),
    });
    */

    print("Data saved (Firebase code commented out).");

    // Navigate to BookAppointmentPage after saving data
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookAppointmentPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Summary"),
        backgroundColor: Color(0xFF0EBE7E),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Please review your details before confirming.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: formData.entries.map((entry) {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        entry.key,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(entry.value.toString()),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 10),
            Text("Uploaded Files:", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: uploadedFiles.map((file) {
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Icon(Icons.insert_drive_file, color: Colors.blue),
                    title: Text(file.name),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await saveData(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0EBE7E),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}