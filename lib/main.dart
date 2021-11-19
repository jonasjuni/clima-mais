import 'package:flutter/material.dart';
import 'package:clima_mais/app.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/settings/bloc/settings_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:clima_mais/bloc_observer.dart';
import 'package:http/http.dart' as http;
import 'package:meta_weather/meta_weather.dart';

import 'package:timezone/data/latest_10y.dart' as tz;

void main() async {
  tz.initializeTimeZones();

  // Bloc.observer = ClimaMaisBlocObserver();
  //init storage
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  // init deps
  final httpClient = http.Client();
  final weatherRepository = MetaWeatherRepository(
    weatherApiClient: WeatherApiClient(
      httpClient: httpClient,
    ),
  );

  HydratedBlocOverrides.runZoned(
    () {
      final settingsBloc = SettingsBloc();
      runApp(
        ClimaMaisApp(
          settingsBloc: settingsBloc,
          weatherRepository: weatherRepository,
        ),
      );
    },
    storage: storage,
    blocObserver: ClimaMaisBlocObserver(),
  );
}
