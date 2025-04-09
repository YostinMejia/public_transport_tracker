part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}
class UserFetch extends UserEvent {
  final String email;
  UserFetch({required this.email});
}
