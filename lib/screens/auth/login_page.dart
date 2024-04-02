// ignore_for_file: prefer_const_constructors

import 'package:black_sigatoka/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:black_sigatoka/custom_widgets/custom_appbar.dart';
import 'package:black_sigatoka/custom_widgets/custom_button.dart';
import 'package:black_sigatoka/screens/auth/components/custom_textformfield.dart';
import 'package:black_sigatoka/screens/auth/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:black_sigatoka/utils/login/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String buttonText = 'Login';

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromRGBO(217, 217, 217, 100),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Adjust size as needed
        child: CustomAppBar(
          title: 'Login',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Log into your account',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: CustomTextFormField(
                          controller: emailController,
                          hintText: 'Enter your email',
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(CupertinoIcons.mail_solid),
                          errorMsg: _errorMsg,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please fill in this field';
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                .hasMatch(val)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          }),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: CustomTextFormField(
                        controller: passwordController,
                        hintText: 'Enter your password',
                        obscureText: obscurePassword,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(CupertinoIcons.lock_fill),
                        errorMsg: _errorMsg,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (!RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`])\%\-(_+=:;,.<>/?"[{\]}\|^]).{8,}$')
                              .hasMatch(val)) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                              if (obscurePassword) {
                                iconPassword = CupertinoIcons.eye_fill;
                              } else {
                                iconPassword = CupertinoIcons.eye_slash_fill;
                              }
                            });
                          },
                          icon: Icon(iconPassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    !signInRequired
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<SignInBloc>().add(SignInRequired(
                                  emailController.text,
                                  passwordController.text
                                  )
                                );
                              }
                            },
                            style:ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Color.fromARGB(255, 127, 181, 230)
                            ),

                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 95,
                                vertical: 15
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ),
                                                
                      )
                      : const CircularProgressIndicator(),
                  ],
                )),
            // CustomTextFormField(
            //     label: 'Enter your email', onChanged: (value) {}),
            // SizedBox(height: 16),
            // CustomTextFormField(
            //   label: 'Enter your password',
            //   // isPasswordField: true,
            //   onChanged: (value) {},
            // ),
            SizedBox(height: 16),
            CustomButton(
              text: buttonText,
              onPressed: () {},
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
                  "Don't have an account?",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()));
                  },
                  child: Text(
                    'Sign up',
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