import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:clima_mais/weather/weather.dart';
import 'package:clima_mais/settings/settings.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/theme.dart';
import 'package:url_launcher/url_launcher.dart';

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
                const SizedBox(height: Insets.xlarge),
                const DailyForecastTitle(),
                DailyForecastChart(weatherForecasts: weather.weatherForecasts),
                DailyForecastList(weatherForecasts: weather.weatherForecasts),
              ],
            ),
          ),
          SliverToBoxAdapter(
            //Map must be keept alive
            child: Column(
              children: [
                const SizedBox(height: Insets.xlarge),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                        vertical: Insets.medium, horizontal: kLateralPadding),
                    child: Text('Area Map',
                        style: Theme.of(context).textTheme.headline6)),
                LocatioMap(latlng: weather.lattLong),
                LocationDetails(
                  weather: weather,
                ),
                Footer(woeid: weather.woeid),
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
            //TODO: include icon
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    '${maxTemp.round()}°/${minTemp.round()}°'), //TODO: A11y
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationDetails extends StatelessWidget {
  const LocationDetails({Key? key, required this.weather}) : super(key: key);
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    log('Location details Build');
    final weatherForecast = weather.weatherForecasts.first;

    final isImperial = context.select((SettingsBloc bloc) =>
        bloc.state.settings.lenghtUnit == LenghtUnit.imperial);

    final visibility = isImperial
        ? '${weatherForecast.visibility.imperial.round()} mi'
        : '${weatherForecast.visibility.metric.round()} km';

    //Convert to local time
    final tz.Location location = tz.getLocation(weather.timezone);
    final sunRiseLocationTime = tz.TZDateTime.from(weather.sunRise, location);
    final sunSetLocationTime = tz.TZDateTime.from(weather.sunSet, location);

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
                        AppLocalizations.of(context).localTimeTitle,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      ClockTimer(
                        location: location,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(AppLocalizations.of(context).visibility,
                          style: Theme.of(context).textTheme.headline6),
                      Text(visibility),
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
                Text('${weatherForecast.predictability}%'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ClockTimer extends StatefulWidget {
  const ClockTimer({Key? key, required this.location}) : super(key: key);
  final tz.Location location;

  @override
  _ClockTimerState createState() => _ClockTimerState();
}

class _ClockTimerState extends State<ClockTimer>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  ///From Fluter clock challenge https://github.com/flutter/flutter_clock
  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        const Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final time = tz.TZDateTime.from(_dateTime, widget.location);
    return Text(AppLocalizations.of(context).hourMinute(time));
  }
}

class Footer extends StatelessWidget {
  const Footer({Key? key, required this.woeid}) : super(key: key);

  final int woeid;

  void _launchURL(int woeid) async {
    await launch('https://www.metaweather.com/$woeid');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(
          vertical: Insets.medium, horizontal: kLateralPadding),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: [
            TextSpan(text: AppLocalizations.of(context).dataFrom),
            const TextSpan(text: ' '),
            WidgetSpan(
              child: Tooltip(
                message: 'Link to MetaWeather', //TODO: A11y
                child: InkWell(
                  child: Text(
                    'MetaWeather',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).indicatorColor),
                  ),
                  onTap: () => _launchURL(woeid),
                ),
              ),
            ),
          ],
        ),
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
