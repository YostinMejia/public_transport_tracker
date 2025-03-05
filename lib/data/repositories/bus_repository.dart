import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:public_transport_tracker/data/datasources/firebase_realtime_datasource.dart';
import 'package:public_transport_tracker/data/datasources/geolocator_datasource.dart';
import 'package:public_transport_tracker/domain/models/bus_model.dart';
import 'package:public_transport_tracker/domain/models/position_model.dart';
import 'package:public_transport_tracker/domain/models/stop_model.dart';

class BusRepository {
  FirebaseRealtimeDatasource firebaseRealtimeDatasource;
  GeolocatorDatasource geolocatorDatasource;
  BusRepository({
    required this.firebaseRealtimeDatasource,
    required this.geolocatorDatasource,
  });

  //TODO: implements an on change that update the position when it change so the class model will alway keep the last location
  // making it easy to track 
  Stream<Position> locationStream() {
    return geolocatorDatasource.positionStream;
  }

  Future<Position>  actualLocation ()async{
    await geolocatorDatasource.checkLocationPermission();
    return geolocatorDatasource.determinePosition();
  }

  double calculateDistance(double startLatitude,double startLongitude,double endLatitude,double endLongitude){
    return geolocatorDatasource.calculateDistance(startLatitude, startLongitude, endLatitude, endLongitude);
  }

  //TODO: change to a real fetch
  Future<BusModel> getBus(String id)async {
    //TODO: change the location for the las known location for the id provided
      Position position = await  actualLocation();
    //TODO: change the bus's stops for actual bus's stops
    Set<StopModel> stops = {
      StopModel(name: "stop1", 
      address: "cra1",
      position:PositionModel(latitude: 6.205010569069789, longitude: -75.58839809149504) ),
      StopModel(name: "stop2", 
      address: "cra2",
      position:PositionModel(latitude: 6.203320341628996, longitude: -75.5854094401002)),
      StopModel(name: "stop2", 
      address: "cra3",
      position:PositionModel(latitude: 6.201076473833529, longitude: -75.58488808572292)),
      StopModel(name: "stop3", 
      address: "cra4",
      position:PositionModel(latitude: 6.213689939877612, longitude: -75.59646315872669)),
      StopModel(name: "stop4", 
      address: "cra5",
      position:PositionModel(latitude: 6.215002832241854, longitude: -75.59830516576767)),
      StopModel(name: "stop5", 
      address: "cra6",
      position:PositionModel(latitude: 6.220486347254953, longitude: -75.60232914984226))
    };
    
    return Future.delayed(
      Duration(seconds: 1),
      () => BusModel(id: "1", location: PositionModel(latitude: position.latitude, longitude: position.longitude), stops: stops),
    );
  }

  Set<Marker> stopsToMarkers(Set<StopModel> stops){
    return stops.map((stop)=>positionToMarker(stop.position)).toSet();
  }

  Marker positionToMarker(PositionModel location){
    return Marker(markerId: MarkerId("${location.latitude}${location.longitude}"),position: LatLng(location.latitude, location.longitude));
  }

}
