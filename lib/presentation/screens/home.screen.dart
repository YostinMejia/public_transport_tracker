
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_transport_tracker/data/datasources/geolocator_datasource.dart';
import 'package:public_transport_tracker/presentation/bloc/bus/bus_bloc.dart';
import 'package:public_transport_tracker/presentation/bloc/location_permission/location_permission_bloc.dart';
import 'package:public_transport_tracker/presentation/screens/bus_map_screen.dart';
import 'package:public_transport_tracker/presentation/screens/time_screen.dart';
import 'package:public_transport_tracker/presentation/widgets/fine_location_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationPermissionBloc, LocationPermissionState>(
      listener: (context, state) {
        if (state is FineLocationDenied || state is FineLocationDenied) {
          showDialog(
            context: context,
            builder: (context) {
              return FineLocationDialog();
            },
          );
        } else {
          context.read<BusBloc>().add(
            BusFetch(email: "bus@gmail.com", password: "password"),
          );
        }
      },
      child: BlocBuilder<BusBloc, BusState>(
        builder: (context, state) {
          if (state is BusLoaded) {
            return Scaffold(
              extendBodyBehindAppBar: false,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentPage,
                onTap:
                    (index) => {
                      setState(() {
                        _currentPage = index;
                      }),
                    },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.hourglass_top_outlined),
                    label: "Time",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map_sharp),
                    label: "Map",
                  ),
                ],
              ),
              body: IndexedStack(
                index: _currentPage,
                children: [TimeScreen(
                        positionStream: state.busPositionStream,
                        stops: state.bus.stops,
                        calculateDistance:
                            GeolocatorDatasource.calculateDistance,
                        actualPosition: state.lastPosition,
                      )
                      ,BusMapScreen(
                        bus: state.bus,
                        initialPosition: state.lastPosition,
                        busPositionStream: state.busPositionStream,
                      ),],)

                 
            );
          } else if (state is BusError) {
            return Center(child: Text("Error ${state.error.toString()}"));
          } else {
            return Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}
