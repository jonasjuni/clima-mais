part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {
  const SettingsEvent();
}

class SettingsThemeModeChanged extends SettingsEvent {
  final ThemeMode themeMode;
  const SettingsThemeModeChanged(this.themeMode);
}

class SettingsTempUnitChanged extends SettingsEvent {
  final TempUnitSystem tempUnitSystem;
  const SettingsTempUnitChanged(this.tempUnitSystem);
}

class SettingsLenghtUnitChanged extends SettingsEvent {
  final LenghtUnit lenghtUnit;
  const SettingsLenghtUnitChanged(this.lenghtUnit);
}

class SettingsLocaleChanged extends SettingsEvent {
  final Locale locale;
  const SettingsLocaleChanged(this.locale);
}
