import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'onboarding_screen.dart';
import 'profile_screen.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load user preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String? email = prefs.getString('loggedInUser');
  bool isProfileComplete = email != null ? prefs.getBool('profileCompleted_$email') ?? false : false;
  bool appointmentPending = prefs.getBool('appointmentPending') ?? false; // Tracks if an appointment is pending

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    isProfileComplete: isProfileComplete,
    appointmentPending: appointmentPending,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isProfileComplete;
  final bool appointmentPending;

  MyApp({required this.isLoggedIn, required this.isProfileComplete, required this.appointmentPending});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? (isProfileComplete
          ? HomeScreen() // Always go to HomeScreen now
          : ProfileScreen())
          : OnboardingScreen(),
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/profile': (context) => ProfileScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}