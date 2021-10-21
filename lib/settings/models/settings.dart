import 'dart:ui';
import 'package:clima_mais/repositories/models/location.dart';
import 'package:flutter/material.dart';

enum TempUnitSystem { celsius, fahrenheit }
enum LenghtUnit { metric, imperial }

class Settings {
  const Settings({
    required this.isUserFirstAccess,
    required this.isPhysicalLocationEmpty,
    required this.tempUnitSystem,
    required this.themeMode,
    required this.lenghtUnit,
    this.locale,
    required this.userLocations,
  });

  final bool isUserFirstAccess;
  final bool isPhysicalLocationEmpty;
  final TempUnitSystem tempUnitSystem;
  final ThemeMode themeMode;
  final LenghtUnit lenghtUnit;
  final Locale? locale;
  final List<Location> userLocations;

  Settings copyWith({
    bool? isUserFirstAccess,
    bool? isPhysicalLocationEmpty,
    TempUnitSystem? tempUnitSystem,
    ThemeMode? themeMode,
    LenghtUnit? lenghtUnit,
    Locale? locale,
    List<Location>? userLocations,
  }) {
    return Settings(
      isUserFirstAccess: isUserFirstAccess ?? this.isUserFirstAccess,
      isPhysicalLocationEmpty:
          isPhysicalLocationEmpty ?? this.isPhysicalLocationEmpty,
      tempUnitSystem: tempUnitSystem ?? this.tempUnitSystem,
      themeMode: themeMode ?? this.themeMode,
      lenghtUnit: lenghtUnit ?? this.lenghtUnit,
      locale: locale ?? this.locale,
      userLocations: userLocations ?? this.userLocations,
    );
  }
}
