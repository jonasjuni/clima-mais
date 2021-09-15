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
  WeatherForecast({
    required this.condition,
    required this.weatherStateName,
    required this.minTemp,
    required this.maxTemp,
    required this.temp,
    required this.humidity,
    required this.airPressure,
    required this.windSpeed,
    required this.windDirection,
    required this.created,
  });

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

  String get abbr => _$WeatherConditionEnumMap[condition]!;
}

const _$WeatherConditionEnumMap = {
  WeatherCondition.snow: 'sn',
  WeatherCondition.sleet: 'sl',
  WeatherCondition.hail: 'h',
  WeatherCondition.thunderstorm: 't',
  WeatherCondition.heavyRain: 'hr',
  WeatherCondition.lightRain: 'lr',
  WeatherCondition.showers: 's',
  WeatherCondition.heavyCloud: 'hc',
  WeatherCondition.lightCloud: 'lc',
  WeatherCondition.clear: 'c',
  WeatherCondition.unknown: 'unknown',
};
