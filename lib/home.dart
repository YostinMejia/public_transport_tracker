import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_transport_tracker/presentation/bloc/auth/auth_bloc.dart';
import 'package:public_transport_tracker/presentation/bloc/location_permission/location_permission_bloc.dart';
import 'package:public_transport_tracker/presentation/views/bus_view.dart';
import 'package:public_transport_tracker/presentation/views/user_view.dart';
import 'package:public_transport_tracker/presentation/widgets/fine_location_dialog.dart';

class HomePage extends StatefulWidget {
  final Rol rol;
  final String? email;
  const HomePage({super.key, required this.email, required this.rol});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is FineLocationDenied ||
            state is FineLocationPermanentlyDenied) {
          showDialog(
            context: context,
            builder: (context) {
              return FineLocationDialog();
            },
          );
        }
      },
      builder: (context, state) {
        if (state is LocationPermissionLoading || state is LocationPermissionInitial) {
          return Scaffold(
            body: SafeArea(
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
          );
        } else if (state is FineLocationGranted) {
          final Widget view;
          switch (widget.rol) {
            case Rol.anonymous || Rol.user:
              view = UserView(
                isAnonymous: widget.rol == Rol.anonymous,
                email: widget.email,
                actualPosition: state.initialLocation,
                positionStream: state.locationStream,
                calculateDistance:
                    context.read<LocationBloc>().calculateDistance,
              );
              break;
            default:
              if (widget.email == null) {
                view = Scaffold(
                  body: Center(
                    child: Text(
                      "Can't access the driver mode without an email",
                    ),
                  ),
                );
                break;
              }
              view = BusView(
                email: widget.email!,
                actualPosition: state.initialLocation,
                positionStream: state.locationStream,
                calculateDistance:
                    context.read<LocationBloc>().calculateDistance,
              );
          }
          return view;
        } else {
          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Accept the location permission, for the app to work correctly",
                  ),
                  TextButton(
                    child: Text(
                      "To change the permission. Click Here and restart the app",
                    ),
                    onPressed:
                        () => showDialog(
                          context: context,
                          builder: (context) {
                            return FineLocationDialog();
                          },
                        ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
