@immutable
class LoginState {
  final String username;
  final String password;
  final Map<String, String?> errors;

  const LoginState({
    required this.username,
    required this.password,
    this.errors = const {},
  });

  factory LoginState.initial() => LoginState(
        username: '',
        password: '',
      );

  LoginState copyWith({
    String? username,
    String? password,
    Map<String, String?>? errors,
  }) =>
      LoginState(
        username: username ?? this.username,
        password: password ?? this.password,
        errors: errors ?? this.errors,
      );

  bool get isValid => errors.isEmpty; // Check if all fields are valid
}
