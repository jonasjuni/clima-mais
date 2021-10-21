import 'package:clima_mais/settings/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_mais/settings/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settingsTitle),
      ),
      body: const SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TempSettings(),
        Divider(),
        LenghtUnitSettings(),
        Divider(),
        ThemeBrightnessSettings(),
      ],
    );
  }
}

class TempSettings extends StatelessWidget {
  const TempSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tempUnits = context.select(
        (SettingsBloc element) => element.state.settings.tempUnitSystem);
    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context).settingsTemp),
        ),
        RadioListTile(
            title: const Text('Celsius'),
            value: TempUnitSystem.celsius,
            groupValue: tempUnits,
            onChanged: (TempUnitSystem? value) => value != null
                ? context
                    .read<SettingsBloc>()
                    .add(SettingsTempUnitChanged(value))
                : null),
        RadioListTile(
            title: const Text('Fahrenheit'),
            value: TempUnitSystem.fahrenheit,
            groupValue: tempUnits,
            onChanged: (TempUnitSystem? value) => value != null
                ? context
                    .read<SettingsBloc>()
                    .add(SettingsTempUnitChanged(value))
                : null),
      ],
    );
  }
}

class ThemeBrightnessSettings extends StatelessWidget {
  const ThemeBrightnessSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tempUnits = context
        .select((SettingsBloc element) => element.state.settings.themeMode);
    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context).settingsTheme),
        ),
        RadioListTile<ThemeMode>(
          title: Text(AppLocalizations.of(context).settingsThemeSystem),
          value: ThemeMode.system,
          groupValue: tempUnits,
          onChanged: (ThemeMode? value) => value != null
              ? context
                  .read<SettingsBloc>()
                  .add(SettingsThemeModeChanged(value))
              : null,
        ),
        RadioListTile<ThemeMode>(
          title: Text(AppLocalizations.of(context).settingsThemeLight),
          value: ThemeMode.light,
          groupValue: tempUnits,
          onChanged: (ThemeMode? value) => value != null
              ? context
                  .read<SettingsBloc>()
                  .add(SettingsThemeModeChanged(value))
              : null,
        ),
        RadioListTile<ThemeMode?>(
          title: Text(AppLocalizations.of(context).settingsThemeDarkMode),
          value: ThemeMode.dark,
          groupValue: tempUnits,
          onChanged: (ThemeMode? value) => value != null
              ? context
                  .read<SettingsBloc>()
                  .add(SettingsThemeModeChanged(value))
              : null,
        ),
      ],
    );
  }
}

class LenghtUnitSettings extends StatelessWidget {
  const LenghtUnitSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lenghtUnit = context
        .select((SettingsBloc element) => element.state.settings.lenghtUnit);
    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context).settingsUnitLenght),
        ),
        RadioListTile<LenghtUnit>(
            title: Text(AppLocalizations.of(context).settingsUnitLenghtMetric),
            value: LenghtUnit.metric,
            groupValue: lenghtUnit,
            onChanged: (LenghtUnit? value) => value != null
                ? context
                    .read<SettingsBloc>()
                    .add(SettingsLenghtUnitChanged(value))
                : null),
        RadioListTile<LenghtUnit>(
            title: const Text('Imperial'),
            value: LenghtUnit.imperial,
            groupValue: lenghtUnit,
            onChanged: (LenghtUnit? value) => value != null
                ? context
                    .read<SettingsBloc>()
                    .add(SettingsLenghtUnitChanged(value))
                : null),
      ],
    );
  }
}
