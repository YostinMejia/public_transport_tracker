import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:public_transport_tracker/presentation/bloc/user/user_bloc.dart';
import 'package:public_transport_tracker/presentation/screens/profile_screen.dart';
import 'package:public_transport_tracker/presentation/screens/user_map_screen.dart';

class UserView extends StatefulWidget {
  final Stream<Position> positionStream;
  final Position actualPosition;
  final bool isAnonymous;
  final String? email;

  final double Function(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  )
  calculateDistance;
  const UserView({
    super.key,
    required this.isAnonymous,
    this.email,
    required this.actualPosition,
    required this.positionStream,
    required this.calculateDistance,
  });

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  int _currentPage = 0;

  //FIXME: Implement a bloc builder
  void _fetchUser() {
    if (!widget.isAnonymous && widget.email != null) {
      context.read<UserBloc>().add(UserFetch(email: widget.email!));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  @override
  Widget build(BuildContext context) {
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
          BottomNavigationBarItem(icon: Icon(Icons.map_sharp), label: "Map"),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: "Profile",
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          //Bus's view
          index: _currentPage,
          children: [
            Placeholder(),
            UserMapScreen(
              //FIXME: implement the logic to get the actual user stops
              savedStops: {},
              initialPosition: widget.actualPosition,
              busPositionStream: widget.positionStream,
            ),

            ProfileScreen(email: widget.email!),
          ],
        ),
      ),
    );
  }
}
