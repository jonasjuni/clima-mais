import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:meta_weather/meta_weather.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const defautColor = Color(0xFF2196F3);

  ThemeBloc() : super(const ThemeState(color: defautColor));

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is WeatherChanged) {
      yield _mapWeatherConditionToThemeData(event.weather);
    }
  }

  ThemeState _mapWeatherConditionToThemeData(Weather weather) {
    return ThemeState(color: weather.consolidatedWeather[0].toColor);
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    final color = Color(json['color']);
    return ThemeState(color: color);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {'color': state.color.value};
  }
}

extension WeatherCoditionXColor on ConsolidatedWeather {
  Color get toColor {
    switch (condition) {
      case WeatherCondition.clear:
        return Colors.orangeAccent;

      case WeatherCondition.sleet:
      case WeatherCondition.snow:
      case WeatherCondition.hail:
        return Colors.lightBlueAccent;

      case WeatherCondition.heavyCloud:
      case WeatherCondition.lightCloud:
        return Colors.blueGrey;

      case WeatherCondition.thunderstorm:
      case WeatherCondition.heavyRain:
      case WeatherCondition.lightRain:
      case WeatherCondition.showers:
        return Colors.indigoAccent;

      case WeatherCondition.unknown:
      default:
        return ThemeBloc.defautColor;
    }
  }
}
