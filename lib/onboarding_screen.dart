import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: IntroductionScreen(
          globalBackgroundColor: Colors.transparent,
          pages: [
            PageViewModel(
              title: "Find the Best Donors",
              body: "Connecting lives,One Drop at a Time.",
              image: buildImage('assets/Blood.jpeg'),
              decoration: pageDecoration(),
            ),
            PageViewModel(
              title: "Easy Booking",
              body: "Book appointments and medical packages with ease.",
              image: buildImage('assets/images (2).jpeg'),
              decoration: pageDecoration(),
            ),
            PageViewModel(
              title: "Seamless Experience",
              body: "Enjoy a smooth blood donation experience.",
              image: buildImage('assets/images (2).jpeg'),
              decoration: pageDecoration(),
            ),
          ],
          onDone: () => goToLogin(context),
          showSkipButton: true,
          skip: buildOvalButton("Skip", () => goToLogin(context)),
          next: Builder(
            builder: (context) {
              return buildOvalButton("Next", () {
                final introScreenState = context.findAncestorStateOfType<IntroductionScreenState>();
                introScreenState?.next(); // ✅ Moves to the next slide
              });
            },
          ),
          done: buildOvalButton("Next", () => goToLogin(context)),
          onSkip: () => goToLogin(context),
          nextFlex: 0,
          dotsDecorator: DotsDecorator(
            activeColor: Color(0xFF0EBE7E),
          ),
        ),
      ),
    );
  }

  void goToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Widget buildImage(String path) {
    return Center(child: Image.asset(path, width: 200));
  }

  PageDecoration pageDecoration() {
    return PageDecoration(
      titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(fontSize: 16),
      imagePadding: EdgeInsets.all(20),
    );
  }

  Widget buildOvalButton(String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFF0EBE7E),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}