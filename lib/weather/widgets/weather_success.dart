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
    log('title build');
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
    log('Time build');
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CurrentTemperature(),
              Text('Sunny'),
            ],
          ),
          BlocSelector<WeatherBloc, WeatherState, String>(
            selector: (weatherState) {
              final state = weatherState as WeatherLoadSuccess;
              return state.weather.weatherForecasts.first.abbr;
            },
            builder: (context, state) {
              log('animation build');
              return Align(
                alignment: Alignment.centerLeft,
                widthFactor: 0.5,
                child: Lottie.asset(
                  'assets/animations/c.json',
                  width: 300,
                  height: 300,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MyCLipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    Rect path = const Offset(0, 0) & Size(size.width / 2, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}

class CurrentTemperature extends StatelessWidget {
  const CurrentTemperature({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tempUnitSystem = context.select<SettingsBloc, TempUnitSystem>(
        (bloc) => bloc.state.settings.tempUnitSystem);

    var temp = context.select<WeatherBloc, double>((bloc) {
      final state = bloc.state as WeatherLoadSuccess;
      return state.weather.weatherForecasts.first.temp;
    });

    tempUnitSystem == TempUnitSystem.celsius
        ? temp = temp
        : temp = temp; //Todo: fix convertion

    log('current temp build');
    return Text(
      '${temp.round()}°',
      style: Theme.of(context).textTheme.headline1,
    );
  }
}

class MinMaxTemperature extends StatelessWidget {
  const MinMaxTemperature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherForecast =
        context.select<WeatherBloc, WeatherForecast>((WeatherBloc bloc) {
      final state = bloc.state as WeatherLoadSuccess;

      return state.weather.weatherForecasts.first;
    });
    return Row(
      children: [
        Icon(
          Icons.thermostat_outlined,
          color: Colors.red.withAlpha(100),
          size: 20,
        ),
        Text(weatherForecast.maxTemp.round().toString()),
        Icon(
          Icons.thermostat,
          color: Colors.blue,
        ),
        Text(weatherForecast.minTemp.round().toString()),
      ],
    );
  }
}
