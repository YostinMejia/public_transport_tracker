import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:public_transport_tracker/data/datasources/firebase_realtime_datasource.dart';
import 'package:public_transport_tracker/data/datasources/geolocator_datasource.dart';
import 'package:public_transport_tracker/data/repositories/permission_handler_repository.dart';
import 'package:public_transport_tracker/presentation/bloc/bus/bus_bloc.dart';
import 'package:public_transport_tracker/presentation/bloc/location_permission/location_permission_bloc.dart';
import 'package:public_transport_tracker/presentation/screens/bus_map_screen.dart';
import 'package:public_transport_tracker/presentation/screens/time_screen.dart';
import 'package:public_transport_tracker/presentation/widgets/fine_location_dialog.dart';

import 'data/repositories/bus_repository.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationPermissionBloc>(
          create:
              (_) =>
                  LocationPermissionBloc(PermissionHandlerRepository())
                    ..add(PermissionRequest()),
        ),
        BlocProvider<BusBloc>(
          create:
              (_) => BusBloc(
                BusRepository(
                  firebaseRealtimeDatasource: FirebaseRealtimeDatasource(),
                  geolocatorDatasource: GeolocatorDatasource(
                    LocationSettings(
                      accuracy: LocationAccuracy.high,
                      distanceFilter: 1,
                    ),
                  ),
                ),
              ),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
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
          body: HomePage(currentPage: _currentPage),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final int currentPage;
  const HomePage({super.key, required this.currentPage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          context.read<BusBloc>().add(BusFetch(id: "id"));
        }
      },
      child: BlocBuilder<BusBloc, BusState>(
        builder: (context, state) {
          if (state is BusLoaded) {
            return widget.currentPage == 0
                ? TimeScreen(
                  positionStream: state.busPositionStream,
                  stops: state.bus.stops,
                  actualPosition: state.lastPosition,
                )
                : BusMapScreen(
                  bus: state.bus,
                  busPositionStream: state.busPositionStream,
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
