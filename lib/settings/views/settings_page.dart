import 'package:clima_mais/settings/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_mais/settings/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'), // TODO localize
      ),
      body: const SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ListTile(
          title: Text('Temperature units'), // TODO localize
        ),
        TempSettings(),
        Divider(),
        ListTile(
          title: Text('Theme mode'), //TODO localize
        ),
        ThemeLightSettings(),
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
        RadioListTile(
            title: const Text('Celsius'), //TODO localize
            value: TempUnitSystem.celsius,
            groupValue: tempUnits,
            onChanged: (TempUnitSystem? value) => (value != null)
                ? context.read<SettingsBloc>().add(TempUnitChanged(value))
                : null),
        RadioListTile(
            title: const Text('Fahrenheit'), //TODO localize
            value: TempUnitSystem.fahrenheit,
            groupValue: tempUnits,
            onChanged: (TempUnitSystem? value) => (value != null)
                ? context.read<SettingsBloc>().add(TempUnitChanged(value))
                : null),
      ],
    );
  }
}

class ThemeLightSettings extends StatelessWidget {
  const ThemeLightSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tempUnits = context.select(
        (SettingsBloc element) => element.state.settings.themeBrightness);
    return Column(
      children: [
        RadioListTile<Brightness?>(
            title: const Text('Light'), //TODO localize
            value: Brightness.light,
            groupValue: tempUnits,
            onChanged: (Brightness? value) => (value != null)
                ? context
                    .read<SettingsBloc>()
                    .add(ThemeBrightnessChanged(value))
                : null),
        RadioListTile<Brightness?>(
            title: const Text('Dark'), //TODO localize
            value: Brightness.dark,
            groupValue: tempUnits,
            onChanged: (Brightness? value) => (value != null)
                ? context
                    .read<SettingsBloc>()
                    .add(ThemeBrightnessChanged(value))
                : null),
        RadioListTile<Brightness?>(
            title: const Text('System'), //TODO localize
            value: null,
            groupValue: tempUnits,
            onChanged: (Brightness? value) => value != null
                ? context
                    .read<SettingsBloc>()
                    .add(ThemeBrightnessChanged(value))
                : null),
      ],
    );
  }
}
