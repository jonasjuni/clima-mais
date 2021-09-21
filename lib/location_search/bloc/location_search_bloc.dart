import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'location_search_event.dart';
part 'location_search_state.dart';

class LocationSearchBloc
    extends Bloc<LocationSearchEvent, LocationSearchState> {
  final WeatherRepository _weatherRepository;

  LocationSearchBloc({
    required WeatherRepository weatherRepository,
  })  : _weatherRepository = weatherRepository,
        super(LocationSearchInitial()) {
    on<LocationSearchQueryChanged>(_onLocationSearchQueryChanged);
    on<LocationSearchByNameRequested>(_onSearchLocationByNameRequested);
    on<LocationSearchByCoordinatesRequested>(
        _onSearchLocationByCoordiantesRequested);
  }

  void _onLocationSearchQueryChanged(LocationSearchQueryChanged event,
      Emitter<LocationSearchState> emit) async {
    final query = event.query;

    if (query.isEmpty) {
      emit(const LocationFetchSuccess(locations: []));
    } else {
      emit(const LocationFetchInProgess());
      final userLocations = event.userLocations;

      //First search on user saved location and physical location
      final filtered =
          userLocations.where((element) => element.title.startsWith(query));
      if (filtered.isEmpty) {
        try {
          // final locations = await _weatherRepository.getLocationIdByName(value);
          await Future.delayed(const Duration(seconds: 5));
          const locations = [
            Location('test', 1, Coordinates(123, 123), LocationType.fetched),
            Location('test 2', 3, Coordinates(123, 123), LocationType.fetched),
            Location('test 4', 5, Coordinates(123, 123), LocationType.fetched),
          ];

          emit(const LocationFetchSuccess(locations: locations));
        } on Exception catch (e) {
          emit(LocationFetchFail(e: e));
        }
      } else {
        emit(LocationFetchSuccess(locations: filtered.toList()));
      }
    }

    log(query);
  }

  void _onSearchLocationByNameRequested(LocationSearchByNameRequested event,
      Emitter<LocationSearchState> emit) async {
    log(event.query);
  }

  void _onSearchLocationByCoordiantesRequested(
      LocationSearchByCoordinatesRequested event,
      Emitter<LocationSearchState> emit) async {
    emit(const LocationFetchInProgess());
    try {
      final coordinates = await _weatherRepository.getDeviceCoordinates();
      final locations =
          await _weatherRepository.getLocationByCoordinates(coordinates);
      if (locations.isEmpty) {
        //Todo: throw exception
        log('Location empty');
        return;
      }
      //Search for physical location
      final index = event.userLocations.indexWhere(
          (element) => element.locationType == LocationType.physical);
      List<Location> userLocations;
      if (index.isNegative) {
        userLocations = event.userLocations.toList()..insert(0, locations[0]);
      } else {
        userLocations = event.userLocations.toList()
          ..removeAt(index)
          ..insert(index, locations[0]);
      }
      emit(
        LocationAddSuccess(locations: userLocations),
      );
    } on Exception catch (e) {
      emit(LocationFetchFail(e: e));
    }
  }
}
