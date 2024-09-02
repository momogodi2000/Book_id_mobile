import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'authen/signin_page.dart';
import 'anime.dart'; // Import the new animation widget

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    startLoading();
  }

  void startLoading() {
    Timer.periodic(const Duration(milliseconds: 40), (Timer timer) {
      setState(() {
        _progress = min(_progress + 0.01, 1.0);
      });

      if (_progress >= 1) {
        timer.cancel();
        navigateToSigninPage();
      }
    });
  }

  void navigateToSigninPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SigninPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white70],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
             Expanded(
              child: Center(
                child: WelcomeAnimation(), // Removed 'const' keyword
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: LinearPercentIndicator(
                lineHeight: 8.0,
                percent: _progress,
                backgroundColor: Colors.lightBlue,
                progressColor: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}