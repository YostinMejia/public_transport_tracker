part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthLoading extends AuthState {}

final class AnonymouslyAuthenticated extends AuthState {
  final User user;
  AnonymouslyAuthenticated({required this.user});
}

final class UserAuthenticated extends AuthState {
  final User user;
  UserAuthenticated({required this.user});
}

final class BusAuthenticated extends AuthState {
  final User bus;
  BusAuthenticated({required this.bus});
}

final class UnAuthenticated extends AuthState {}

final class ErrorSignIn extends AuthState {
  final String error;
  ErrorSignIn({required this.error});
}
