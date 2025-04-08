part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthLoading extends AuthState {}


enum Rol{user, bus,anonymous}
final class Authenticated extends AuthState {
  final bool isAnonymous;
  final Rol rol;
  final User user;
  Authenticated({required this.user, required this.rol, this.isAnonymous = false});
}

final class UnAuthenticated extends AuthState {}

final class SignInError extends AuthState {
  final String error;
  SignInError({required this.error});
}

final class SignUpCorrectly extends AuthState {
  final UserCredential userCredential;
  SignUpCorrectly({required this.userCredential});
}


final class SignUpError extends AuthState {
  final String error;
  SignUpError({required this.error});
}