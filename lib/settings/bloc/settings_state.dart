part of 'settings_bloc.dart';

@immutable
abstract class SettingsState {
  final Settings settings;

  const SettingsState(this.settings);
}

class SettingsInitial extends SettingsState {
  const SettingsInitial()
      : super(const Settings(
          isUserFirstAccess: true,
          tempUnitSystem: TempUnitSystem.celsius,
          distanceSystem: DistanceSystem.metric,
          userLocations: <UserLocation>[],
        ));

  const SettingsInitial.imperial()
      : super(const Settings(
          isUserFirstAccess: true,
          tempUnitSystem: TempUnitSystem.fahrenheit,
          distanceSystem: DistanceSystem.imperial,
          userLocations: <UserLocation>[],
        ));
}

class SettingsInProgress extends SettingsState {
  const SettingsInProgress(Settings settings) : super(settings);
}
