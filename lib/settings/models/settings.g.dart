// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Settings',
      json,
      ($checkedConvert) {
        final val = Settings(
          isUserFirstAccess:
              $checkedConvert('is_user_first_access', (v) => v as bool),
          tempUnitSystem: $checkedConvert('temp_unit_system',
              (v) => _$enumDecode(_$TempUnitSystemEnumMap, v)),
          themeBrightness: $checkedConvert('theme_brightness',
              (v) => _$enumDecodeNullable(_$BrightnessEnumMap, v)),
          distanceSystem: $checkedConvert('distance_system',
              (v) => _$enumDecode(_$DistanceSystemEnumMap, v)),
          locale: $checkedConvert(
              'locale', (v) => const LocaleSerialiser().fromJson(v as String)),
          userLocations: $checkedConvert(
              'user_locations',
              (v) => (v as List<dynamic>)
                  .map((e) => UserLocation.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'isUserFirstAccess': 'is_user_first_access',
        'tempUnitSystem': 'temp_unit_system',
        'themeBrightness': 'theme_brightness',
        'distanceSystem': 'distance_system',
        'userLocations': 'user_locations'
      },
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'is_user_first_access': instance.isUserFirstAccess,
      'temp_unit_system': _$TempUnitSystemEnumMap[instance.tempUnitSystem],
      'theme_brightness': _$BrightnessEnumMap[instance.themeBrightness],
      'distance_system': _$DistanceSystemEnumMap[instance.distanceSystem],
      'locale': const LocaleSerialiser().toJson(instance.locale),
      'user_locations': instance.userLocations.map((e) => e.toJson()).toList(),
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

const _$TempUnitSystemEnumMap = {
  TempUnitSystem.celsius: 'celsius',
  TempUnitSystem.fahrenheit: 'fahrenheit',
};

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$BrightnessEnumMap = {
  Brightness.dark: 'dark',
  Brightness.light: 'light',
};

const _$DistanceSystemEnumMap = {
  DistanceSystem.metric: 'metric',
  DistanceSystem.imperial: 'imperial',
};

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserLocation',
      json,
      ($checkedConvert) {
        final val = UserLocation(
          woeid: $checkedConvert('woeid', (v) => v as int),
          isDeviceLocation:
              $checkedConvert('is_device_location', (v) => v as bool? ?? false),
        );
        return val;
      },
      fieldKeyMap: const {'isDeviceLocation': 'is_device_location'},
    );

Map<String, dynamic> _$UserLocationToJson(UserLocation instance) =>
    <String, dynamic>{
      'woeid': instance.woeid,
      'is_device_location': instance.isDeviceLocation,
    };
