import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'calender.dart'; // <-- change to your actual calendar page import
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuickDiagnose extends StatefulWidget {
  @override
  _QuickDiagnoseState createState() => _QuickDiagnoseState();
}

class _QuickDiagnoseState extends State<QuickDiagnose> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController specifyConditionController = TextEditingController();
  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController treatmentController = TextEditingController();
  final TextEditingController surgeriesController = TextEditingController();
  final TextEditingController chronicConditionsController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController medicationsController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController otherDetailsController = TextEditingController();

  List<String> conditions = [];
  String? selectedCondition;
  List<String> severityLevels = ["None","Mild", "Moderate", "Severe"];
  String? selectedSeverity;
  List<PlatformFile> uploadedFiles = [];
  bool hasWorseningSymptoms = false;
  bool hasPreviousDiagnosis = false;
  bool hasCurrentTreatment = false;
  bool hasPreviousSurgeries = false;
  bool hasDoctorPreference = false;

  @override
  void initState() {
    super.initState();
    fetchConditions();
  }

  Future<void> fetchConditions() async {
    final response = await http.get(Uri.parse("https://67e6848c6530dbd311104dba.mockapi.io/blood_group"));
    if (response.statusCode == 200) {
      setState(() {
        final List<dynamic> responseData = json.decode(response.body);
        conditions = responseData.map((item) => item["blood_group"].toString()).toList();
      });
    } else {
      print("Error fetching conditions: ${response.statusCode}");
    }
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'docx'],
    );

    if (result != null && uploadedFiles.length + result.files.length <= 20) {
      setState(() {
        uploadedFiles.addAll(result.files);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quick Diagnose"), backgroundColor: Color(0xFF0EBE7E)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (value) => value == null || value.isEmpty ? "Full Name is required" : null,
              ),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Age is required";
                  if (int.tryParse(value) == null || int.parse(value) <= 0) return "Enter a valid age";
                  return null;
                },
              ),
              TextFormField(
                controller: genderController,
                decoration: InputDecoration(labelText: "Gender"),
                validator: (value) => value == null || value.isEmpty ? "Gender is required" : null,
              ),
              TextFormField(
                controller: countryController,
                decoration: InputDecoration(labelText: "Address"),
                validator: (value) => value == null || value.isEmpty ? "Address is required" : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Phone number is required";
                  if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) return "Enter a valid phone number";
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Email is required";
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Enter a valid email";
                  return null;
                },
              ),

              SizedBox(height: 20),
              Text("Medical Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButtonFormField(
                isExpanded: true,
                menuMaxHeight: 300,
                value: selectedCondition,
                items: conditions.map((condition) => DropdownMenuItem(value: condition, child: Text(condition))).toList(),
                onChanged: (value) => setState(() => selectedCondition = value as String),
                decoration: InputDecoration(labelText: "Blood Group"),
                validator: (value) => value == null ? "Blood Group" : null,
              ),
              TextFormField(controller: specifyConditionController, decoration: InputDecoration(labelText: "Any disease")),
              CheckboxListTile(
                title: Text("Worsening Symptoms?"),
                value: hasWorseningSymptoms,
                onChanged: (val) => setState(() => hasWorseningSymptoms = val!),
              ),
              if (hasWorseningSymptoms)
                TextFormField(
                  controller: symptomsController,
                  decoration: InputDecoration(labelText: "Describe Symptoms"),
                  validator: (value) => value == null || value.isEmpty ? "Symptom description is required" : null,
                ),

              DropdownButtonFormField(
                value: selectedSeverity,
                items: severityLevels.map((level) => DropdownMenuItem(value: level, child: Text(level))).toList(),
                onChanged: (value) => setState(() => selectedSeverity = value as String),
                decoration: InputDecoration(labelText: "Severity"),
                validator: (value) => value == null ? "Severity level is required" : null,
              ),

              CheckboxListTile(
                title: Text("Current Treatment"),
                value: hasPreviousDiagnosis,
                onChanged: (val) => setState(() => hasPreviousDiagnosis = val!),
              ),
              if (hasPreviousDiagnosis)
                TextFormField(
                  controller: diagnosisController,
                  decoration: InputDecoration(labelText: "Specify Treatment"),
                  validator: (value) => value == null || value.isEmpty ? "Diagnosis details are required" : null,
                ),
              CheckboxListTile(
                title: Text("Have you donated blood before?"),
                value: hasCurrentTreatment,
                onChanged: (val) => setState(() => hasCurrentTreatment = val!),
              ),
              if (hasCurrentTreatment)
                TextFormField(
                  controller: treatmentController,
                  decoration: InputDecoration(labelText: "Specify Date"),
                  validator: (value) => value == null || value.isEmpty ? "Treatment details are required" : null,
                ),

              SizedBox(height: 20),
              Text("Health History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: Text("Previous surgeries/treatments?"),
                value: hasPreviousSurgeries,
                onChanged: (val) => setState(() => hasPreviousSurgeries = val!),
              ),
              if (hasPreviousSurgeries) TextFormField(controller: surgeriesController, decoration: InputDecoration(labelText: "Details of Surgeries/Treatments")),

              TextFormField(controller: chronicConditionsController, decoration: InputDecoration(labelText: "Existing Chronic Conditions")),
              TextFormField(controller: allergiesController, decoration: InputDecoration(labelText: "Allergies")),
              TextFormField(controller: medicationsController, decoration: InputDecoration(labelText: "Current Medications")),
              SizedBox(height: 20),

              Text("Medical Reports Upload", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(onPressed: pickFiles, child: Text("Upload Files")),
              if (uploadedFiles.isNotEmpty) ...uploadedFiles.map((file) => Text(file.name)).toList(),
              SizedBox(height: 20),

              Text("Additional Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(controller: languageController, decoration: InputDecoration(labelText: "Preferred Language for Consultation")),
              CheckboxListTile(
                title: Text("Any specific doctor preference?"),
                value: hasDoctorPreference,
                onChanged: (val) => setState(() => hasDoctorPreference = val!),
              ),
              if (hasDoctorPreference) TextFormField(controller: doctorController, decoration: InputDecoration(labelText: "Specify Doctor")),
              TextFormField(controller: otherDetailsController, decoration: InputDecoration(labelText: "Other relevant details")),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> diagnoseData = {
                      "fullName": fullNameController.text,
                      "age": ageController.text,
                      "gender": genderController.text,
                      "country": countryController.text,
                      "phone": phoneController.text,
                      "email": emailController.text,
                      "condition": selectedCondition ?? "Not provided",
                      "specifyCondition": specifyConditionController.text,
                      "severity": selectedSeverity ?? "Not provided",
                      "worseningSymptoms": hasWorseningSymptoms,
                      "symptomsDescription": symptomsController.text,
                      "previousDiagnosis": hasPreviousDiagnosis,
                      "diagnosisDetails": diagnosisController.text,
                      "currentTreatment": hasCurrentTreatment,
                      "treatmentDetails": treatmentController.text,
                      "previousSurgeries": hasPreviousSurgeries,
                      "surgeriesDetails": surgeriesController.text,
                      "chronicConditions": chronicConditionsController.text,
                      "allergies": allergiesController.text,
                      "medications": medicationsController.text,
                      "preferredLanguage": languageController.text,
                      "doctorPreference": hasDoctorPreference,
                      "preferredDoctor": doctorController.text,
                      "otherDetails": otherDetailsController.text,
                      "filesCount": uploadedFiles.length,
                    };
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalendarPage(diagnoseData: diagnoseData),
                      ),
                    );
                  }
                },
                child: Text("Next"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0EBE7E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
