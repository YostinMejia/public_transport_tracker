//TODO: I need to have two different views depending on the type of user logged in,
//if it is a Bus then the time panel should display a list view showing the time that will take to arrive to the stations
// if it is a user then it should display a list view of the closest stations and also displays the time that will take to bus to arrive

//TODO: Handle correctly the errors and show only the map with the location of the buses but do not show the user's location and also do not show the closest stop
//but we should show the time that will take the bus to arrive to the stations

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:public_transport_tracker/domain/models/stop_model.dart';
import 'package:public_transport_tracker/presentation/bloc/bus/bus_bloc.dart';
import 'package:public_transport_tracker/presentation/widgets/stop_information.dart';

class TimeScreen extends StatefulWidget {
  final Set<StopModel> stops;
  final Stream<Position> positionStream;
  final Position actualPosition;
  const TimeScreen({
    super.key,
    required this.stops,
    required this.positionStream,
    required this.actualPosition,
  });

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

//TODO: Learn if implementing keepAlive will make the screen faster
class _TimeScreenState extends State<TimeScreen> {
  //TODO: learn when a dispose method is called and how should I implement it usign streams
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //Close conecction with broadccast
    print("dispose");
  }

  //TODO: IMPLEMENT a dispose so it will cut the connection to the stream and then will create a new one when the widget have been rebuilt
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: widget.positionStream,
      
      initialData: widget.actualPosition,
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        Widget children;
        if (snapshot.hasError) {
          print("Error");
          return Center(child: Text("Error ${snapshot.error.toString()}"));
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            //TODO: Understand why the application stays here once i go to the map screen and then come back
            children = Center(child: CircularProgressIndicator.adaptive());
          case ConnectionState.none:
            children = Center(child: Text("Nichi "));
          case ConnectionState.active:
            children = ListView(
              children: widget.stops.map((stop){
                 return StopInformation(
              stop: stop,
              distance: context.read<BusBloc>().busRepository.calculateDistance(
                stop.position.latitude,
                stop.position.longitude,
                snapshot.data!.latitude,
                snapshot.data!.longitude,
              ),
            );
              }).toList(),
            );
          case ConnectionState.done:
            children = Center(child: Text("Done"));
        }

        return children;
      },
    );
  }
}
