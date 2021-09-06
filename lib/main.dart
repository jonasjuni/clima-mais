import 'package:clima_mais/app.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meta_weather/meta_weather.dart';

void main() {
  final httpClient = http.Client();
  final weatherRepository = WeatherRepository(
    weatherApiClient: WeatherApiClient(
      httpClient: httpClient,
    ),
  );
  runApp(ClimaMaisApp(
    weatherRepository: weatherRepository,
  ));
}
