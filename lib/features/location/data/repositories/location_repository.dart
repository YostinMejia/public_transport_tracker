import 'package:geolocator/geolocator.dart';
import 'package:public_transport_tracker/features/location/data/datasources/geolocator_datasource.dart';

class LocationRepository {
  final GeolocatorDatasource _geolocatorDatasource;

  LocationRepository({required geolocatorDatasource})
    : _geolocatorDatasource = geolocatorDatasource;

  Stream<Position> locationStream() {
    return _geolocatorDatasource.positionStream;
  }

  Future<Position> actualLocation() async {
    return _geolocatorDatasource.determinePosition();
  }

  double calculateDistance(
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
}
