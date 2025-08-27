import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_news_app/view/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      body: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/splash_pic.jpg',
              fit: BoxFit.cover,
              height: height * .5,
            ),
            SizedBox(height: height * .04),
            Text(
              'Top Headlines',
              style: GoogleFonts.anton(letterSpacing: .6, color: Colors.grey),
            ),
            SizedBox(height: height * .04),
            SpinKitChasingDots(color: Colors.blue, size: 40),
          ],
        ),
      ),
    );
  }
}
