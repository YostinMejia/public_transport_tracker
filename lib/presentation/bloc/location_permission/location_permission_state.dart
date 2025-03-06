part of 'location_permission_bloc.dart';

@immutable
sealed class LocationPermissionState {}

final class LocationPermissionInitial extends LocationPermissionState {}
final class FineLocationGranted extends LocationPermissionState {}
final class FineLocationDenied extends LocationPermissionState {}
final class FineLocationPermanentlyDenied extends LocationPermissionState {}

