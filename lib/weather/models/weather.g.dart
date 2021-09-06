// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) {
  return $checkedNew('Weather', json, () {
    final val = Weather(
      $checkedConvert(
          json,
          'weather_state_abbr',
          (v) => _$enumDecode(_$WeatherConditionEnumMap, v,
              unknownValue: WeatherCondition.unknown)),
      $checkedConvert(json, 'weather_state_name', (v) => v as String),
      $checkedConvert(json, 'min_temp', (v) => (v as num).toDouble()),
      $checkedConvert(json, 'max_temp', (v) => (v as num).toDouble()),
      $checkedConvert(json, 'the_temp', (v) => (v as num).toDouble()),
      $checkedConvert(json, 'created', (v) => DateTime.parse(v as String)),
    );
    return val;
  }, fieldKeyMap: const {
    'condition': 'weather_state_abbr',
    'weatherStateName': 'weather_state_name',
    'minTemp': 'min_temp',
    'maxTemp': 'max_temp',
    'temp': 'the_temp'
  });
}

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'weather_state_abbr': _$WeatherConditionEnumMap[instance.condition],
      'weather_state_name': instance.weatherStateName,
      'min_temp': instance.minTemp,
      'max_temp': instance.maxTemp,
      'the_temp': instance.temp,
      'created': instance.created.toIso8601String(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
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
