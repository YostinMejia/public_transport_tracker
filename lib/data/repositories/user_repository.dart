import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:public_transport_tracker/data/datasources/firebasefirestore_datasource.dart';
import 'package:public_transport_tracker/data/datasources/geolocator_datasource.dart';
import 'package:public_transport_tracker/domain/models/position_model.dart';
import 'package:public_transport_tracker/domain/models/stop_model.dart';
import 'package:public_transport_tracker/domain/models/user_model.dart';

class UserRepository {
  final FirebaseFirestoreDatasource _firebaseFirestoreDatasource;
  final GeolocatorDatasource _geolocatorDatasource;

  UserRepository({
    required firebaseFirestoreDatasource,
    required geolocatorDatasource,
    required authRepository,
  }) : _firebaseFirestoreDatasource = firebaseFirestoreDatasource,
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
        await _firebaseFirestoreDatasource.getUserByEmail(email);

    return response.docs.isNotEmpty
        ? UserModel.fromJson(response.docs.first.data())
        : null;
  }

  //TODO: implement unique email
  Future<DocumentReference<Map<String, dynamic>>> createUser(
    UserSignUpDTO user,
    String authId,
  ) async {
    return _firebaseFirestoreDatasource.createUser(user, authId);
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
