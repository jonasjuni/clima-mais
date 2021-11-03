import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:clima_mais/settings/settings.dart';
import 'package:clima_mais/weather/weather.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/theme.dart';

class WeatherCorver extends StatelessWidget {
  const WeatherCorver({Key? key, required this.weather}) : super(key: key);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final viewPortheight = mediaQuery.size.height;
    final topSafeHeight = mediaQuery.size.height - mediaQuery.padding.top;
    final safeHeight =
        viewPortheight - mediaQuery.padding.top - mediaQuery.padding.bottom;
    return Stack(
      children: [
        DynamicBackground(
          height: topSafeHeight,
          weatherCondition: weather.weatherForecasts.first.condition,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: safeHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kLateralPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActionsMenu(),
                WeatherTitle(
                  title: weather.title,
                ),
                WeatherSubtitle(
                  date: weather.weatherForecasts.first.date,
                ),
                MainWeatherWidget(
                    weatherForecast: weather.weatherForecasts.first),
                Spacer(),
                WeatherUtilitsWidget(
                  weatherState: weather.weatherForecasts.first,
                ),
                WeatherLastUpdated(
                  time: weather.time,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DynamicBackground extends StatelessWidget {
  const DynamicBackground({
    Key? key,
    required this.height,
    required this.weatherCondition,
  }) : super(key: key);

  final double height;
  final WeatherCondition weatherCondition;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final background = isDarkMode
        ? 'assets/images/background/dark_${'light_rain'}.png' //Todo: dynamic background
        : 'assets/images/background/${'light_rain'}.png';

    return Container(
      //Todo: Animate Decoration
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Color(weatherCondition.toColor(isDarkMode)),
        image: DecorationImage(
          image: AssetImage(background),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ActionsMenu extends StatelessWidget {
  const ActionsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(Icons.menu),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      ],
    );
  }
}

class WeatherTitle extends StatelessWidget {
  const WeatherTitle({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headline6,
    );
  }
}

class WeatherSubtitle extends StatelessWidget {
  const WeatherSubtitle({Key? key, required this.date}) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).forecastDate(date), //Todo: L10n
      style: Theme.of(context).textTheme.subtitle1,
    );
  }
}

class MainWeatherWidget extends StatelessWidget {
  const MainWeatherWidget({Key? key, required this.weatherForecast})
      : super(key: key);
  final WeatherForecast weatherForecast;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FittedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CurrentTemp(
                  temp: weatherForecast.temp,
                ),
                ConditionTitle(
                  weatherCondition:
                      weatherForecast.condition.toLocalizedTitle(context),
                ),
                MinMaxTemperature(weatherForecast: weatherForecast),
              ],
            ),
          ),
        ),
        Flexible(
          child: ConditionAnimation(
            weatherCondition: weatherForecast.condition,
          ),
        ),
      ],
    );
  }
}

class CurrentTemp extends StatelessWidget {
  const CurrentTemp({Key? key, required this.temp}) : super(key: key);

  final Temperature temp;

  @override
  Widget build(BuildContext context) {
    final isFahrenheit = context.select((SettingsBloc bloc) =>
        bloc.state.settings.tempUnitSystem == TempUnitSystem.fahrenheit);

    final currentTemp = isFahrenheit ? temp.fahrenheit : temp.celsius;
    return Text(
      '${currentTemp.round()}°',
      style: Theme.of(context).textTheme.headline1,
    );
  }
}

class ConditionTitle extends StatelessWidget {
  const ConditionTitle({Key? key, required this.weatherCondition})
      : super(key: key);
  final String weatherCondition;

  @override
  Widget build(BuildContext context) {
    return Text(weatherCondition, style: Theme.of(context).textTheme.headline6);
  }
}

class MinMaxTemperature extends StatelessWidget {
  const MinMaxTemperature({Key? key, required this.weatherForecast})
      : super(key: key);
  final WeatherForecast weatherForecast;

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
    return Row(
      children: [
        Text(
          '${maxTemp.round()}°',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Text(
          '${minTemp.round()}°',
          style: Theme.of(context).textTheme.subtitle2, //Todo: style
        ),
      ],
    );
  }
}

class ConditionAnimation extends StatelessWidget {
  const ConditionAnimation({
    Key? key,
    required this.weatherCondition,
  }) : super(key: key);

  final WeatherCondition weatherCondition;

  @override
  Widget build(BuildContext context) {
    final String brightness =
        Theme.of(context).brightness == Brightness.light ? '' : 'colors/';
    return Align(
      alignment: Alignment.centerLeft,
      widthFactor: 0.9,
      child: Lottie.asset(
        'assets/animations/weather/$brightness${weatherCondition.toSnakeCase}.json',
        width: 200,
        height: 200,
      ),
    );
  }
}

class WeatherUtilitsWidget extends StatelessWidget {
  const WeatherUtilitsWidget({Key? key, required this.weatherState})
      : super(key: key);

  final borderRadius = 20.0;
  final WeatherForecast weatherState;

  @override
  Widget build(BuildContext context) {
    final isImperial = context.select((SettingsBloc bloc) =>
        bloc.state.settings.lenghtUnit == LenghtUnit.imperial);

    final windSpeed = isImperial
        ? '${weatherState.windSpeed.imperial.round()} mph'
        : '${weatherState.windSpeed.metric.round()} km/h';

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Insets.large),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withAlpha(30),
            border:
                Border.all(color: Theme.of(context).colorScheme.onBackground),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('${weatherState.humidity.round()}%'),
                    Text(AppLocalizations.of(context).humidity)
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('${weatherState.airPressure.toStringAsFixed(1)} mb'),
                    Text(AppLocalizations.of(context)
                        .airPressure), //Todo: Localize
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(windSpeed),
                    Text(AppLocalizations.of(context).windSpeed),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherLastUpdated extends StatelessWidget {
  const WeatherLastUpdated({Key? key, required this.time}) : super(key: key);
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.xlarge),
      child: Center(
        child: Text(
            AppLocalizations.of(context).homepageLastUpdated(time.toLocal())),
      ),
    );
  }
}
