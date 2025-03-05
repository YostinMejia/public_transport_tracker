import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:public_transport_tracker/data/repositories/bus_repository.dart';
import 'package:public_transport_tracker/domain/models/bus_model.dart';

part 'bus_event.dart';
part 'bus_state.dart';

//Learn how should I implement a class that save the bus's stops as Set<Marker> or if should i implement a converter in the model class
class BusBloc extends Bloc<BusEvent, BusState> {
  BusRepository busRepository;

  BusBloc(this.busRepository) : super(BusInitial()) {
    on<BusFetch>(_fetchBus);
  }

  void _fetchBus(BusFetch event, Emitter<BusState> emit) async {
    emit(BusLoading());
    try {
      final BusModel bus = await busRepository.getBus(event.id);
      final Stream<Position> busLocationStream = busRepository.locationStream();
      final Position lastPosition = await busRepository.actualLocation();
      emit(
        BusLoaded(
          bus: bus,
          busPositionStream: busLocationStream,
          lastPosition: lastPosition,
        ),
      );
    } catch (e) {
      emit(BusError(error: e.toString()));
    }
  }
}
