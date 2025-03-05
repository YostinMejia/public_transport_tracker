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

  // TODO: Display an error message if the user denied the location permissions indicating how it can be resolved o redirecting to configuration
  // show an option redirecting to time screen
  // Also I can implement an option which if the user hasn't accepted location use I can show the map but he can't use the options of showing the closest bus stop
  Future<bool> checkLocationPermission() async {
    // Test if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return true;
  }

  
}
