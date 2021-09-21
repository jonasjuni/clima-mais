import 'dart:async';
import 'dart:ui';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:clima_mais/settings/models/models.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(_metric);
  final WeatherRepository _weatherRepository;
  static const _imperialsLocations = [
    'en-US',
    'en_BS',
    'en_KY',
    'en_LR',
    'en_PW',
    'en_FM',
    'en_MH',
  ];

  static const _metric = SettingsInitial();
  static const _imperial = SettingsInitial.imperial();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is ThemeBrightnessChanged) {
      yield SettingsInProgress(
          state.settings.copyWith(themeBrightness: event.themeBrightness));
    } else if (event is TempUnitChanged) {
      yield SettingsInProgress(
          state.settings.copyWith(tempUnitSystem: event.tempUnitSystem));
    } else if (event is DistanceSystemChanged) {
      yield SettingsInProgress(
          state.settings.copyWith(distanceSystem: event.distanceSystem));
    } else if (event is LocaleChanged) {
      yield SettingsInProgress(state.settings.copyWith(locale: event.locale));
    }
  }
}
