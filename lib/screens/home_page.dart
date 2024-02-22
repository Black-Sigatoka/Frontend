// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:black_sigatoka/custom_widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Logo.png',
              height: 150,         
            ),
            const SizedBox(height: 20),
            Text(
              'Sigatoka Mobile Application'.toUpperCase(),
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 25),
            const Text(
              'This is a mobile application dedicated to diagnosing and managing Black Leaf Streak efficiently. It harnesses advanced image recognition to identify disease symptoms. The applications provide detailed information about the severity of the disease and recommended actions.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            CustomButton(
              onPressed: homeButtonPressed,
              text: 'Get Started',
            ),
          ],
        ),
      ),
    );
  }
}
