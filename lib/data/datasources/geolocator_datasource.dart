import 'dart:async';
import 'package:geolocator/geolocator.dart';

class GeolocatorDatasource {
  LocationPermission? locationPermission;
  LocationSettings locationSettings;

  GeolocatorDatasource(this.locationSettings, [this.locationPermission]);
  //TODO: implement a dispose method in all the widgets that implement it
  Stream<Position> get positionStream =>Geolocator.getPositionStream(locationSettings: locationSettings);

  Future<Position> determinePosition() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  double calculateDistance(double startLatitude,double startLongitude,double endLatitude,double endLongitude,) {
    return Geolocator.distanceBetween(startLatitude,startLongitude,endLatitude,endLongitude);
  }

}
