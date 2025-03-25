import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:public_transport_tracker/data/datasources/firebasefirestore_datasource.dart';
import 'package:public_transport_tracker/data/datasources/geolocator_datasource.dart';
import 'package:public_transport_tracker/domain/models/bus_model.dart';
import 'package:public_transport_tracker/domain/models/position_model.dart';
import 'package:public_transport_tracker/domain/models/stop_model.dart';

class BusRepository {
  final FirebaseFirestoreDatasource _firebaseFirestoreDatasource;
  final GeolocatorDatasource _geolocatorDatasource;

  BusRepository({
    required firebaseFirestoreDatasource,
    required geolocatorDatasource,
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

  Future<BusModel?> getBusByEmail(String email) async {
    QuerySnapshot<Map<String, dynamic>> response =
        await _firebaseFirestoreDatasource.getBusByEmail(email);
    if (response.docs.isNotEmpty) {
      print(response.docs.first.data());
    }
    return response.docs.isNotEmpty
        ? BusModel.fromJson(response.docs.first.data())
        : null;
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
