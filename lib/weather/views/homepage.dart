import 'package:clima_mais/location_search/location_search.dart';
import 'package:clima_mais/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/weather/weather.dart';

class WeatherHomePage extends StatelessWidget {
  const WeatherHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return WeatherBloc(
            weatherRepository: context.read<WeatherRepository>());
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
      body: BlocConsumer<WeatherBloc, WeatherState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is WeatherInitial) {
            return const WeatherEmpty();
          }
          if (state is WeatherLoadInProgress) {
            return const WeatherLoading();
          }
          if (state is WeatherLoadSuccess) {
            return WeatherSuccess(
              weather: state.weather,
            );
          }
          if (state is WeatherLoadFailure) {
            return WeatherFailure(exception: state.exception);
          } else {
            throw Error();
          }
        },
      ),
    );
  }
}
