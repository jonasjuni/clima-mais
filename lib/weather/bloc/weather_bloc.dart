import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:clima_mais/repositories/repositories.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;
  WeatherBloc({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(const WeatherInitial()) {
    // New bloc API
    on<WeatherFetchRequested>(_onWeatherRequested);
    on<WeatherDataRefreshed>(_onWeatherRefreshed);
    on<WeatherLocationOrderChanged>(_onWeatherLocationOrderChanged);
  }

  void _onWeatherRequested(
      WeatherFetchRequested event, Emitter<WeatherState> emit) async {
    emit(const WeatherLoadInProgress());
    final locations = event.locations;
    try {
      final id = locations.first.woeid;
      final weather = await _weatherRepository.getWeatherById(id);

      emit(WeatherLoadSuccess(weather: weather, locations: locations));
    } on Exception catch (e) {
      emit(WeatherLoadFailure(exception: e, locations: locations));
    }
  }

  void _onWeatherRefreshed(
      WeatherDataRefreshed event, Emitter<WeatherState> emit) async {
    final currentState = state;

    if (currentState is WeatherLoadSuccess) {
      late Location refreshedLocation;
      final locations = currentState.locations;

      try {
        final currentLocation = locations.first;
        if (currentLocation.locationType == LocationType.physical) {
          //Update device location
          refreshedLocation = await _updateLocation(currentLocation);
        } else {
          refreshedLocation = currentLocation;
        }
        final weather =
            await _weatherRepository.getWeatherById(refreshedLocation.woeid);

        emit(WeatherLoadSuccess(weather: weather, locations: locations));
      } on Exception catch (e) {
        emit(WeatherLoadFailure(exception: e, locations: locations));
      }
    }
  }

  void _onWeatherLocationOrderChanged(
      WeatherLocationOrderChanged event, Emitter<WeatherState> emit) async {
    final currentState = state;
    var newIndex = event.newIndex;
    final oldIndex = event.oldIndex;
    if (newIndex > oldIndex) {
      newIndex--;
    }
    if (currentState is WeatherLoadSuccess) {
      final orderedList = event.locations.toList()
        ..removeAt(oldIndex)
        ..insert(newIndex, event.locations[oldIndex]);

      emit(WeatherLoadSuccess(
          weather: currentState.weather, locations: orderedList));

      if (oldIndex == 0 || newIndex == 0) {
        add(const WeatherDataRefreshed());
      }
    }
  }

  Future<Location> _updateLocation(Location currentLocation) async {
    try {
      final coordinates = await _weatherRepository.getDeviceCoordinates();
      if (currentLocation.lattLong == coordinates) {
        return currentLocation; //to save an api call =)
      } else {
        final updatedLocations =
            await _weatherRepository.getLocationByCoordinates(coordinates);
        return updatedLocations.first;
      }
    } catch (e) {
      return currentLocation.copyWith(locationType: LocationType.saved);
    }
  }
}
