part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class InitSession extends AuthEvent{}

final class LogIn extends AuthEvent{
  final String email;
  final String password;
  LogIn({required this.email, required this.password});
}
final class StartAuthListen extends AuthEvent{}
final class StopAuthListen extends AuthEvent{}

final class SignUpUser extends AuthEvent{
  final UserSignUpDTO user;
  SignUpUser({required this.user});
}

final class SignUpBus extends AuthEvent{
  final BusSignUpDTO bus;
  SignUpBus({required this.bus});
}
