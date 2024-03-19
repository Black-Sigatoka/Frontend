// ignore_for_file: prefer_const_constructors

import 'package:black_sigatoka/custom_widgets/custom_appbar.dart';
import 'package:black_sigatoka/custom_widgets/custom_button.dart';
import 'package:black_sigatoka/custom_widgets/custom_textformfield.dart';
import 'package:black_sigatoka/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:black_sigatoka/utils/login/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String buttonText = 'Login';

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
  }

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }

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
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),

        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Handle validation errors
              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state.errors.isNotEmpty) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('Fix the following errors:'),
                        ),
                   );
                  }
                },
              ),

              //Handle login success
              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state.errors.isEmpty) {
                    //Navigate to home screen
                    Navigator.pushNamed(context, '/home');
                  }
                },
              ),
              
              SizedBox(height: 20),
              Text(
                'Log into your account',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                label: 'Enter your email',
                onChanged: (value) => BlocProvider.of<LoginBloc>(context).add(LoginUsernameChanged(value)),
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                label: 'Enter your password',
                // isPasswordField: true,
                onChanged: (value) => BlocProvider.of<LoginBloc>(context).add(LoginPasswordChanged(value)),
              ),
              SizedBox(height: 16),
              CustomButton(
                text: buttonText,
                onPressed: () {
                  //Get the current state of the login bloc
                  final state = BlocProvider.of<LoginBloc>(context).state;

                  if (state.isValid) {
                    //if the form is valid, emit the LoginSubmitted event
                    BlocProvider.of<LoginBloc>(context).add(LoginSubmitted(username: state.username, password: state.password));
                  }
                  else {
                    //if the form is invalid, emit the LoginError event
                    BlocProvider.of<LoginBloc>(context).add(LoginError());
                  }
                },
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
      ),
    );
  }
}
