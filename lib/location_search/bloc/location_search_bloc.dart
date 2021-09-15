import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'location_search_event.dart';
part 'location_search_state.dart';

class LocationSearchBloc
    extends Bloc<LocationSearchEvent, LocationSearchState> {
  LocationSearchBloc({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(LocationSearchInitial()) {
    on<LocationSearchQueryChanged>(_onLocationSearchQueryChanged);
    on<SearchLocationByNameRequested>(_onDeviceLocationRequested);
    on<DeviceLocationRequested>(_onSearchLocationByNameRequested);
  }

  final WeatherRepository _weatherRepository;

  void _onLocationSearchQueryChanged(LocationSearchQueryChanged event,
      Emitter<LocationSearchState> emit) async {
    emit(LocationSearchInProgess());
    log(event.cityName ?? '');
  }

  void _onDeviceLocationRequested(SearchLocationByNameRequested event,
      Emitter<LocationSearchState> emit) async {
    log(event.cityName);
  }

  void _onSearchLocationByNameRequested(
      DeviceLocationRequested event, Emitter<LocationSearchState> emit) async {
    try {
      emit(LocationSearchInProgess());
      final coordinates = await _weatherRepository.getDeviceCoordinates();
      log(coordinates.toString());
    } on Exception catch (e) {
      emit(LocationSearchFail(exception: e, query: 'Device location'));
    }
  }
}
