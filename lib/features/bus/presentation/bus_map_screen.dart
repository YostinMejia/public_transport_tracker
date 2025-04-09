import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:public_transport_tracker/features/bus/data/repositories/bus_repository.dart';
import 'package:public_transport_tracker/features/bus/domain/stop_model.dart';


class BusMapScreen extends StatefulWidget {
  final Stream<Position> busPositionStream;
  final Set<StopModel> stops;

  final Position initialPosition;
  const BusMapScreen({
    super.key,
    required this.stops,
    required this.initialPosition,
    required this.busPositionStream,
  });

  @override
  State<BusMapScreen> createState() => _MapSampleState();
}

class _MapSampleState extends State<BusMapScreen> {

  @override
  Widget build(BuildContext context) {
    return BusGoogleMapWidget(
      stops: widget.stops,
      stopsToMarkers: BusRepository.stopsToMarkers,
      initUserLatitude: widget.initialPosition.latitude,
      initUserLongitude: widget.initialPosition.longitude,
    );
  }
}

class BusGoogleMapWidget extends StatelessWidget {
  final Set<StopModel> stops;
  final double initUserLatitude;
  final double initUserLongitude;
  final Set<Marker> Function(Set<StopModel>) stopsToMarkers;

  BusGoogleMapWidget({
    super.key,
    required this.stopsToMarkers,
    required this.initUserLatitude,
    required this.initUserLongitude,
    required this.stops,
  });

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    Set<Marker> stopsMarkers = stopsToMarkers(stops);

    return GoogleMap(
      myLocationEnabled: true,
      markers: {...stopsMarkers},
      initialCameraPosition: CameraPosition(
        target: LatLng(initUserLatitude, initUserLongitude),
        zoom: 14.4746,
      ),
      // onTap: (location) => print("${location.latitude}, ${location.longitude}"),
      onMapCreated:
          (GoogleMapController controller) => _controller.complete(controller),
    );
  }
}
