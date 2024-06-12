import 'package:black_sigatoka/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:black_sigatoka/screens/diagnosis_page.dart';
import 'package:black_sigatoka/screens/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          return DiagnosisScreen();
        } else {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      height: 150,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Black Leaf Streak Diagnosis'
                          .toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Mobile Application'
                          .toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'This is a mobile application dedicated to diagnosing and managing Black Leaf Streak efficiently. It harnesses advanced image recognition to identify disease symptoms. The application provides detailed information about the severity of the disease and recommended actions.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 127, 181, 230)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 95, vertical: 15),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
