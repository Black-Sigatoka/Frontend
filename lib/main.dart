import 'dart:developer';

import 'package:black_sigatoka/app.dart';
import 'package:black_sigatoka/firebase_options.dart';
import 'package:black_sigatoka/simple_bloc_observer.dart';
import 'package:black_sigatoka/utils/recommendation_state.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  log('Initializing dotenv...');
  await dotenv.load(fileName: ".env");
  log('dotenv initialized');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();

  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          RecommendationState(), // Provide your ChangeNotifier here
      child: MyApp(FirebaseUserRepo()),
    ),
  );
  // MyApp(FirebaseUserRepo()));
}
