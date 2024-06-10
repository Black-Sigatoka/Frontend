//import 'package:black_sigatoka/screens/home_page.dart';
import 'package:black_sigatoka/app_view.dart';
import 'package:black_sigatoka/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:black_sigatoka/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:black_sigatoka/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:black_sigatoka/utils/recommendation_state.dart';
import 'package:black_sigatoka/utils/user_history_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  const MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(userRepository: userRepository),
      ),
      BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(
            userRepository: context.read<AuthenticationBloc>().userRepository),
      ),
      BlocProvider<SignInBloc>(
          create: (context) => SignInBloc(
              userRepository:
                  context.read<AuthenticationBloc>().userRepository)),
      ChangeNotifierProvider(
        create: (context) => RecommendationState()
      ),
      ChangeNotifierProvider(
        create: (context) => UserHistoryState()
      ),
    ], child: const MyAppView());
  }
}
