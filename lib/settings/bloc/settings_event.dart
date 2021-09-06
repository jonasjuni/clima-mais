part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {
  const SettingsEvent();
}

class ThemeLightChanged extends SettingsEvent {
  final ThemeLight themeLight;

  const ThemeLightChanged(this.themeLight);
}

class TempUnitChanged extends SettingsEvent {
  final TempUnitSystem tempUnitSystem;

  const TempUnitChanged(this.tempUnitSystem);
}

class DistanceSystemChanged extends SettingsEvent {
  final DistanceSystem distanceSystem;

  const DistanceSystemChanged(this.distanceSystem);
}

class LocaleChanged extends SettingsEvent {
  final Locale locale;

  const LocaleChanged(this.locale);
}
