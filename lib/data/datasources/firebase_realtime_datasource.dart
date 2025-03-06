import 'package:public_transport_tracker/domain/models/position_model.dart';

class FirebaseRealtimeDatasource {
  final List<PositionModel> _busPositions=[];

  List<PositionModel> get busPositions=>_busPositions;
  PositionModel get actualPosition=> _busPositions.last;
  
  updateBusPosition(PositionModel location){
    _busPositions.add(location);
  }

}
