part of 'settings_bloc.dart';

@immutable
abstract class SettingsState {
  final Settings settings;

  const SettingsState(this.settings);
}

class SettingsInitial extends SettingsState {
  const SettingsInitial()
      : super(const Settings(
          tempUnitSystem: TempUnitSystem.celsius,
          themeLight: ThemeLight.system,
          distanceSystem: DistanceSystem.metric,
        ));

  const SettingsInitial.imperial()
      : super(const Settings(
          tempUnitSystem: TempUnitSystem.fahrenheit,
          themeLight: ThemeLight.system,
          distanceSystem: DistanceSystem.imperial,
        ));
}

class SettingsInProgress extends SettingsState {
  const SettingsInProgress(Settings settings) : super(settings);
}
