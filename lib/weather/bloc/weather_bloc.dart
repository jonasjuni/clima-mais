import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:clima_mais/repositories/repositories.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherBloc({required this.weatherRepository}) : super(WeatherInitial()) {
    on<WeatherRequested>(_onWeatherRequested);
  }

  // New bloc API
  void _onWeatherRequested(
      WeatherRequested event, Emitter<WeatherState> emit) async {
    emit(WeatherLoadInProgress());
    try {
      final location = await weatherRepository.getLocationIdByName(event.city);

      final weather = await weatherRepository.getWeatherById(location[0].woeid);

      emit(WeatherLoadSuccess(weather));
    } on Exception catch (e) {
      emit(WeatherLoadFailure(exception: e, requestedCity: event.city));
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
