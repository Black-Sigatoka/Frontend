// ignore_for_file: prefer_const_constructors

import 'package:black_sigatoka/custom_widgets/custom_appbar.dart';
import 'package:black_sigatoka/custom_widgets/custom_button.dart';
//import 'package:black_sigatoka/screens/auth/components/custom_textformfield.dart';
import 'package:black_sigatoka/screens/auth/login_page.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  final String buttonText = 'Register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromRGBO(217, 217, 217, 100),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Adjust size as needed
        child: CustomAppBar(
          title: 'Register',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Create your account',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            // CustomTextFormField(
            //   label: 'Enter your full name',
            //   onChanged: (value) {
            //     //handles changes to the text form field
            //   },
            // ),
            SizedBox(height: 16),
            // CustomTextFormField(
            //   label: 'Enter your email',
            //   onChanged: (value) {},
            // ),
            // SizedBox(height: 16),
            // CustomTextFormField(
            //   label: 'Enter your passsword',
            //   onChanged: (value) {},
            // ),
            // SizedBox(height: 16),
            // CustomTextFormField(
            //   label: 'Confirm Password',
            //   onChanged: (value) {},
            // ),
            SizedBox(height: 16),
            CustomButton(
              text: buttonText,
              onPressed: loginButtonPressed,
            ),
            SizedBox(height: 16),
            Text(
              'Or',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.white),
              onPressed: () => homeButtonPressed(context),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 45,
                  vertical: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/google_icon.png',
                      height: 25,
                      width: 25,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Continue with Google',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Color.fromARGB(255, 127, 181, 230)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
