import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:stream_transform/stream_transform.dart';
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
    on<LocationSearchFetched>(
      _onLocationSearchFetched,
      transformer: debounce(const Duration(milliseconds: 2000)),
    );

    on<LocationSearchQueryChanged>(_onLocationSearchQueryChanged);

    on<LocationSearchByCoordinatesRequested>(
        _onSearchLocationByCoordiantesRequested);

    on<LocationSearchLocationSelected>(_onLocationSearchLocationSelected);
  }

  void _onLocationSearchFetched(
      LocationSearchFetched event, Emitter<LocationSearchState> emit) async {
    emit(const LocationFetchInProgess());
    try {
      final locations =
          await _weatherRepository.getLocationIdByName(event.query);
      emit(LocationFetchSuccess(locations: locations));
    } on Exception catch (e) {
      emit(LocationFetchFail(e: e));
    }
  }

  void _onLocationSearchQueryChanged(LocationSearchQueryChanged event,
      Emitter<LocationSearchState> emit) async {
    final query = event.query;

    if (query.isEmpty) {
      emit(const LocationFetchSuccess(locations: []));
    } else {
      final userLocations = event.userLocations;
      //First search on usersaved locations and physical location
      final filtered =
          userLocations.where((element) => element.title.startsWith(query));
      if (filtered.isEmpty) {
        add(LocationSearchFetched(query: query, userLocations: userLocations));
      } else {
        emit(LocationFetchSuccess(locations: filtered.toList()));
      }
    }
    log(query);
  }

  void _onSearchLocationByCoordiantesRequested(
      LocationSearchByCoordinatesRequested event,
      Emitter<LocationSearchState> emit) async {
    emit(const LocationFetchInProgess());
    try {
      final coordinates = await _weatherRepository.getDeviceCoordinates();
      final fetchedLocations =
          await _weatherRepository.getLocationByCoordinates(coordinates);
      if (fetchedLocations.isEmpty) {
        //Todo: throw exception
        log('Location empty');
        return;
      }
      //Search for physical location
      final index = event.userLocations.indexWhere((element) =>
          element.locationType == LocationType.physical ||
          fetchedLocations.first.woeid == element.woeid);
      List<Location> userLocations;
      if (index.isNegative) {
        userLocations = event.userLocations.toList()
          ..insert(0, fetchedLocations.first);
      } else {
        userLocations = event.userLocations.toList()
          ..removeAt(index)
          ..insert(0, fetchedLocations.first);
      }
      emit(
        LocationAddSuccess(locations: userLocations),
      );
    } on Exception catch (e) {
      emit(LocationFetchFail(e: e));
    }
  }

  void _onLocationSearchLocationSelected(LocationSearchLocationSelected event,
      Emitter<LocationSearchState> emit) async {
    final selectedLocation = event.selectedLocation;
    switch (event.selectedLocation.locationType) {
      case LocationType.physical:
        final index = event.userLocations.indexWhere(
            (element) => element.locationType == LocationType.physical);
        emit(LocationAddSuccess(
            locations: event.userLocations.toList()
              ..removeAt(index)
              ..insert(0, selectedLocation)));

        break;
      case LocationType.saved:
        final index = event.userLocations
            .indexWhere((element) => element.woeid == selectedLocation.woeid);
        emit(LocationAddSuccess(
            locations: event.userLocations.toList()
              ..removeAt(index)
              ..insert(0, selectedLocation)));

        break;
      case LocationType.history:
      case LocationType.fetched:
        emit(LocationAddSuccess(
            locations: event.userLocations.toList()
              ..insert(
                  0,
                  selectedLocation.copyWith(
                      locationType: LocationType.saved))));
        break;
    }
  }
}

//Debounce query requests
EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) {
    return events.debounce(duration).switchMap(mapper);
  };
}
