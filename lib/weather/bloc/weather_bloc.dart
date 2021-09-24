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
    on<WeatherRequested>(_onWeatherRequested);
    on<WeatherRefreshed>(_onWeatherRefreshed);
  }

  void _onWeatherRequested(
      WeatherRequested event, Emitter<WeatherState> emit) async {
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
      WeatherRefreshed event, Emitter<WeatherState> emit) async {
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

extension WeatherXTemperature on WeatherForecast {
  double get farenheitTemp {
    return _convertToFahrenheit(temp);
  }

  double get farenheitMaxTemp {
    return _convertToFahrenheit(maxTemp);
  }

  double get farenheitMinTemp {
    return _convertToFahrenheit(minTemp);
  }

  double _convertToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }
}
