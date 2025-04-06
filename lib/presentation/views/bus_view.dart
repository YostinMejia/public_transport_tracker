import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:public_transport_tracker/presentation/bloc/bus/bus_bloc.dart';
import 'package:public_transport_tracker/presentation/screens/bus_map_screen.dart';
import 'package:public_transport_tracker/presentation/screens/profile_screen.dart';
import 'package:public_transport_tracker/presentation/screens/time_screen.dart';

class BusView extends StatefulWidget {
  final Stream<Position> positionStream;
  final Position actualPosition;
  final String email;
  final double Function(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  )
  calculateDistance;
  const BusView({
    super.key,
    required this.email,
    required this.actualPosition,
    required this.positionStream,
    required this.calculateDistance,
  });

  @override
  State<BusView> createState() => _BusViewState();
}

class _BusViewState extends State<BusView> {
  int _currentPage = 0;

  void _fetchBus() {
    context.read<BusBloc>().add(BusFetch(email: widget.email));
  }

  @override
  void initState() {
    _fetchBus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusBloc, BusState>(
      builder: (context, state) {
        if (state is BusError) {
          return Scaffold(body: Center(child: Text("Error: ${state.error}")));
        } else if (state is BusLoaded) {
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
                BottomNavigationBarItem(
                  icon: Icon(Icons.bus_alert),
                  label: "Profile",
                ),
              ],
            ),
            body: SafeArea(
              child: IndexedStack(
                //Bus's view
                index: _currentPage,
                children: [
                  TimeScreen(
                    positionStream: widget.positionStream,
                    stops: state.bus.stops,
                    calculateDistance: widget.calculateDistance,
                    actualPosition: widget.actualPosition,
                  ),
                  BusMapScreen(
                    //FIXME: implement the logic to get the actual bus stops
                    stops: state.bus.stops,
                    initialPosition: widget.actualPosition,
                    busPositionStream: widget.positionStream,
                  ),
                  ProfileScreen(email: state.bus.email),
                ],
              ),
            ),
          );
        } else {
          //TODO: implement a custom loading screen
          return Scaffold(
            body: SafeArea(
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
          );
        }
      },
    );
  }
}
