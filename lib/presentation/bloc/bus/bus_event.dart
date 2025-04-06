part of 'bus_bloc.dart';

@immutable
sealed class BusEvent {}

class BusFetch extends BusEvent {
  final String email;
  BusFetch({required this.email});
}
