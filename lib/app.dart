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
      locale: null,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
        ),
        scaffoldBackgroundColor: const Color(0xFF1D1B1B),
      ),
      title: 'Clima Mais',
      home: const WeatherHomePage(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
