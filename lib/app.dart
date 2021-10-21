import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/weather/weather.dart';
import 'package:clima_mais/settings/bloc/settings_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClimaMaisApp extends StatelessWidget {
  final WeatherRepository weatherRepository;
  const ClimaMaisApp({Key? key, required this.weatherRepository})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: weatherRepository,
      child: BlocProvider(
          create: (_) => SettingsBloc(weatherRepository: weatherRepository),
          child: const ClimaMaisMaterial()),
    );
  }
}

class ClimaMaisMaterial extends StatelessWidget {
  const ClimaMaisMaterial({
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
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme:
            const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
      ),
      title: 'Clima Mais',
      home: const WeatherHomePage(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
