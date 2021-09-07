part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {
  const WeatherEvent();
}

class WeatherRequested extends WeatherEvent {
  final String city;

  const WeatherRequested({required this.city});
}

class WeatherRefreshed extends WeatherEvent {
  final String city;
  const WeatherRefreshed({required this.city});
}
