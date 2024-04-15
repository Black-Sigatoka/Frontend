import 'package:black_sigatoka/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:black_sigatoka/custom_widgets/custom_appbar.dart';
import 'package:black_sigatoka/screens/auth/components/custom_textformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          setState(() {
            return;
          });
        }
      },
      child: Scaffold(
        //backgroundColor: Color.fromRGBO(217, 217, 217, 100),
        appBar: const PreferredSize(
          preferredSize:
              Size.fromHeight(kToolbarHeight), // Adjust size as needed
          child: CustomAppBar(
            title: 'Login',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Create an account',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
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
                      const SizedBox(height: 16),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: CustomTextFormField(
                          controller: passwordController,
                          hintText: 'Enter your password',
                          obscureText: obscurePassword,
                          keyboardType: TextInputType.visiblePassword,
                          prefixIcon: const Icon(CupertinoIcons.lock_fill),
                          onChanged: (val) {
                            if (val!.contains(RegExp(r'[A-Z]'))) {
                              setState(() {
                                containsUpperCase = true;
                              });
                            } else {
                              setState(() {
                                containsUpperCase = false;
                              });
                            }
                            if (val.contains(RegExp(r'[a-z]'))) {
                              setState(() {
                                containsLowerCase = true;
                              });
                            } else {
                              setState(() {
                                containsLowerCase = false;
                              });
                            }
                            if (val.contains(RegExp(r'[0-9]'))) {
                              setState(() {
                                containsNumber = true;
                              });
                            } else {
                              setState(() {
                                containsNumber = false;
                              });
                            }
                            if (val.contains(RegExp(
                                r'^(?=.*?[!@#\$&*~`])\%\-(_+=:;,.<>/?"[{\]}\|^])'))) {
                              setState(() {
                                containsSpecialChar = true;
                              });
                            } else {
                              setState(() {
                                containsSpecialChar = false;
                              });
                            }
                            if (val.length >= 8) {
                              setState(() {
                                contains8Length = true;
                              });
                            } else {
                              setState(() {
                                contains8Length = false;
                              });
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
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "- 1 uppercase",
                                style: TextStyle(
                                    color: containsUpperCase
                                        ? Colors.green
                                        : Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                              ),
                              Text(
                                "- 1 lowercase",
                                style: TextStyle(
                                    color: containsLowerCase
                                        ? Colors.green
                                        : Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                              ),
                              Text(
                                "- 1 number",
                                style: TextStyle(
                                    color: containsNumber
                                        ? Colors.green
                                        : Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "- 1 special character",
                                style: TextStyle(
                                    color: containsSpecialChar
                                        ? Colors.green
                                        : Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                              ),
                              Text(
                                "- 8 minimum characters",
                                style: TextStyle(
                                    color: contains8Length
                                        ? Colors.green
                                        : Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: CustomTextFormField(
                          controller: nameController,
                          hintText: 'Enter your name',
                          obscureText: false,
                          keyboardType: TextInputType.name,
                          prefixIcon: const Icon(CupertinoIcons.person_fill),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please fill in this field';
                            } else if (val.length > 30) {
                              return 'Name too long';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      !signUpRequired
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    MyUser myUser = MyUser.empty;
                                    myUser = myUser.copyWith(
                                        email: emailController.text,
                                        name: nameController.text);
                                    setState(() {
                                      context.read<SignUpBloc>().add(
                                          SignUpRequired(
                                              myUser, passwordController.text));
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    backgroundColor: const Color.fromARGB(
                                        255, 127, 181, 230)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 95, vertical: 15),
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            )
                          : const CircularProgressIndicator()
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}





















































































// // ignore_for_file: prefer_const_constructors

// import 'package:black_sigatoka/custom_widgets/custom_appbar.dart';
// import 'package:black_sigatoka/custom_widgets/custom_button.dart';
// //import 'package:black_sigatoka/screens/auth/components/custom_textformfield.dart';
// import 'package:black_sigatoka/screens/auth/login_page.dart';
// import 'package:flutter/material.dart';

// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});

//   final String buttonText = 'Register';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //backgroundColor: Color.fromRGBO(217, 217, 217, 100),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(kToolbarHeight), // Adjust size as needed
//         child: CustomAppBar(
//           title: 'Register',
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             Text(
//               'Create your account',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 20),
//             // CustomTextFormField(
//             //   label: 'Enter your full name',
//             //   onChanged: (value) {
//             //     //handles changes to the text form field
//             //   },
//             // ),
//             SizedBox(height: 16),
//             // CustomTextFormField(
//             //   label: 'Enter your email',
//             //   onChanged: (value) {},
//             // ),
//             // SizedBox(height: 16),
//             // CustomTextFormField(
//             //   label: 'Enter your passsword',
//             //   onChanged: (value) {},
//             // ),
//             // SizedBox(height: 16),
//             // CustomTextFormField(
//             //   label: 'Confirm Password',
//             //   onChanged: (value) {},
//             // ),
//             SizedBox(height: 16),
//             CustomButton(
//               text: buttonText,
//               onPressed: loginButtonPressed,
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Already have an account?',
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => LoginScreen()));
//                   },
//                   child: Text(
//                     'Sign in',
//                     style: TextStyle(color: Color.fromARGB(255, 127, 181, 230)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
