part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {
  const WeatherState();
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoadInProgress extends WeatherState {
  const WeatherLoadInProgress();
}

class WeatherLoadSuccess extends WeatherState {
  final Weather weather;
  final List<Location> locations;
  const WeatherLoadSuccess(
      {required this.weather, this.locations = const <Location>[]});
}

class WeatherLoadFailure extends WeatherState {
  final Exception exception;
  const WeatherLoadFailure({required this.exception});
}
