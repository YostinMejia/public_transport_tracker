import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:public_transport_tracker/features/bus/domain/stop_model.dart';
import 'package:public_transport_tracker/features/bus/presentation/bus_stop_information.dart';

class TimeScreen extends StatefulWidget {
  final Set<StopModel> stops;
  final Stream<Position> positionStream;
  final Position actualPosition;
  final double Function(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  )
  calculateDistance;

  const TimeScreen({
    super.key,
    required this.stops,
    required this.positionStream,
    required this.actualPosition,
    required this.calculateDistance,
  });

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  //TODO: learn how should I implement it usign streams
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.positionStream,
      initialData: widget.actualPosition,
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error ${snapshot.error.toString()}"));
        }
        if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.done) {
          return ListView(
            children:
                widget.stops.map((stop) {
                  return BusStopInformation(
                    stop: stop,
                    distance: widget.calculateDistance(
                      stop.position.latitude,
                      stop.position.longitude,
                      snapshot.data!.latitude,
                      snapshot.data!.longitude,
                    ),
                  );
                }).toList(),
          );
        }
        return Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}
