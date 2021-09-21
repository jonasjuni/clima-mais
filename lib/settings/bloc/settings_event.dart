part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {
  const SettingsEvent();
}

class ThemeBrightnessChanged extends SettingsEvent {
  final Brightness themeBrightness;
  const ThemeBrightnessChanged(this.themeBrightness);
}

class TempUnitChanged extends SettingsEvent {
  final TempUnitSystem tempUnitSystem;
  const TempUnitChanged(this.tempUnitSystem);
}

class DeviceLocationRequested extends SettingsEvent {
  const DeviceLocationRequested();
}

class DistanceSystemChanged extends SettingsEvent {
  final DistanceSystem distanceSystem;
  const DistanceSystemChanged(this.distanceSystem);
}

class LocaleChanged extends SettingsEvent {
  final Locale locale;
  const LocaleChanged(this.locale);
}
