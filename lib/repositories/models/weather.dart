import 'models.dart';

class Weather {
  final List<WeatherForecast> weatherForecasts;
  final Coordinates lattLong;
  final DateTime sunRise;
  final DateTime sunSet;
  final String timezone;
  final String timezoneName;
  final String title;
  final DateTime time;
  final int woeid;

  Weather(
    this.weatherForecasts,
    this.lattLong,
    this.sunRise,
    this.sunSet,
    this.time,
    this.timezone,
    this.timezoneName,
    this.title,
    this.woeid,
  );
}
