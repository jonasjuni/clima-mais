import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_mais/settings/bloc/settings_bloc.dart';
import 'package:clima_mais/settings/settings.dart';

class SettingsPageView extends StatelessWidget {
  const SettingsPageView({Key? key}) : super(key: key);
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
    return ListView(
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
    final tempUnits = context
        .select((SettingsBloc element) => element.state.settings.themeLight);
    return Column(
      children: [
        RadioListTile(
            title: const Text('Light'), //TODO localize
            value: ThemeLight.light,
            groupValue: tempUnits,
            onChanged: (ThemeLight? value) => (value != null)
                ? context.read<SettingsBloc>().add(ThemeLightChanged(value))
                : null),
        RadioListTile(
            title: const Text('Dark'), //TODO localize
            value: ThemeLight.dartk,
            groupValue: tempUnits,
            onChanged: (ThemeLight? value) => (value != null)
                ? context.read<SettingsBloc>().add(ThemeLightChanged(value))
                : null),
        RadioListTile(
            title: const Text('System'), //TODO localize
            value: ThemeLight.system,
            groupValue: tempUnits,
            onChanged: (ThemeLight? value) => (value != null)
                ? context.read<SettingsBloc>().add(ThemeLightChanged(value))
                : null),
      ],
    );
  }
}
