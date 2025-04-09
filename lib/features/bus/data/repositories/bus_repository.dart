import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:public_transport_tracker/features/bus/data/datasources/bus_remote_datasource.dart';
import 'package:public_transport_tracker/features/location/data/datasources/geolocator_datasource.dart';
import 'package:public_transport_tracker/features/location/data/repositories/location_repository.dart';
import 'package:public_transport_tracker/features/bus/domain/bus_model.dart';
import 'package:public_transport_tracker/features/location/domain/position_model.dart';
import 'package:public_transport_tracker/features/bus/domain/stop_model.dart';

class BusRepository {
  final BusRemoteDatasource _busRemoteDatasource;
  final LocationRepository _locationRepository;

  BusRepository({
    required busRemoteDatasource,
    required locationRepository,
  }) : _busRemoteDatasource = busRemoteDatasource,
       _locationRepository = locationRepository;

  Stream<Position> locationStream() {
    return _locationRepository.locationStream();
  }

  Future<Position> actualLocation() async {
    return _locationRepository.actualLocation();
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

  Future<void> createBus(BusSignUpDTO bus, String authId) async {
    _busRemoteDatasource.createBus(bus, authId);
  }

  Future<BusModel?> getBusByEmail(String email) async {
    //TODO: implement the geocoding to get the addres from the latitude and longitude
    // Set<StopModel> stops = {
    //   StopModel(
    //     address: "cra1",
    //     position: PositionModel(
    //       latitude: 6.205010569069789,
    //       longitude: -75.58839809149504,
    //     ),
    //   ),
    //   StopModel(
    //     address: "cra2",
    //     position: PositionModel(
    //       latitude: 6.203320341628996,
    //       longitude: -75.5854094401002,
    //     ),
    //   ),
    //   StopModel(
    //     address: "cra3",
    //     position: PositionModel(
    //       latitude: 6.201076473833529,
    //       longitude: -75.58488808572292,
    //     ),
    //   ),
    //   StopModel(
    //     address: "cra4",
    //     position: PositionModel(
    //       latitude: 6.213689939877612,
    //       longitude: -75.59646315872669,
    //     ),
    //   ),
    //   StopModel(
    //     address: "cra5",
    //     position: PositionModel(
    //       latitude: 6.215002832241854,
    //       longitude: -75.59830516576767,
    //     ),
    //   ),
    //   StopModel(
    //     address: "cra6",
    //     position: PositionModel(
    //       latitude: 6.220486347254953,
    //       longitude: -75.60232914984226,
    //     ),
    //   ),
    // };

    // return Future.delayed(
    //   Duration(seconds: 1),
    //   () => BusModel(id: "1", stops: stops, email: email, password: "password"),
    // );
    QuerySnapshot<Map<String, dynamic>> response = await _busRemoteDatasource.getBusByEmail(email);
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
