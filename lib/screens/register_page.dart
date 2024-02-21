// ignore_for_file: prefer_const_constructors

import 'package:black_sigatoka/custom_widgets/custom_button.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Logo.png',
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 5),
            Center(
              child: Text(
                'Register'.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Create your account',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            CustomButton(
              text: 'Register',
              onPressed: loginButtonPressed
              ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Continue with Google button logic
              },
              icon: Icon(Icons.person),
              label: Text('Continue with Google'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                SizedBox(width: 4),
                TextButton(
                  onPressed: () {
                    // Sign in link logic
                  },
                  child: Text('Sign in'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
