import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:public_transport_tracker/features/bus/data/repositories/bus_repository.dart';
import 'package:public_transport_tracker/features/bus/domain/bus_model.dart';

part 'bus_event.dart';
part 'bus_state.dart';

class BusBloc extends Bloc<BusEvent, BusState> {
  final BusRepository _busRepository;

  BusBloc(this._busRepository) : super(BusInitial()) {
    on<BusFetch>(_fetchBus);
    on<CreateBus>(_createBus);
  }
  
  void _fetchBus(BusFetch event, Emitter<BusState> emit) async {
    emit(BusLoading());
    try {
      final BusModel? bus = await _busRepository.getBusByEmail(event.email);

      if (bus == null) {
        emit(BusError(error: "Bus not found"));
        return;
      }

      emit(BusLoaded(bus: bus));
    } catch (e) {
      emit(BusError(error: e.toString()));
    }
  }

  void _createBus(CreateBus event, Emitter<BusState> emit)async{
    emit(CreatingBus());
    await _busRepository.createBus(event.busSignUpDTO, event.authId);
    emit(BusCreated());
  }
}
