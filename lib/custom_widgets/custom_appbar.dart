
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Color backgroundColor = Colors.white;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Image.asset(
          'assets/images/Logo.png',
          height: 30,
          width: 30,
        ),
      ),
      title: Center(
        child: Text(
          title.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
