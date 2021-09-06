part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {
  const SettingsEvent();
}

class ThemeLightChanged extends SettingsEvent {
  final ThemeLight themeLight;

  ThemeLightChanged(this.themeLight);
}

class TempUnitChanged extends SettingsEvent {
  final TempUnitSystem tempUnitSystem;

  TempUnitChanged(this.tempUnitSystem);
}

class DistanceSystemChanged extends SettingsEvent {
  final DistanceSystem distanceSystem;

  DistanceSystemChanged(this.distanceSystem);
}

class LocaleChanged extends SettingsEvent {
  final Locale locale;

  LocaleChanged(this.locale);
}
