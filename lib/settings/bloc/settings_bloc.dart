import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:clima_mais/settings/models/models.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
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

  SettingsBloc() : super(_metric);

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is ThemeLightChanged) {
      yield SettingsInProgress(
          state.settings.copyWith(themeLight: event.themeLight));
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

  // // Persistence
  // @override
  // SettingsState? fromJson(Map<String, dynamic> json) =>
  //     SettingsInProgress(Settings.fromJson(json));

  // @override
  // Map<String, dynamic>? toJson(SettingsState state) => state.settings.toJson();
}
