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
          lenghtUnit: LenghtUnit.metric,
          themeMode: ThemeMode.system,
        ));

  const SettingsInitial.imperial()
      : super(const Settings(
          tempUnitSystem: TempUnitSystem.fahrenheit,
          lenghtUnit: LenghtUnit.imperial,
          themeMode: ThemeMode.system,
        ));
}

class SettingsLoadSuccess extends SettingsState {
  const SettingsLoadSuccess(Settings settings) : super(settings);
}
