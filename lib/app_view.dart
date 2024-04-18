import 'package:black_sigatoka/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:black_sigatoka/screens/Diagnosis_page.dart';
import 'package:black_sigatoka/screens/auth/login_page.dart';
import 'package:black_sigatoka/screens/home_page.dart';
//import 'package:black_sigatoka/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
     );
  }
}
