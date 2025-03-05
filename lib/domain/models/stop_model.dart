import 'package:public_transport_tracker/domain/models/position_model.dart';

class StopModel {
  final PositionModel position;
  final String name;
  final String address;

  const StopModel({required this.name, required this.position, required this.address});
}