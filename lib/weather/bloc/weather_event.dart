part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {
  const WeatherEvent();
}

class WeatherRequested extends WeatherEvent {
  final int id;
  const WeatherRequested({required this.id});
}
