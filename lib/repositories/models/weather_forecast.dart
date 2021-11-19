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

const _nightConditionColors = {
  WeatherCondition.cloudy: 0xFF0028A2,
  WeatherCondition.fog: 0xFF0028A2,
  WeatherCondition.hail: 0xFF0028A2,
  WeatherCondition.heavyRain: 0xFF0028A2,
  WeatherCondition.heavySnow: 0xFF0028A2,
  WeatherCondition.lightRain: 0xFF0028A2,
  WeatherCondition.lightSnow: 0xFF0028A2,
  WeatherCondition.mediumRain: 0xFF0028A2,
  WeatherCondition.mediumSnow: 0xFF0028A2,
  WeatherCondition.partlyCloudy: 0xFF0028A2,
  WeatherCondition.showers: 0xFF0028A2,
  WeatherCondition.sleet: 0xFF0028A2,
  WeatherCondition.smog: 0xFF0028A2,
  WeatherCondition.sunny: 0xFF0028A2,
  WeatherCondition.thunderstorm: 0xFF0028A2,
  WeatherCondition.unknown: 0xFF0028A2
};
const _dayConditionColors = {
  WeatherCondition.cloudy: 0xffffd759,
  WeatherCondition.fog: 0xffffd759,
  WeatherCondition.hail: 0xffffd759,
  WeatherCondition.heavyRain: 0xffffd759,
  WeatherCondition.heavySnow: 0xffffd759,
  WeatherCondition.lightRain: 0xffffd759,
  WeatherCondition.lightSnow: 0xffffd759,
  WeatherCondition.mediumRain: 0xffffd759,
  WeatherCondition.mediumSnow: 0xffffd759,
  WeatherCondition.partlyCloudy: 0xffffd759,
  WeatherCondition.showers: 0xffffd759,
  WeatherCondition.sleet: 0xffffd759,
  WeatherCondition.smog: 0xffffd759,
  WeatherCondition.sunny: 0xffffd759,
  WeatherCondition.thunderstorm: 0xffffd759,
  WeatherCondition.unknown: 0xffffd759
};

class Temperature {
  final double celsius, fahrenheit;

  Temperature.fromCelsius(this.celsius) : fahrenheit = (celsius * 9 / 5) + 32;
  Temperature.fromfahrenheit(this.fahrenheit)
      : celsius = (fahrenheit - 32) * 5 / 9;
}

class Distance {
  final double metric, imperial;

  Distance.fromImperial(this.imperial) : metric = imperial * 1.609344;
  Distance.fromMetric(this.metric) : imperial = metric * 0.62137;
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
    required this.date,
    required this.visibility,
    required this.predictability,
  });

  final WeatherCondition condition;
  final String weatherStateName;
  final Temperature minTemp;
  final Temperature maxTemp;
  final Temperature temp;
  final double humidity;
  final double airPressure;
  final Distance windSpeed;
  final String windDirection;
  final DateTime created;
  final DateTime date;
  final Distance visibility;
  final int predictability;

  String get conditionAnimation => _weatherConditionEnumMap[condition]!;
}

extension WeatherConditionX on WeatherCondition {
  int toColor(bool darkMode) =>
      darkMode ? _nightConditionColors[this]! : _dayConditionColors[this]!;

  String get toSnakeCase => _weatherConditionEnumMap[this]!;
}
