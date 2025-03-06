part of 'location_permission_bloc.dart';

@immutable
sealed class LocationPermissionEvent {}

class PermissionRequest extends LocationPermissionEvent{}
