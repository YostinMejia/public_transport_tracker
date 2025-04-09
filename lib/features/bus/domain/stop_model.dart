import 'package:public_transport_tracker/features/location/domain/position_model.dart';

class StopModel {
  final PositionModel position;
  final String address;
  const StopModel({ required this.position, required this.address});

  factory StopModel.fromJson(Map<String, dynamic> json){
    return StopModel(position: PositionModel.fromJson(json["position"]), address: json["address"]);
  }

  Map<String, dynamic> toJson(){
    return {
      "position": position.toJson(),
      "address": address
    };
  }
}