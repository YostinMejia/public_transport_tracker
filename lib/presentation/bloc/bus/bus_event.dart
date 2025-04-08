part of 'bus_bloc.dart';

@immutable
sealed class BusEvent {}

class BusFetch extends BusEvent {
  final String email;
  BusFetch({required this.email});
}

class CreateBus extends BusEvent {
  final BusSignUpDTO busSignUpDTO;
  final String authId;
  CreateBus({required this.busSignUpDTO, required this.authId});
}
