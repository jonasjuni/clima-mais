import 'package:clima_mais/app.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/weather_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta_weather/meta_weather.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  final httpClient = http.Client();
  final weatherRepository = MetaWeatherRepository(
    weatherApiClient: WeatherApiClient(
      httpClient: httpClient,
    ),
  );

  Bloc.observer = ClimaMaisBlocObserver();
  runApp(ClimaMaisApp(
    weatherRepository: weatherRepository,
  ));
}
