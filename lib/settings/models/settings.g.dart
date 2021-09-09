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
          tempUnitSystem: $checkedConvert('temp_unit_system',
              (v) => _$enumDecode(_$TempUnitSystemEnumMap, v)),
          themeLight: $checkedConvert(
              'theme_light', (v) => _$enumDecode(_$ThemeLightEnumMap, v)),
          distanceSystem: $checkedConvert('distance_system',
              (v) => _$enumDecode(_$DistanceSystemEnumMap, v)),
          locale: $checkedConvert(
              'locale', (v) => const LocaleSerialiser().fromJson(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'tempUnitSystem': 'temp_unit_system',
        'themeLight': 'theme_light',
        'distanceSystem': 'distance_system'
      },
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'temp_unit_system': _$TempUnitSystemEnumMap[instance.tempUnitSystem],
      'theme_light': _$ThemeLightEnumMap[instance.themeLight],
      'distance_system': _$DistanceSystemEnumMap[instance.distanceSystem],
      'locale': const LocaleSerialiser().toJson(instance.locale),
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

const _$ThemeLightEnumMap = {
  ThemeLight.dartk: 'dartk',
  ThemeLight.light: 'light',
  ThemeLight.system: 'system',
};

const _$DistanceSystemEnumMap = {
  DistanceSystem.metric: 'metric',
  DistanceSystem.imperial: 'imperial',
};
