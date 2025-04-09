import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:public_transport_tracker/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:public_transport_tracker/features/bus/data/datasources/bus_remote_datasource.dart';
import 'package:public_transport_tracker/features/location/data/datasources/geolocator_datasource.dart';
import 'package:public_transport_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:public_transport_tracker/features/location/data/repositories/location_repository.dart';
import 'package:public_transport_tracker/features/location/data/repositories/permission_handler_repository.dart';
import 'package:public_transport_tracker/firebase_options.dart';
import 'package:public_transport_tracker/features/auth/bloc/auth/auth_bloc.dart';
import 'package:public_transport_tracker/features/bus/bloc/bus/bus_bloc.dart';
import 'package:public_transport_tracker/features/location/bloc/location_permission/location_permission_bloc.dart';
import 'package:public_transport_tracker/home.dart';
import 'package:public_transport_tracker/features/auth/presentation/login_screen.dart';
import 'features/bus/data/repositories/bus_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
  FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8080);

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create:
              (_) => AuthBloc(
                authRepository: AuthRepository(
                  firebaseAuthDatasource: FirebaseAuthDatasource(),
                ),
              )..add(StartAuthListen()),
        ),
        BlocProvider<LocationBloc>(
          create:
              (_) => LocationBloc(
                permissionHandlerRepository: PermissionHandlerRepository(),
                locationRepository: LocationRepository(
                  geolocatorDatasource: GeolocatorDatasource(
                    LocationSettings(
                      accuracy: LocationAccuracy.high,
                      distanceFilter: 1,
                    ),
                  ),
                ),
              )..add(PermissionRequest()),
        ),
        BlocProvider<BusBloc>(
          create:
              (_) => BusBloc(
                BusRepository(
                  busRemoteDatasource: BusRemoteDatasource(),
                  locationRepository: LocationRepository(
                    geolocatorDatasource: GeolocatorDatasource(
                      LocationSettings(
                        accuracy: LocationAccuracy.high,
                        distanceFilter: 1,
                      ),
                    ),
                  ),
                ),
              ),
        ),
      ],
      child: MaterialApp(
        home: BlocBuilder<AuthBloc, AuthState>(
          buildWhen:
              (previous, current) =>
                  current is Authenticated || current is UnAuthenticated,
          builder: (BuildContext context, AuthState state) {
            if (state is Authenticated) {
              return HomePage(email: state.user.email, rol: state.rol);
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
