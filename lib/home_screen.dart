import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'chatbot_screen.dart';
import 'health_tips_service.dart';
import 'Homescreen/appointment_history.dart';
import 'Homescreen/home_profile.dart';
import 'Homescreen/notification.dart';
import 'Homescreen/help_support.dart';
import 'Homescreen/privacy.dart';
import 'Homescreen/settings.dart';
import 'quick_diagnose.dart';
import 'ai_doctor_match.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<dynamic> pastAppointments = [];
  String healthTip = "Loading health tip...";
  String? lastAppointmentDate;
  String? lastAppointmentTime;

  String? userName;
  String? userEmail;
  String? userProfileUrl;
  bool isLoadingUser = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
    fetchHealthTip();
    fetchSavedAppointment();
    fetchUserDetails();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat(reverse: true);
  }

  Future<void> fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("Profile Details").doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          userName = userData["fullName"] ?? "User Name";
          userEmail = userData["contactEmail"] ?? "user@example.com";
          userProfileUrl = userData["profileImageUrl"];
          isLoadingUser = false;
        });
      }
    }
  }

  Future<void> fetchAppointments() async {
    try {
      // Dummy API call
      setState(() {
        pastAppointments = []; // Replace with actual API
      });
    } catch (e) {
      print("Error fetching appointments: $e");
    }
  }

  Future<void> fetchHealthTip() async {
    try {
      String tip = await HealthTipsService().fetchHealthTip();
      setState(() {
        healthTip = tip;
      });
    } catch (e) {
      print("Error fetching health tip: $e");
    }
  }

  Future<void> fetchSavedAppointment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lastAppointmentDate = prefs.getString('lastAppointmentDate');
      lastAppointmentTime = prefs.getString('lastAppointmentTime');
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedInUser = prefs.getString('loggedInUser');
    if (loggedInUser != null) {
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('loggedInUser');
      await prefs.remove('profileCompleted_$loggedInUser');
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
  }

  void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  Widget _buildHomeButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildFixedHeightBox(String title, Widget content) {
    return Container(
      height: 150,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Expanded(child: content),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            isLoadingUser
                ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: UserAccountsDrawerHeader(
                accountName: Text("Loading..."),
                accountEmail: Text("Loading..."),
                currentAccountPicture: CircleAvatar(backgroundColor: Colors.white),
                decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0EBE7E), Colors.green])),
              ),
            )
                : UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF0EBE7E), Colors.green]),
                boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 20, spreadRadius: 2)],
              ),
              accountName: Text(userName ?? "User Name"),
              accountEmail: Text(userEmail ?? "user@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: userProfileUrl != null ? NetworkImage(userProfileUrl!) : AssetImage('assets/profile_image.png') as ImageProvider,
              ),
            ),
            ListTile(leading: Icon(Icons.settings), title: Text("Settings"), onTap: () => navigateTo(context, SettingsScreen())),
            ListTile(leading: Icon(Icons.person), title: Text("Profile"), onTap: () => navigateTo(context, HomeProfileScreen())),
            ListTile(leading: Icon(Icons.notifications), title: Text("Notifications"), onTap: () => navigateTo(context, NotificationScreen())),
            ListTile(leading: Icon(Icons.history), title: Text("Appointment History"), onTap: () => navigateTo(context, AppointmentHistoryScreen())),
            ListTile(leading: Icon(Icons.help), title: Text("Help & Support"), onTap: () => navigateTo(context, HelpSupportScreen())),
            ListTile(leading: Icon(Icons.privacy_tip), title: Text("Privacy Policy"), onTap: () => navigateTo(context, PrivacyScreen())),
            ListTile(leading: Icon(Icons.logout), title: Text("Logout"), onTap: () => _logout(context)),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF0EBE7E),
        title: Text("Home", style: TextStyle(color: Colors.white)),
        leading: GestureDetector(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundImage: userProfileUrl != null ? NetworkImage(userProfileUrl!) : AssetImage('assets/profile_image.png') as ImageProvider,
            ),
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.logout, color: Colors.white), onPressed: () => _logout(context)),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white, Colors.green.shade100]),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            if (!isLoadingUser) Text("Welcome, ${userName ?? "User"}!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(image: AssetImage('assets/images (2).jpeg'), fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHomeButton(context, "Book an Appointment", Icons.health_and_safety, Colors.green.shade700, () => navigateTo(context, QuickDiagnose())),
                SizedBox(width: 20),
                _buildHomeButton(context, "Blood SOS", Icons.medical_services, Colors.red.shade700, () => navigateTo(context, AIDoctorMatch())),
              ],
            ),
            SizedBox(height: 30),
            _buildFixedHeightBox("Past Appointments", Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (lastAppointmentDate != null && lastAppointmentTime != null)
                  Text("Appointment: $lastAppointmentDate at $lastAppointmentTime", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                if (pastAppointments.isEmpty)
                  Text("No past appointments found.", style: TextStyle(fontSize: 16)),
                ...pastAppointments.map((appointment) => Text(appointment.toString())).toList(),
              ],
            )),
            _buildFixedHeightBox("Health Tip", Text(healthTip, style: TextStyle(fontSize: 16))),
            Spacer(),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: Tween(begin: 0.9, end: 1.1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)),
        child: FloatingActionButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotScreen())),
          backgroundColor: Colors.green,
          child: Icon(Icons.chat, color: Colors.white),
        ),
      ),
    );
  }
}
