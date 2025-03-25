import 'package:public_transport_tracker/domain/models/bus_model.dart';
import 'package:public_transport_tracker/domain/models/position_model.dart';
import 'package:public_transport_tracker/domain/models/stop_model.dart';
import 'package:public_transport_tracker/domain/models/user_model.dart';

class FirebaseRealtimeDatasource {
  UserModel getUser(email, password) {
    return UserModel(id: "1", email: email, password: password);
  }

  BusModel getBus(email, password) {
    Set<StopModel> stops = {
      StopModel(
        address: "cra1",
        position: PositionModel(
          latitude: 6.205010569069789,
          longitude: -75.58839809149504,
        ),
      ),
      StopModel(
        address: "cra2",
        position: PositionModel(
          latitude: 6.203320341628996,
          longitude: -75.5854094401002,
        ),
      ),
      StopModel(
        address: "cra3",
        position: PositionModel(
          latitude: 6.201076473833529,
          longitude: -75.58488808572292,
        ),
      ),
      StopModel(
        address: "cra4",
        position: PositionModel(
          latitude: 6.213689939877612,
          longitude: -75.59646315872669,
        ),
      ),
      StopModel(
        address: "cra5",
        position: PositionModel(
          latitude: 6.215002832241854,
          longitude: -75.59830516576767,
        ),
      ),
      StopModel(
        address: "cra6",
        position: PositionModel(
          latitude: 6.220486347254953,
          longitude: -75.60232914984226,
        ),
      ),
    };

    return BusModel(email: email, password: password, stops: stops, id: "1");
  }

  Future<dynamic> logIn(String email, String password) async {
    if (email.contains("bus")) {
      return Future.delayed(
        Duration(milliseconds: 50),
        () => getBus(email, password),
      );
    }
    return Future.delayed(
      Duration(milliseconds: 50),
      () => getUser(email, password),
    );
  }

  Future<UserModel> signUpUser(UserSignUpDTO user) async {
    return Future.delayed(
      Duration(milliseconds: 50),
      () => getUser(user.email, user.password),
    );
  }

  Future<BusModel> signUpBus(BusSignUpDTO bus) async {
    return Future.delayed(
      Duration(milliseconds: 50),
      () => getBus(bus.email, bus.password),
    );
  }
}
