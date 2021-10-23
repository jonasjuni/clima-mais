import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:clima_mais/repositories/models/location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

enum TempUnitSystem { celsius, fahrenheit }
enum LenghtUnit { metric, imperial }

@JsonSerializable()
class Settings {
  const Settings({
    required this.tempUnitSystem,
    required this.lenghtUnit,
    required this.themeMode,
    this.locale,
  });

  final TempUnitSystem tempUnitSystem;
  final LenghtUnit lenghtUnit;
  final ThemeMode themeMode;
  @LocaleSerialiser()
  final Locale? locale;

  Settings copyWith({
    TempUnitSystem? tempUnitSystem,
    LenghtUnit? lenghtUnit,
    ThemeMode? themeMode,
    Locale? locale,
    List<Location>? userLocations,
  }) {
    return Settings(
      tempUnitSystem: tempUnitSystem ?? this.tempUnitSystem,
      lenghtUnit: lenghtUnit ?? this.lenghtUnit,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  bool get isFahrenheit => tempUnitSystem == TempUnitSystem.fahrenheit;
  bool get isCelsius => tempUnitSystem == TempUnitSystem.celsius;

  bool get isImperial => lenghtUnit == LenghtUnit.imperial;
  bool get isMetric => lenghtUnit == LenghtUnit.metric;

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
    } else
      return Locale.fromSubtags(
          languageCode: bcp47[0], scriptCode: bcp47[1], countryCode: bcp47[2]);
  }

  @override
  String toJson(Locale? object) {
    if (object == null) return '';
    return object.toLanguageTag();
  }
}
