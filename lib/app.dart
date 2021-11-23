import 'package:clima_mais/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:clima_mais/weather/weather.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/settings/bloc/settings_bloc.dart';

class ClimaMaisApp extends StatelessWidget {
  const ClimaMaisApp(
      {Key? key, required this.settingsBloc, required this.weatherRepository})
      : super(key: key);

  final SettingsBloc settingsBloc;
  final WeatherRepository weatherRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: weatherRepository,
      child: BlocProvider.value(
        value: settingsBloc,
        child: const ClimaMaisPage(),
      ),
    );
  }
}

class ClimaMaisPage extends StatelessWidget {
  const ClimaMaisPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      locale: null,
      themeMode:
          context.select((SettingsBloc bloc) => bloc.state.settings.themeMode),
      theme: ThemeData(
        primarySwatch: Colors.orange,
        appBarTheme:
            const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
        textTheme: textTheme,
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme:
            const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
        textTheme: textTheme,
      ),
      title: 'Clima Mais',
      home: const WeatherHomePage(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
