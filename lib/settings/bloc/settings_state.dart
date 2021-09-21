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
          isPhysicalLocationEmpty: true,
          tempUnitSystem: TempUnitSystem.celsius,
          distanceSystem: DistanceSystem.metric,
          userLocations: <Location>[],
        ));

  const SettingsInitial.imperial()
      : super(const Settings(
          isUserFirstAccess: true,
          isPhysicalLocationEmpty: true,
          tempUnitSystem: TempUnitSystem.fahrenheit,
          distanceSystem: DistanceSystem.imperial,
          userLocations: <Location>[],
        ));
}

class SettingsInProgress extends SettingsState {
  const SettingsInProgress(Settings settings) : super(settings);
}
