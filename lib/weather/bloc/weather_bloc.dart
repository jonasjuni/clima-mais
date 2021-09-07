import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:clima_mais/repositories/repositories.dart';
import 'package:meta_weather/meta_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherBloc({required this.weatherRepository}) : super(WeatherInitial()) {
    on<WeatherRequested>(_onWeatherRequested);
    on<WeatherRefreshed>(_onWeatherRefreshed);
  }

  // New bloc API
  void _onWeatherRequested(
      WeatherRequested event, Emitter<WeatherState> emit) async {
    emit(WeatherLoadInProgress());
    try {
      final consolidatedWeather =
          await weatherRepository.getWeather(event.city);

      log(consolidatedWeather.consolidatedWeather[0].temp.toString());
      emit(WeatherLoadSuccess(consolidatedWeather));
    } on Exception catch (e) {
      emit(WeatherLoadFailure(exception: e));
    }
  }

  void _onWeatherRefreshed(
      WeatherRefreshed event, Emitter<WeatherState> emit) async {
    try {
      final consolidatedWeather =
          await weatherRepository.getWeather(event.city);

      emit(WeatherLoadSuccess(consolidatedWeather));
    } on Exception catch (e) {
      emit(WeatherLoadFailure(exception: e));
    }
  }

  //Hydrated bloc persistence
  @override
  WeatherState? fromJson(Map<String, dynamic> json) {
    try {
      final weather = Weather.fromJson(json);
      return WeatherLoadSuccess(weather);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(WeatherState state) {
    if (state is WeatherLoadSuccess) {
      return state.weather.toJson();
    } else {
      return null;
    }
  }
}

extension WeatherXTemperature on ConsolidatedWeather {
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
