part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {
  const WeatherEvent();
}

class WeatherRequested extends WeatherEvent {
  final List<Location> locations;
  const WeatherRequested({required this.locations});
}

class WeatherRefreshed extends WeatherEvent {
  final List<Location> locations;
  const WeatherRefreshed({required this.locations});
}
