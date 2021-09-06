import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

enum WeatherCondition {
  @JsonValue('sn')
  snow,
  @JsonValue('sl')
  sleet,
  @JsonValue('h')
  hail,
  @JsonValue('t')
  thunderstorm,
  @JsonValue('hr')
  heavyRain,
  @JsonValue('lr')
  lightRain,
  @JsonValue('s')
  showers,
  @JsonValue('hc')
  heavyCloud,
  @JsonValue('lc')
  lightCloud,
  @JsonValue('c')
  clear,
  unknown
}

extension WeatherStateX on WeatherCondition {
  String? get abbr => _$WeatherConditionEnumMap[this];
}

@JsonSerializable()
class Weather {
  @JsonKey(
      name: 'weather_state_abbr', unknownEnumValue: WeatherCondition.unknown)
  final WeatherCondition condition;
  final String weatherStateName;
  final double minTemp;
  final double maxTemp;
  @JsonKey(name: 'the_temp')
  final double temp;
  final DateTime created;
  @JsonKey(ignore: true)
  final DateTime lasUpdated = DateTime.now();

  Weather(this.condition, this.weatherStateName, this.minTemp, this.maxTemp,
      this.temp, this.created);

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
