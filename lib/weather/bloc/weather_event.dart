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

class WeatherLocationOrderChanged extends WeatherEvent {
  const WeatherLocationOrderChanged(
      {required this.oldIndex,
      required this.newIndex,
      required this.locations});

  final int oldIndex, newIndex;
  final List<Location> locations;
}

class WeatherLocationDeleted extends WeatherEvent {
  const WeatherLocationDeleted({required this.index, required this.locations});
  final int index;
  final List<Location> locations;
}

class WeatherLocationSelected extends WeatherEvent {
  const WeatherLocationSelected({required this.index, required this.locations});
  final int index;
  final List<Location> locations;
}
