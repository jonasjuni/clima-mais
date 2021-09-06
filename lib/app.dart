import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clima_mais/repositories/weather_repository.dart';
import 'package:clima_mais/weather/weather.dart';

import 'package:clima_mais/theme/bloc/theme_bloc.dart';
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
      child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => SettingsBloc()),
            BlocProvider(
              create: (_) => ThemeBloc(),
            )
          ],
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                locale: null,
                theme: ThemeData(
                  primaryColor: state.color,
                ),
                darkTheme: ThemeData.dark(),
                title: 'Clima Mais',
                home: const WeatherHomePage(),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
              );
            },
          )),
    );
  }
}
