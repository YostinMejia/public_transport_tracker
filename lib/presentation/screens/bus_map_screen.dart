import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:public_transport_tracker/domain/models/bus_model.dart';
import 'package:public_transport_tracker/domain/models/stop_model.dart';
import 'package:public_transport_tracker/presentation/bloc/bus/bus_bloc.dart';

//TODO: Handle correctly the errors and show only the map with the location of the buses but do not show the user's location and also do not show the closest stop
//but we should show the time that will take the bus to arrive to the stations
class BusMapScreen extends StatefulWidget {
  final BusModel bus;
  final Stream<Position> busPositionStream;
  const BusMapScreen({
    super.key,
    required this.bus,
    required this.busPositionStream,
  });

  @override
  State<BusMapScreen> createState() => _MapSampleState();
}

class _MapSampleState extends State<BusMapScreen> {
  late StreamSubscription<Position> positionStream;

  @override
  Widget build(BuildContext context) {
    positionStream = widget.busPositionStream.listen((Position position) {
      print("listening for locations updates");
      print("Actual position: ${position.latitude}, ${position.longitude} ");
    });

    return BusGoogleMapWidget(
      stops: widget.bus.stops,
      initUserLatitude: widget.bus.location.latitude,
      initUserLongitude: widget.bus.location.longitude,
    );
  }
}

class BusGoogleMapWidget extends StatelessWidget {
  final Set<StopModel> stops;
  final double initUserLatitude;
  final double initUserLongitude;

  BusGoogleMapWidget({
    super.key,
    required this.initUserLatitude,
    required this.initUserLongitude,
    required this.stops,
  });

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    Set<Marker> stopsMarkers = context
        .read<BusBloc>()
        .busRepository
        .stopsToMarkers(stops);

    return GoogleMap(
      myLocationEnabled: true,
      markers: {...stopsMarkers},
      initialCameraPosition: CameraPosition(
        target: LatLng(initUserLatitude, initUserLongitude),
        zoom: 14.4746,
      ),
      onTap: (location) => print("${location.latitude}, ${location.longitude}"),
      onMapCreated:
          (GoogleMapController controller) => _controller.complete(controller),
    );
  }
}
