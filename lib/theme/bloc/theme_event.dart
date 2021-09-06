part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {
  const ThemeEvent();
}

class WeatherChanged extends ThemeEvent {
  final Weather weather;
  const WeatherChanged({required this.weather});
}
