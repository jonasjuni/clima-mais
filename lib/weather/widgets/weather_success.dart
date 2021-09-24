import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_mais/settings/settings.dart';
import 'package:clima_mais/location_search/location_search.dart';
import 'package:clima_mais/weather/weather.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

const kVerticalSpacing = 8.0;
const kLateralPadding = 16.0;

class WeatherSuccess extends StatelessWidget {
  const WeatherSuccess({Key? key, required this.weather}) : super(key: key);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        final bloc = context.read<WeatherBloc>();
        bloc.add(const WeatherRefreshed());

        return bloc.stream.firstWhere((element) => true);
      },
      child: CustomScrollView(
        slivers: [
          const AppBar(),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              WeatherTitle(),
              WeatherDate(),
              CurrentMainWeather(weather: weather),
              Center(
                child: Text(AppLocalizations.of(context)
                    .homepageLastUpdated(weather.time.toLocal())),
              ),
              Center(
                child: Text(
                  AppLocalizations.of(context)
                      .homepageLatitude(weather.lattLong.latitude),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              TestFilter(),
              TestFilter(),
            ]),
          ),
        ],
      ),
    );
  }
}

class TestFilter extends StatelessWidget {
  const TestFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            height: 400,
            color: Theme.of(context).colorScheme.surface.withAlpha(50),
            // color: Colors.red,
          ),
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({Key? key}) : super(key: key);

  void _onpressed(BuildContext context) async {
    final state = context.read<WeatherBloc>().state as WeatherLoadSuccess;
    final result = await Navigator.push<List<Location>>(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LocationSearchPage(userLocations: state.locations)),
    );
    if (result != null) {
      context.read<WeatherBloc>().add(WeatherRequested(locations: result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      // collapsedHeight: 56,
      // backgroundColor: Colors.blue,
      // expandedHeight: 100,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _onpressed(context),
        ),
      ],
    );
  }
}

class WeatherTitle extends StatelessWidget {
  const WeatherTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.select<WeatherBloc, String>((bloc) {
      final state = bloc.state as WeatherLoadSuccess;
      return state.weather.title;
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kLateralPadding),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}

class WeatherDate extends StatelessWidget {
  const WeatherDate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = context.select<WeatherBloc, DateTime>((bloc) {
      final state = bloc.state as WeatherLoadSuccess;
      return state.weather.time;
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kLateralPadding),
      child: Text(
        time.toIso8601String(), //Todo: L10n
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }
}

class CurrentMainWeather extends StatelessWidget {
  const CurrentMainWeather({
    Key? key,
    required this.weather,
  }) : super(key: key);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kLateralPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              final String temp =
                  state.settings.tempUnitSystem == TempUnitSystem.celsius
                      ? weather.weatherForecasts.first.temp.round().toString()
                      : weather.weatherForecasts.first.farenheitTemp
                          .round()
                          .toString();
              return Text(
                '$temp°',
                style: Theme.of(context).textTheme.headline2,
              );
            },
          ),
          BlocSelector<WeatherBloc, WeatherState, String>(
            selector: (weatherState) {
              final state = weatherState as WeatherLoadSuccess;
              return state.weather.weatherForecasts.first.abbr;
            },
            builder: (context, state) {
              return Lottie.asset(
                'assets/animations/$state.json',
                width: 150,
                height: 150,
              );
            },
          ),
        ],
      ),
    );
  }
}
