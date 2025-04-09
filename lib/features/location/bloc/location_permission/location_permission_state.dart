part of 'location_permission_bloc.dart';

@immutable
sealed class LocationState {}

final class LocationPermissionInitial extends LocationState {}

final class LocationPermissionLoading extends LocationState {}


final class FineLocationGranted extends LocationState {
  final Stream<Position> locationStream;
  final Position initialLocation;

  FineLocationGranted({
    required this.locationStream,
    required this.initialLocation,
  });
}

final class FineLocationDenied extends LocationState {}

final class FineLocationPermanentlyDenied extends LocationState {}
