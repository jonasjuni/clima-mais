part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {
  const WeatherState();
}

class WeatherInitial extends WeatherState {}

class WeatherLoadInProgress extends WeatherState {}

class WeatherLoadSuccess extends WeatherState {
  final Weather weather;
  const WeatherLoadSuccess(this.weather);
}

class WeatherLoadFailure extends WeatherState {
  final String requestedCity;
  final Exception exception;

  const WeatherLoadFailure(
      {required this.exception, required this.requestedCity});
}
