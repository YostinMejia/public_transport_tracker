import 'package:public_transport_tracker/domain/models/position_model.dart';
import 'package:public_transport_tracker/domain/models/stop_model.dart';

class BusModel {
  String id;
  PositionModel location;
  Set<StopModel> stops;
  BusModel({required this.id, required this.location, required this.stops});
  
}
