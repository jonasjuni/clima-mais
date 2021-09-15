part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {
  const WeatherState();
}

class WeatherInitial extends WeatherState {}

class WeatherLoadInProgress extends WeatherState {
  final String? cityName;
  const WeatherLoadInProgress({this.cityName});
}

class WeatherLoadSuccess extends WeatherState {
  final Weather weather;
  const WeatherLoadSuccess(this.weather);
}

class WeatherLoadFailure extends WeatherState {
  final int id;
  final Exception exception;

  const WeatherLoadFailure({required this.exception, required this.id});
}
