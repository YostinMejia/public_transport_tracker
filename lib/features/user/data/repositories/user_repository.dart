import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:public_transport_tracker/features/location/data/datasources/geolocator_datasource.dart';
import 'package:public_transport_tracker/features/location/domain/position_model.dart';
import 'package:public_transport_tracker/features/bus/domain/stop_model.dart';
import 'package:public_transport_tracker/features/user/data/datasources/user_remote_datasource.dart';
import 'package:public_transport_tracker/features/user/domain/models/user_model.dart';

class UserRepository {
  final UserRemoteDatasource _userRemoteDatasource;
  final GeolocatorDatasource _geolocatorDatasource;

  UserRepository({
    required userRemoteDatasource,
    required geolocatorDatasource,
    required authRepository,
  }) : _userRemoteDatasource = userRemoteDatasource,
       _geolocatorDatasource = geolocatorDatasource;

  Stream<Position> locationStream() {
    return _geolocatorDatasource.positionStream;
  }

  Future<Position> actualLocation() async {
    return _geolocatorDatasource.determinePosition();
  }

  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return GeolocatorDatasource.calculateDistance(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  Future<UserModel?> getUserByEmail(String email) async {
    QuerySnapshot<Map<String, dynamic>> response =
        await _userRemoteDatasource.getUserByEmail(email);

    return response.docs.isNotEmpty
        ? UserModel.fromJson(response.docs.first.data())
        : null;
  }

  //TODO: implement unique email
  Future<DocumentReference<Map<String, dynamic>>> createUser(
    UserSignUpDTO user,
    String authId,
  ) async {
    return _userRemoteDatasource.createUser(user, authId);
  }

  static Set<Marker> stopsToMarkers(Set<StopModel> stops) {
    return stops.map((stop) => positionToMarker(stop.position)).toSet();
  }

  static Marker positionToMarker(PositionModel location) {
    return Marker(
      markerId: MarkerId("${location.latitude}${location.longitude}"),
      position: LatLng(location.latitude, location.longitude),
    );
  }
}
