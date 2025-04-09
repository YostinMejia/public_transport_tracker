part of 'bus_bloc.dart';

@immutable
sealed class BusState {}

final class BusInitial extends BusState {}

final class BusLoading extends BusState {}

final class BusLoaded extends BusState {
  final BusModel bus;
  BusLoaded({required this.bus});
}

final class BusError extends BusState {
  final String error;
  BusError({required this.error});
}


class CreatingBus extends BusState {}
class BusCreated extends BusState {}