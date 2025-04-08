import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:public_transport_tracker/data/repositories/location_repository.dart';
import 'package:public_transport_tracker/data/repositories/permission_handler_repository.dart';

part 'location_permission_event.dart';
part 'location_permission_state.dart';

class LocationBloc extends Bloc<LocationPermissionEvent, LocationState> {
  final PermissionHandlerRepository _permissionHandlerRepository;
  final LocationRepository _locationRepository;

  LocationBloc({
    required permissionHandlerRepository,
    required locationRepository,
  }) : _locationRepository = locationRepository,
       _permissionHandlerRepository = permissionHandlerRepository,
       super(LocationPermissionInitial()) {
    on<PermissionRequest>(_requestPermission);
  }

  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return _locationRepository.calculateDistance(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  void _requestPermission(
    LocationPermissionEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationPermissionLoading());
    PermissionStatus permissionStatus =
        await _permissionHandlerRepository.locationPermission();

    if (permissionStatus.isDenied) {
      emit(FineLocationDenied());
      return;
    } else if (permissionStatus.isPermanentlyDenied) {
      emit(FineLocationPermanentlyDenied());
      return;
    }

    final Stream<Position> locationStream = _locationRepository.locationStream();
    final Position actualLocation = await _locationRepository.actualLocation();
    emit(
      FineLocationGranted(
        locationStream: locationStream,
        initialLocation: actualLocation,
      ),
    );
  }
}
