import 'package:public_transport_tracker/domain/models/stop_model.dart';

class BusModel {
  final String id;
  final String email;
  final String password;
  final Set<StopModel> stops;
  BusModel({
    required this.id,
    required this.stops,
    required this.email,
    required this.password,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    Set<StopModel> stops =
        (json["stops"] as List<dynamic>).map((stop) {
          return StopModel.fromJson(stop as Map<String, dynamic>);
        }).toSet();
    return BusModel(
      id: json["authId"].toString(),
      stops: stops,
      email: json["email"].toString(),
      password: json["password"].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "stops": stops.map((stop) => stop.toJson()).toList(),
      "email": email,
      "password": password,
    };
  }
}

class BusSignUpDTO {
  final String email;
  final String password;
  final List<Map<String, dynamic>> stops;
  BusSignUpDTO({
    required this.email,
    required this.password,
    required this.stops,
  });

  Map<String, dynamic> toJson() {
    return {"stops": stops, "email": email, "password": password};
  }
}
