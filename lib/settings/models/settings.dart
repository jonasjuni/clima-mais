import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
part 'settings.g.dart';

enum TempUnitSystem { celsius, fahrenheit }
enum ThemeLight { dartk, light, system }
enum DistanceSystem { metric, imperial }

@JsonSerializable()
class Settings {
  final TempUnitSystem tempUnitSystem;
  final ThemeLight themeLight;
  final DistanceSystem distanceSystem;
  @LocaleSerialiser()
  final Locale? locale;

  const Settings({
    required this.tempUnitSystem,
    required this.themeLight,
    required this.distanceSystem,
    this.locale,
  });

  Settings copyWith({
    tempUnitSystem,
    themeLight,
    distanceSystem,
    locale,
  }) {
    return Settings(
        tempUnitSystem: tempUnitSystem ?? this.tempUnitSystem,
        themeLight: themeLight ?? this.themeLight,
        distanceSystem: distanceSystem ?? this.distanceSystem,
        locale: locale ?? this.locale);
  }

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}

class LocaleSerialiser implements JsonConverter<Locale?, String> {
  const LocaleSerialiser();
  @override
  Locale? fromJson(String json) {
    if (json == '') return null;
    final bcp47 = json.split('-');
    if (bcp47.length == 1) {
      return Locale.fromSubtags(languageCode: bcp47[0]);
    } else if (bcp47.length == 2) {
      return Locale.fromSubtags(languageCode: bcp47[0], countryCode: bcp47[1]);
    } else {
      return Locale.fromSubtags(
          languageCode: bcp47[0], scriptCode: bcp47[1], countryCode: bcp47[2]);
    }
  }

  @override
  String toJson(Locale? object) {
    if (object == null) return '';
    return object.toLanguageTag();
  }
}
