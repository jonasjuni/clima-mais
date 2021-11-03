import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/weather/weather.dart';

class WeatherHomePage extends StatelessWidget {
  const WeatherHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return WeatherBloc(weatherRepository: context.read<WeatherRepository>())
          ..add(const WeatherDataRefreshed());
      },
      child: const WeatherView(),
    );
  }
}

class WeatherView extends StatelessWidget {
  const WeatherView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: SideMenu(),
      ), // Todo: drawer side menu
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context)
                .appBarTheme
                .systemOverlayStyle
                ?.copyWith(statusBarColor: Colors.transparent) ??
            const SystemUiOverlayStyle(),
        child: BlocConsumer<WeatherBloc, WeatherState>(
          listener: (context, state) {
            if (state is WeatherLoadFailure) {
              showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Text(state.exception.toString()),
                      ));
            }
          },
          builder: (context, state) {
            log('1st BlocConsumer homepage');
            if (state is WeatherInitial) {
              return const WeatherEmpty();
            }
            if (state is WeatherLoadInProgress) {
              return const WeatherLoading();
            }
            if (state is WeatherLoadSuccess) {
              return state.locations.isNotEmpty
                  ? WeatherCompleted(
                      weather: state.weather,
                    )
                  : WeatherEmpty();
            }
            if (state is WeatherLoadFailure) {
              return WeatherFailure(exception: state.exception);
            } else {
              throw Error();
            }
          },
        ),
      ),
    );
  }
}
