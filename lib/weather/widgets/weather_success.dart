import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_mais/settings/settings.dart';
import 'package:clima_mais/weather/bloc/weather_bloc.dart';
import 'package:meta_weather/meta_weather.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeatherSuccess extends StatelessWidget {
  final Weather weather;

  const WeatherSuccess({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _WeatherDynamicBackground(),
        RefreshIndicator(
          onRefresh: () {
            final _bloc = context.read<WeatherBloc>()
              ..add(WeatherRefreshed(city: weather.title));

            return _bloc.stream
                .firstWhere((element) => element is WeatherLoadSuccess);
          },
          child: ListView(
            children: [
              LocationTitle(weather: weather),
              CurrentMainWeather(weather: weather),
              Center(
                child: Text(AppLocalizations.of(context)
                    .homepageLastUpdated(weather.time.toLocal())),
              ),
              Center(
                child: Text(
                  AppLocalizations.of(context)
                      .homepageLatitude(weather.lattLong.latitude ?? 0),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LocationTitle extends StatelessWidget {
  const LocationTitle({
    Key? key,
    required this.weather,
  }) : super(key: key);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.place),
          Text(
            weather.title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
            'assets/${weather.consolidatedWeather[0].condition.abbr}.png'),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Text(
              '${(state.settings.tempUnitSystem == TempUnitSystem.celsius) ? weather.consolidatedWeather[0].temp.floor() : weather.consolidatedWeather[0].farenheitTemp}°',
              style: Theme.of(context).textTheme.headline2,
            );
          },
        )
      ],
    );
  }
}

class _WeatherDynamicBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
    );
  }
}
