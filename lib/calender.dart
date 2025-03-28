import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'payment.dart';
import 'home_screen.dart';

class CalendarPage extends StatefulWidget {
  final Map<String, dynamic> diagnoseData;
  final bool isEditing;

  CalendarPage({required this.diagnoseData, this.isEditing = false});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _confirmAppointment() async {
    if (selectedDate != null && selectedTime != null) {
      String formattedDate = "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
      String formattedTime = selectedTime!.format(context);

      // ✅ Store locally for payment flow
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('appointmentPending', true);
      await prefs.setString('lastAppointmentDate', formattedDate);
      await prefs.setString('lastAppointmentTime', formattedTime);

      // ✅ Combine diagnoseData + date + time
      Map<String, dynamic> appointmentData = {
        ...widget.diagnoseData,
        "appointmentDate": formattedDate,
        "appointmentTime": formattedTime,
      };

      if (widget.isEditing) {
        await prefs.setBool('appointmentPending', false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // ✅ Pass data to PaymentPage for later upload to Firebase
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPage(appointmentData: appointmentData),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a date and time.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Appointment Date & Time"), backgroundColor: Color(0xFF0EBE7E)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Your Local Time Zone: ${DateTime.now().timeZoneName}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SfDateRangePickerTheme(
              data: SfDateRangePickerThemeData(),
              child: SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.single,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  setState(() {
                    selectedDate = args.value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectTime,
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0EBE7E)),
              child: Text(selectedTime == null ? "Select Time" : "Time: ${selectedTime!.format(context)}"),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _confirmAppointment,
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0EBE7E)),
              child: Text("Confirm Appointment", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
