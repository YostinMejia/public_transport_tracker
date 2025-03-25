part of 'bus_bloc.dart';

@immutable
sealed class BusEvent {}

class BusFetch extends BusEvent {
  final String email;
  final String password;
  BusFetch({required this.email, required this.password});
}
