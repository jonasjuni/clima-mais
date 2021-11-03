import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:clima_mais/weather/weather.dart';
import 'package:clima_mais/settings/settings.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/theme.dart';

class WeatherCompleted extends StatelessWidget {
  const WeatherCompleted({Key? key, required this.weather}) : super(key: key);
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        final bloc = context.read<WeatherBloc>();
        bloc.add(const WeatherDataRefreshed());

        return bloc.stream.firstWhere((state) => state is WeatherLoadSuccess);
      },
      child: CustomScrollView(
        slivers: [
          StatusBarHack(
              weatherCondition: weather.weatherForecasts.first.condition),
          //Lazy build area
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                WeatherCorver(
                  weather: weather,
                ),
                SizedBox(height: Insets.xlarge),
                DailyForecastTitle(),
                DailyForecastChart(weatherForecasts: weather.weatherForecasts),
                DailyForecastList(weatherForecasts: weather.weatherForecasts),
              ],
            ),
          ),
          SliverToBoxAdapter(
            //Map must be keept alive
            child: Column(
              children: [
                SizedBox(height: Insets.xlarge),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                        vertical: Insets.medium, horizontal: kLateralPadding),
                    child: Text('Area Map',
                        style: Theme.of(context).textTheme.headline6)),
                LocatioMap(latlng: weather.lattLong),
                LocationDetails(),
                Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DailyForecastTitle extends StatelessWidget {
  const DailyForecastTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Insets.medium, horizontal: kLateralPadding),
      child: Text(
        'Daily Forecast', //Todo: localizate
        style: Theme.of(context).textTheme.headline6,
      ), //Todo: l10n
    );
  }
}

class StatusBarHack extends StatelessWidget {
  const StatusBarHack({Key? key, required this.weatherCondition})
      : super(key: key);
  final WeatherCondition weatherCondition;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SliverAppBar(
      toolbarHeight: 0,
      pinned: true,
      backgroundColor: Color(weatherCondition.toColor(isDarkMode)),
      //Todo A11y
    );
  }
}

class DailyForecastList extends StatelessWidget {
  const DailyForecastList({Key? key, required this.weatherForecasts})
      : super(key: key);
  final List<WeatherForecast> weatherForecasts;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(
            vertical: Insets.medium, horizontal: kLateralPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Todo: l10n
            ...List.generate(
                weatherForecasts.length,
                (index) => DailyForecastItem(
                      index: index,
                      weatherForecast: weatherForecasts[index],
                    ))
          ],
        ));
  }
}

class DailyForecastItem extends StatelessWidget {
  const DailyForecastItem({
    Key? key,
    required this.weatherForecast,
    required this.index,
  }) : super(key: key);
  final WeatherForecast weatherForecast;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isFahrenheit = context.select((SettingsBloc bloc) =>
        bloc.state.settings.tempUnitSystem == TempUnitSystem.fahrenheit);

    final maxTemp = isFahrenheit
        ? weatherForecast.maxTemp.fahrenheit
        : weatherForecast.maxTemp.celsius;

    final minTemp = isFahrenheit
        ? weatherForecast.minTemp.fahrenheit
        : weatherForecast.minTemp.celsius;

    late String weekDay;

    switch (index) {
      case 0:
        weekDay = AppLocalizations.of(context).weekToday;
        break;
      case 1:
        weekDay = AppLocalizations.of(context).weekTomorrow;
        break;
      default:
        weekDay = AppLocalizations.of(context).weekDay(weatherForecast.date);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Insets.small),
      child: DefaultTextStyle.merge(
        style: Theme.of(context).textTheme.bodyText1,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(weekDay),
            ),
            Expanded(
              child: Text(weatherForecast.condition.toLocalizedTitle(context)),
            ),
            //Todo: include icon
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    '${maxTemp.round()}°/${minTemp.round()}°'), //Todo: A11y
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationDetails extends StatelessWidget {
  const LocationDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weather = context.select((WeatherBloc bloc) {
      final state = bloc.state;
      if (state is WeatherLoadSuccess) {
        return state.weather;
      }
    });

    //convert to Location Times
    final location = tz.getLocation(weather?.timezone ?? 'America/Detroit');
    final sunRiseLocationTime =
        tz.TZDateTime.from(weather?.sunRise ?? DateTime(0), location);
    final sunSetLocationTime =
        tz.TZDateTime.from(weather?.sunSet ?? DateTime(0), location);

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
          vertical: Insets.xlarge, horizontal: kLateralPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.small),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(AppLocalizations.of(context).sunRise,
                          style: Theme.of(context).textTheme.headline6),
                      Text(AppLocalizations.of(context)
                          .hourMinute(sunRiseLocationTime)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(AppLocalizations.of(context).sunSet,
                          style: Theme.of(context).textTheme.headline6),
                      Text(AppLocalizations.of(context)
                          .hourMinute(sunSetLocationTime)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.small),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context).windDirection,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text('${weather?.sunRise.hour}')
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(AppLocalizations.of(context).visibility,
                          style: Theme.of(context).textTheme.headline6),
                      Text('10 mi'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.small),
            child: Column(
              children: [
                Text(AppLocalizations.of(context).predictability,
                    style: Theme.of(context).textTheme.headline6),
                Text('87%'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(
          vertical: Insets.medium, horizontal: kLateralPadding),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(text: AppLocalizations.of(context).dataFrom),
          TextSpan(text: ' MetaWeather'),
        ], style: Theme.of(context).textTheme.bodyText2),
      ),
    );
  }
}

extension WeatherConditionXL10n on WeatherCondition {
  String toLocalizedTitle(BuildContext context) {
    switch (this) {
      case WeatherCondition.cloudy:
        return AppLocalizations.of(context).cloudy;
      case WeatherCondition.fog:
        return AppLocalizations.of(context).fog;
      case WeatherCondition.hail:
        return AppLocalizations.of(context).hail;
      case WeatherCondition.heavyRain:
        return AppLocalizations.of(context).heavyRain;
      case WeatherCondition.heavySnow:
        return AppLocalizations.of(context).heavySnow;
      case WeatherCondition.lightRain:
        return AppLocalizations.of(context).lightRain;
      case WeatherCondition.lightSnow:
        return AppLocalizations.of(context).lightSnow;
      case WeatherCondition.mediumRain:
        return AppLocalizations.of(context).mediumRain;
      case WeatherCondition.mediumSnow:
        return AppLocalizations.of(context).mediumSnow;
      case WeatherCondition.showers:
        return AppLocalizations.of(context).showers;
      case WeatherCondition.partlyCloudy:
        return AppLocalizations.of(context).partlyCloudy;
      case WeatherCondition.sleet:
        return AppLocalizations.of(context).sleet;
      case WeatherCondition.smog:
        return AppLocalizations.of(context).smog;
      case WeatherCondition.sunny:
        return AppLocalizations.of(context).sunny;
      case WeatherCondition.thunderstorm:
        return AppLocalizations.of(context).thunderstorm;
      case WeatherCondition.unknown:
        return AppLocalizations.of(context).unknown;
    }
  }
}
