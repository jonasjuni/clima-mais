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
          lenghtUnit: LenghtUnit.metric,
          userLocations: <Location>[],
          themeMode: ThemeMode.system,
        ));

  const SettingsInitial.imperial()
      : super(const Settings(
          isUserFirstAccess: true,
          isPhysicalLocationEmpty: true,
          tempUnitSystem: TempUnitSystem.fahrenheit,
          lenghtUnit: LenghtUnit.imperial,
          userLocations: <Location>[],
          themeMode: ThemeMode.system,
        ));
}

class SettingsLoadSuccess extends SettingsState {
  const SettingsLoadSuccess(Settings settings) : super(settings);
}
