import 'dart:ui';
import 'package:json_annotation/json_annotation.dart';
part 'settings.g.dart';

enum TempUnitSystem { celsius, fahrenheit }
enum DistanceSystem { metric, imperial }

@JsonSerializable()
class Settings {
  const Settings({
    required this.isUserFirstAccess,
    required this.tempUnitSystem,
    this.themeBrightness,
    required this.distanceSystem,
    this.locale,
    required this.userLocations,
  });

  final bool isUserFirstAccess;
  final TempUnitSystem tempUnitSystem;
  final Brightness? themeBrightness;
  final DistanceSystem distanceSystem;
  @LocaleSerialiser()
  final Locale? locale;
  final List<UserLocation> userLocations;

  Settings copyWith({
    bool? isUserFirstAccess,
    TempUnitSystem? tempUnitSystem,
    Brightness? themeBrightness,
    DistanceSystem? distanceSystem,
    Locale? locale,
    List<UserLocation>? userLocations,
  }) {
    return Settings(
      isUserFirstAccess: isUserFirstAccess ?? this.isUserFirstAccess,
      tempUnitSystem: tempUnitSystem ?? this.tempUnitSystem,
      themeBrightness: themeBrightness ?? this.themeBrightness,
      distanceSystem: distanceSystem ?? this.distanceSystem,
      locale: locale ?? this.locale,
      userLocations: userLocations ?? this.userLocations,
    );
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

@JsonSerializable()
class UserLocation {
  const UserLocation({required this.woeid, this.isDeviceLocation = false});

  final int woeid;
  final bool isDeviceLocation;

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocationToJson(this);
}
