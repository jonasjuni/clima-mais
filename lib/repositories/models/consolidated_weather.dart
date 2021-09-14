enum WeatherCondition {
  snow,
  sleet,
  hail,
  thunderstorm,
  heavyRain,
  lightRain,
  showers,
  heavyCloud,
  lightCloud,
  clear,
  unknown,
}

class WeatherForecast {
  WeatherForecast(
      this.condition,
      this.weatherStateName,
      this.minTemp,
      this.maxTemp,
      this.temp,
      this.humidity,
      this.airPressure,
      this.windSpeed,
      this.windDirection,
      this.created);

  final WeatherCondition condition;
  final String weatherStateName;
  final double minTemp;
  final double maxTemp;
  final double temp;
  final double humidity;
  final double airPressure;
  final double windSpeed;
  final double windDirection;
  final DateTime created;
}
