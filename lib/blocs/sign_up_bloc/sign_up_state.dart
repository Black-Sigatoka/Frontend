part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

final class SignUpInitial extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final String? message;

  const SignUpSuccess({this.message = 'Signed up successfully!'});
}

class SignUpFailure extends SignUpState {
  final String? message;

  const SignUpFailure({this.message = 'Sign up failed'});
}

class SignUpProcess extends SignUpState {}
