import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:clima_mais/settings/models/models.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(_metric) {
    on<SettingsTempUnitChanged>(_onTempUnitChanged);
    on<SettingsLenghtUnitChanged>(_onLenghtUnitChanged);
    on<SettingsThemeModeChanged>(_onThemeModeChanged);
    on<SettingsLocaleChanged>(_onLocaleChanged);
  }
  //Todo: automatic detect region
  static const _imperialsLocations = [
    'en_US',
    'en_BS',
    'en_KY',
    'en_LR',
    'en_PW',
    'en_FM',
    'en_MH',
  ];

  static const _metric = SettingsInitial();
  static const _imperial = SettingsInitial.imperial();

  void _onTempUnitChanged(
      SettingsTempUnitChanged event, Emitter<SettingsState> emit) {
    final settings =
        state.settings.copyWith(tempUnitSystem: event.tempUnitSystem);
    emit(SettingsLoadSuccess(settings));
  }

  void _onLenghtUnitChanged(
      SettingsLenghtUnitChanged event, Emitter<SettingsState> emit) {
    final settings = state.settings.copyWith(lenghtUnit: event.lenghtUnit);
    emit(SettingsLoadSuccess(settings));
  }

  void _onThemeModeChanged(
      SettingsThemeModeChanged event, Emitter<SettingsState> emit) {
    emit(SettingsLoadSuccess(
        state.settings.copyWith(themeMode: event.themeMode)));
  }

  void _onLocaleChanged(
      SettingsLocaleChanged event, Emitter<SettingsState> emit) {
    final settings = state.settings.copyWith(locale: event.locale);
    emit(SettingsLoadSuccess(settings));
  }

  //Persistence
  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    log('Hydrated Loading');

    return SettingsLoadSuccess(Settings.fromJson(json));
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    if (state is SettingsLoadSuccess) {
      log('Hydrated Saving');
      return state.settings.toJson();
    }
  }
}
