import 'dart:ui';
import 'package:clima_mais/repositories/models/location.dart';

enum TempUnitSystem { celsius, fahrenheit }
enum DistanceSystem { metric, imperial }

class Settings {
  const Settings({
    required this.isUserFirstAccess,
    required this.isPhysicalLocationEmpty,
    required this.tempUnitSystem,
    this.themeBrightness,
    required this.distanceSystem,
    this.locale,
    required this.userLocations,
  });

  final bool isUserFirstAccess;
  final bool isPhysicalLocationEmpty;
  final TempUnitSystem tempUnitSystem;
  final Brightness? themeBrightness;
  final DistanceSystem distanceSystem;
  final Locale? locale;
  final List<Location> userLocations;

  Settings copyWith({
    bool? isUserFirstAccess,
    bool? isPhysicalLocationEmpty,
    TempUnitSystem? tempUnitSystem,
    Brightness? themeBrightness,
    DistanceSystem? distanceSystem,
    Locale? locale,
    List<Location>? userLocations,
  }) {
    return Settings(
      isUserFirstAccess: isUserFirstAccess ?? this.isUserFirstAccess,
      isPhysicalLocationEmpty:
          isPhysicalLocationEmpty ?? this.isPhysicalLocationEmpty,
      tempUnitSystem: tempUnitSystem ?? this.tempUnitSystem,
      themeBrightness: themeBrightness ?? this.themeBrightness,
      distanceSystem: distanceSystem ?? this.distanceSystem,
      locale: locale ?? this.locale,
      userLocations: userLocations ?? this.userLocations,
    );
  }
}
