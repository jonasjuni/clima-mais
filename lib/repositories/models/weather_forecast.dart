enum WeatherCondition {
  cloudy,
  fog,
  hail,
  heavyRain,
  heavySnow,
  lightRain,
  lightSnow,
  mediumRain,
  mediumSnow,
  showers,
  partlyCloudy,
  sleet,
  smog,
  sunny,
  thunderstorm,
  unknown,
}

const _weatherConditionEnumMap = {
  WeatherCondition.cloudy: 'cloudy',
  WeatherCondition.fog: 'fog',
  WeatherCondition.hail: 'hail',
  WeatherCondition.heavyRain: 'heavy_rain',
  WeatherCondition.heavySnow: 'heavy_snow',
  WeatherCondition.lightRain: 'light_rain',
  WeatherCondition.lightSnow: 'light_snow',
  WeatherCondition.mediumRain: 'medium_rain',
  WeatherCondition.mediumSnow: 'medium_snow',
  WeatherCondition.partlyCloudy: 'partly_cloudy',
  WeatherCondition.showers: 'showers',
  WeatherCondition.sleet: 'sleet',
  WeatherCondition.smog: 'smog',
  WeatherCondition.sunny: 'sunny',
  WeatherCondition.thunderstorm: 'thunderstorm',
  WeatherCondition.unknown: 'unkown',
};

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
    required this.date,
  });

  final WeatherCondition condition;
  final String weatherStateName;
  final double minTemp;
  final double maxTemp;
  final double temp;
  final double humidity;
  final double airPressure;
  final double windSpeed;
  final String windDirection;
  final DateTime created;
  final DateTime date;

  String get conditionAnimation => _weatherConditionEnumMap[condition]!;
}
