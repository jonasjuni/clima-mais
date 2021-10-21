part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {
  const WeatherEvent();
}

class WeatherFetchRequested extends WeatherEvent {
  final List<Location> locations;
  const WeatherFetchRequested({required this.locations});
}

class WeatherDataRefreshed extends WeatherEvent {
  const WeatherDataRefreshed();
}
