import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:public_transport_tracker/data/repositories/permission_handler_repository.dart';

part 'location_permission_event.dart';
part 'location_permission_state.dart';

class LocationPermissionBloc extends Bloc<LocationPermissionEvent, LocationPermissionState> {
  final PermissionHandlerRepository _permissionHandlerRepository;

  LocationPermissionBloc(this._permissionHandlerRepository) : super(LocationPermissionInitial()) {
    on<PermissionRequest>(_requestPermission);
  }
  
  void _requestPermission(LocationPermissionEvent event, Emitter<LocationPermissionState> emit)async {
    emit(LocationPermissionInitial());
    PermissionStatus permissionStatus = await _permissionHandlerRepository.locationPermission();
    if (permissionStatus.isGranted) {emit(FineLocationGranted());}
    else if (permissionStatus.isDenied) {emit(FineLocationDenied());}
    else {emit(FineLocationPermanentlyDenied());}
  }
}
