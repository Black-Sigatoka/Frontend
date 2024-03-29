// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:black_sigatoka/screens/auth/register_page.dart';
import 'package:black_sigatoka/screens/auth/login_page.dart';

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
        backgroundColor: Color.fromARGB(255, 127, 181, 230)
      ),
      onPressed: () => registerButtonPressed(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 95,
          vertical: 15
        ),
        child: Text(
          text,
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
      builder: (context) => RegisterScreen()
    )
  );
}

void registerButtonPressed(BuildContext context) {
  //logic for home button
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LoginScreen()
    )
  );
}

