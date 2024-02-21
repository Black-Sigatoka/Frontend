// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:black_sigatoka/screens/register_page.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () => homeButtonPressed(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Text(
          'Get Started',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

void homeButtonPressed(BuildContext context) {
  //logic for home button
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RegisterScreen(title: 'Register',)
    )
  );
}

void loginButtonPressed(BuildContext context) {
  //logic for home button
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RegisterScreen(title: 'Register',)
    )
  );
}

