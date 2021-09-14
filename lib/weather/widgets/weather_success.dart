import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_mais/settings/settings.dart';
import 'package:clima_mais/weather/weather.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeatherSuccess extends StatelessWidget {
  final Weather weather;

  const WeatherSuccess({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                .homepageLatitude(weather.lattLong.latitude),
            style: Theme.of(context).textTheme.headline4,
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
        Image.asset('assets/${weather.weatherForecasts[0].condition}.png'),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            final String temp = state.settings.tempUnitSystem ==
                    TempUnitSystem.celsius
                ? weather.weatherForecasts[0].temp.round().toString()
                : weather.weatherForecasts[0].farenheitTemp.round().toString();
            return Text(
              '$temp°',
              style: Theme.of(context).textTheme.headline2,
            );
          },
        )
      ],
    );
  }
}
