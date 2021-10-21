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
              (v) => $enumDecode(_$TempUnitSystemEnumMap, v)),
          lenghtUnit: $checkedConvert(
              'lenght_unit', (v) => $enumDecode(_$LenghtUnitEnumMap, v)),
          themeMode: $checkedConvert(
              'theme_mode', (v) => $enumDecode(_$ThemeModeEnumMap, v)),
          locale: $checkedConvert(
              'locale', (v) => const LocaleSerialiser().fromJson(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'tempUnitSystem': 'temp_unit_system',
        'lenghtUnit': 'lenght_unit',
        'themeMode': 'theme_mode'
      },
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'temp_unit_system': _$TempUnitSystemEnumMap[instance.tempUnitSystem],
      'lenght_unit': _$LenghtUnitEnumMap[instance.lenghtUnit],
      'theme_mode': _$ThemeModeEnumMap[instance.themeMode],
      'locale': const LocaleSerialiser().toJson(instance.locale),
    };

const _$TempUnitSystemEnumMap = {
  TempUnitSystem.celsius: 'celsius',
  TempUnitSystem.fahrenheit: 'fahrenheit',
};

const _$LenghtUnitEnumMap = {
  LenghtUnit.metric: 'metric',
  LenghtUnit.imperial: 'imperial',
};

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
