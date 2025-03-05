part of 'bus_bloc.dart';

@immutable
sealed class BusEvent {}

class BusFetch extends BusEvent {
  final String id;
  BusFetch({required this.id});
}
