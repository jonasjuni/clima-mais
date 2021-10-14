import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  const WeatherSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final viewPortheight = mediaQuery.size.height;
    final topSafeHeight = mediaQuery.size.height - mediaQuery.padding.top;
    final safeHeight =
        viewPortheight - mediaQuery.padding.top - mediaQuery.padding.bottom;
    return RefreshIndicator(
      onRefresh: () {
        final bloc = context.read<WeatherBloc>();
        bloc.add(const WeatherRefreshed());

        return bloc.stream.firstWhere((element) => true);
      },
      child: CustomScrollView(
        slivers: [
          StatusBarHack(),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                Stack(
                  children: [
                    DynamicBackground(height: topSafeHeight),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: safeHeight),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kLateralPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ActionsMenu(),
                            WeatherTitle(),
                            WeatherSubtitle(),
                            CurrentMainWeather(),
                            // ConditionTitle(),
                            // MinMaxTemperature(),
                            Spacer(),
                            WeatherUtilitsWidget(),
                            WeatherLastUpdated(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                WeeklyForecastList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicBackground extends StatelessWidget {
  const DynamicBackground({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    final weatherCondition =
        context.select<WeatherBloc, WeatherCondition>((WeatherBloc bloc) {
      final state = bloc.state as WeatherLoadSuccess;
      return state.weather.weatherForecasts.first.condition;
    });
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final background = isDarkMode
        ? 'assets/images/background/dark_${weatherCondition.toSnakeCase}.png'
        : 'assets/images/background/${weatherCondition.toSnakeCase}.png';

    return Ink(
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

class StatusBarHack extends StatelessWidget {
  const StatusBarHack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherCondition =
        context.select<WeatherBloc, WeatherCondition>((WeatherBloc bloc) {
      final state = bloc.state as WeatherLoadSuccess;
      return state.weather.weatherForecasts.first.condition;
    });
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      elevation: 0,
      toolbarHeight: 0,
      systemOverlayStyle: null,
      backgroundColor:
          Color(weatherCondition.toColor(isDarkMode)), // Todo: dynamic color
      pinned: true,
      actions: [Icon(Icons.add)],
    );
  }
}

class ActionsMenu extends StatelessWidget {
  const ActionsMenu({Key? key}) : super(key: key);

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(Icons.menu),
        ),
        IconButton(
          onPressed: () => _onpressed(context),
          icon: Icon(
            Icons.add,
          ),
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
    return Text(
      title,
      style: Theme.of(context).textTheme.headline6,
    );
  }
}

class WeatherSubtitle extends StatelessWidget {
  const WeatherSubtitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = context.select<WeatherBloc, DateTime>((bloc) {
      final state = bloc.state as WeatherLoadSuccess;
      return state.weather.weatherForecasts.first.date;
    });
    return Text(
      AppLocalizations.of(context).forecastDate(date), //Todo: L10n
      style: Theme.of(context).textTheme.subtitle1,
    );
  }
}

class CurrentMainWeather extends StatelessWidget {
  const CurrentMainWeather({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: BlocSelector<WeatherBloc, WeatherState, double>(
              selector: (weatherState) {
            final state = weatherState as WeatherLoadSuccess;
            return state.weather.weatherForecasts.first.temp;
          }, builder: (context, state) {
            var temp = state;
            final tempUnitSystem = context.select<SettingsBloc, TempUnitSystem>(
                (bloc) => bloc.state.settings.tempUnitSystem);

            tempUnitSystem == TempUnitSystem.celsius
                ? temp = temp
                : temp = temp; //Todo: fix convertion

            return FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${temp.round()}°',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  ConditionTitle(),
                  MinMaxTemperature(),
                ],
              ),
            );
          }),
        ),
        Flexible(
          child: BlocSelector<WeatherBloc, WeatherState, String>(
            selector: (weatherState) {
              final state = weatherState as WeatherLoadSuccess;
              return state.weather.weatherForecasts.first.conditionAnimation;
            },
            builder: (context, state) {
              final String brightness =
                  Theme.of(context).brightness == Brightness.light
                      ? ''
                      : 'colors/';
              return Align(
                alignment: Alignment.centerLeft,
                widthFactor: 0.9,
                child: Lottie.asset(
                  'assets/animations/weather/$brightness$state.json',
                  width: 200,
                  height: 200,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ConditionTitle extends StatelessWidget {
  const ConditionTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherCondition = context.select((WeatherBloc bloc) {
      final state = bloc.state as WeatherLoadSuccess;
      return state.weather.weatherForecasts.first.condition;
    });

    String conditionText;
    switch (weatherCondition) {
      case WeatherCondition.cloudy:
        conditionText = AppLocalizations.of(context).cloudy;
        break;
      case WeatherCondition.fog:
        conditionText = AppLocalizations.of(context).fog;
        break;
      case WeatherCondition.hail:
        conditionText = AppLocalizations.of(context).hail;
        break;
      case WeatherCondition.heavyRain:
        conditionText = AppLocalizations.of(context).heavyRain;
        break;
      case WeatherCondition.heavySnow:
        conditionText = AppLocalizations.of(context).heavySnow;
        break;
      case WeatherCondition.lightRain:
        conditionText = AppLocalizations.of(context).lightRain;
        break;
      case WeatherCondition.lightSnow:
        conditionText = AppLocalizations.of(context).lightSnow;
        break;
      case WeatherCondition.mediumRain:
        conditionText = AppLocalizations.of(context).mediumRain;
        break;
      case WeatherCondition.mediumSnow:
        conditionText = AppLocalizations.of(context).mediumSnow;
        break;
      case WeatherCondition.showers:
        conditionText = AppLocalizations.of(context).showers;
        break;
      case WeatherCondition.partlyCloudy:
        conditionText = AppLocalizations.of(context).partlyCloudy;
        break;
      case WeatherCondition.sleet:
        conditionText = AppLocalizations.of(context).sleet;
        break;
      case WeatherCondition.smog:
        conditionText = AppLocalizations.of(context).smog;
        break;
      case WeatherCondition.sunny:
        conditionText = AppLocalizations.of(context).sunny;
        break;
      case WeatherCondition.thunderstorm:
        conditionText = AppLocalizations.of(context).thunderstorm;
        break;
      case WeatherCondition.unknown:
        conditionText = AppLocalizations.of(context).unknown;
        break;
    }
    return Text(conditionText, style: Theme.of(context).textTheme.headline6);
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
        Text(
          '${weatherForecast.maxTemp.round().toString()}°',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Text(
          '${weatherForecast.minTemp.round().toString()}°',
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }
}

class WeatherUtilitsWidget extends StatelessWidget {
  const WeatherUtilitsWidget({Key? key}) : super(key: key);
  final borderRadius = 20.0;

  @override
  Widget build(BuildContext context) {
    final weatherState =
        context.select<WeatherBloc, WeatherForecast>((WeatherBloc bloc) {
      final state = bloc.state as WeatherLoadSuccess;
      return state.weather.weatherForecasts.first;
    });

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: kVerticalSpacing * 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withAlpha(30),
            border:
                Border.all(color: Theme.of(context).colorScheme.onBackground),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [Text('${weatherState.humidity}%'), Text('Humidity')],
              ),
              Column(
                children: [
                  Text('${num.parse('111.0')} mbar'),
                  Text('Air Pressure'), //Todo: Localize
                ],
              ),
              Column(
                children: [
                  Text(
                      '${num.parse(weatherState.windSpeed.toStringAsFixed(1))} mph'), //Todo:
                  Text('Wind Speed'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherLastUpdated extends StatelessWidget {
  const WeatherLastUpdated({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = context.select<WeatherBloc, DateTime>((bloc) {
      final state = bloc.state as WeatherLoadSuccess;
      return state.weather.time;
    });
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kVerticalSpacing * 4),
      child: Center(
        child: Text(
            AppLocalizations.of(context).homepageLastUpdated(time.toLocal())),
      ),
    );
  }
}

class WeeklyForecastListTest extends StatelessWidget {
  const WeeklyForecastListTest({
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

class WeeklyForecastList extends StatelessWidget {
  const WeeklyForecastList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<WeatherForecast> weatherForecastList =
        context.select<WeatherBloc, List<WeatherForecast>>((WeatherBloc bloc) {
      final state = bloc.state as WeatherLoadSuccess;

      return state.weather.weatherForecasts;
    });

    return Container(
        color: Theme.of(context).colorScheme.surface.withAlpha(50),
        padding: const EdgeInsets.symmetric(
            vertical: kVerticalSpacing * 4, horizontal: kLateralPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly',
              style: Theme.of(context).textTheme.headline6,
            ), //Todo: l10n
            ...List.generate(
                weatherForecastList.length,
                (index) => WeeklyForecastItem(
                      index: index,
                      weatherForecast: weatherForecastList[index],
                    ))
          ],
        ));
  }
}

class WeeklyForecastItem extends StatelessWidget {
  const WeeklyForecastItem({
    Key? key,
    required this.weatherForecast,
    required this.index,
  }) : super(key: key);
  final WeatherForecast weatherForecast;
  final int index;

  @override
  Widget build(BuildContext context) {
    late String titleDay;

    switch (index) {
      case 0:
        titleDay = 'Today';
        break;
      case 1:
        titleDay = 'Tomorrow';
        break;
      default:
        titleDay = 'Weekday';
    }
    log(index.toString());

    return Container(
      padding: const EdgeInsets.symmetric(vertical: kVerticalSpacing),
      child: DefaultTextStyle.merge(
        style: Theme.of(context).textTheme.bodyText1,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(titleDay),
            ),
            Expanded(
              child: Text(weatherForecast.weatherStateName),
            ),
            Expanded(
              flex: 0,
              child: Text(
                  '${weatherForecast.maxTemp.round()}°/${weatherForecast.minTemp.round()}°'),
            ),
          ],
        ),
      ),
    );
  }
}
