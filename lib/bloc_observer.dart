import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class ClimaMaisBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('${bloc.runtimeType}: $change');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('${bloc.runtimeType} EVENT: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('${bloc.runtimeType} TRANSITION: $transition');
  }

  // @override
  // void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
  //   super.onError(bloc, error, stackTrace);
  //   // log('Error: ${bloc.runtimeType} $error!!');
  // }

  // @override
  // void onClose(BlocBase bloc) {
  //   super.onClose(bloc);
  //   // log('${bloc.runtimeType} CLosed!!');
  // }
}
