part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {
  const WeatherEvent();
}

class WeatherRequested extends WeatherEvent {
  final String city;

  const WeatherRequested({required this.city});
}

class WeatherRefreshRequested extends WeatherEvent {
  final String city;
  const WeatherRefreshRequested({required this.city});
}
