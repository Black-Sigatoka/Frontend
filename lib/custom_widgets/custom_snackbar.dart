// import 'package:flutter/material.dart';

// class CustomSnackBar extends StatelessWidget {
//   const CustomSnackBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SnackBar(
//       content: const Text('This is a custom SnackBar'),
//       action: SnackBarAction(
//         label: 'Action',
//         onPressed: () {
//           // Code to execute.
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

SnackBar customSnackBar({required String content}) {
  return SnackBar(
    backgroundColor: Colors.black,
    content: Text(
      content,
      style: const TextStyle(
        color: Colors.redAccent,
        letterSpacing: 0.5),
    ),
  );
}
