part of 'bus_bloc.dart';

@immutable
sealed class BusState {}

final class BusInitial extends BusState {}

final class BusLoading extends BusState {}

final class BusLoaded extends BusState {
  final BusModel bus;
  final Stream<Position> busPositionStream;
  Position lastPosition;

  BusLoaded({
    required this.bus,
    required this.busPositionStream,
    required this.lastPosition,
  });
}

final class BusError extends BusState {
  final String error;
  BusError({required this.error});
}
