import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:clima_mais/repositories/repositories.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherBloc({required this.weatherRepository})
      : super(const WeatherInitial()) {
    // New bloc API
    on<WeatherRequested>(_onWeatherRequested);
    on<WeatherRefreshed>(_onWeatherRefreshed);
  }

  void _onWeatherRequested(
      WeatherRequested event, Emitter<WeatherState> emit) async {
    emit(const WeatherLoadInProgress());
    final locations = event.locations;
    try {
      final id = locations[0].woeid;
      final weather = await weatherRepository.getWeatherById(id);

      emit(WeatherLoadSuccess(weather: weather, locations: locations));
    } on Exception catch (e) {
      emit(WeatherLoadFailure(exception: e, locations: locations));
    }
  }

  void _onWeatherRefreshed(
      WeatherRefreshed event, Emitter<WeatherState> emit) async {
    final locations = event.locations;
    try {
      final id = locations[0].woeid;
      final weather = await weatherRepository.getWeatherById(id);

      emit(WeatherLoadSuccess(weather: weather, locations: locations));
    } on Exception catch (e) {
      emit(WeatherLoadFailure(exception: e, locations: locations));
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
