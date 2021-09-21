import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_mais/settings/settings.dart';
import 'package:clima_mais/location_search/location_search.dart';
import 'package:clima_mais/weather/weather.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

class WeatherSuccess extends StatelessWidget {
  const WeatherSuccess({Key? key, required this.weather}) : super(key: key);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        final bloc = context.read<WeatherBloc>();
        final state = bloc.state as WeatherLoadSuccess;
        bloc.add(WeatherRefreshed(locations: state.locations));

        return bloc.stream
            .firstWhere((element) => element is! WeatherLoadInProgress);
      },
      child: CustomScrollView(
        slivers: [
          const AppBar(),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
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
            ]),
          ),
        ],
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: [
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final state =
                  context.read<WeatherBloc>().state as WeatherLoadSuccess;
              final result = await Navigator.push<List<Location>>(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LocationSearchPage(userLocations: state.locations)),
              );

              if (result == null) {
                return;
              } else {
                context
                    .read<WeatherBloc>()
                    .add(WeatherRequested(locations: result));
              }
            }),
        IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            }),
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
        // Image.asset('assets/images/${weather.weatherForecasts[0].abbr}.png'),
        Lottie.asset(
            'assets/animations/${weather.weatherForecasts[0].abbr}.json',
            width: 150),
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
