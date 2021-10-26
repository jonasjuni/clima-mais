import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:clima_mais/settings/settings.dart';
import 'package:clima_mais/location_search/location_search.dart';
import 'package:clima_mais/weather/weather.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/theme.dart';

class WeatherSuccess extends StatelessWidget {
  const WeatherSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        final bloc = context.read<WeatherBloc>();
        bloc.add(const WeatherDataRefreshed());

        return bloc.stream.firstWhere((element) => true);
      },
      child: CustomScrollView(
        slivers: [
          StatusBarHack(),
          SliverList(
            //Lazy build area
            delegate: SliverChildListDelegate.fixed(
              [
                WeatherCorver(),
                SizedBox(height: Insets.xlarge),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Insets.medium, horizontal: kLateralPadding),
                  child: Text(
                    'Daily Forecast', //Todo: localizate
                    style: Theme.of(context).textTheme.headline6,
                  ), //Todo: l10n
                ),
                DatllyForecastChart(),
                DailyForecastList(),
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
                LocatioMap(),
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

class WeatherCorver extends StatelessWidget {
  const WeatherCorver({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final viewPortheight = mediaQuery.size.height;
    final topSafeHeight = mediaQuery.size.height - mediaQuery.padding.top;
    final safeHeight =
        viewPortheight - mediaQuery.padding.top - mediaQuery.padding.bottom;
    return Stack(
      children: [
        DynamicBackground(height: topSafeHeight),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: safeHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kLateralPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActionsMenu(),
                WeatherTitle(),
                WeatherSubtitle(),
                CurrentMainWeather(),
                Spacer(),
                WeatherUtilitsWidget(),
                WeatherLastUpdated(),
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
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    final weatherCondition =
        context.select<WeatherBloc, WeatherCondition>((WeatherBloc bloc) {
      final state = bloc.state;
      if (state is WeatherLoadSuccess) {
        return state.weather.weatherForecasts.first.condition;
      } else {
        return WeatherCondition.unknown;
      }
    });
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final background = isDarkMode
        ? 'assets/images/background/dark_${'light_rain'}.png' //Todo: dynamic background
        : 'assets/images/background/${'light_rain'}.png';

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
      final state = bloc.state;
      if (state is WeatherLoadSuccess) {
        return state.weather.weatherForecasts.first.condition;
      } else {
        return WeatherCondition.unknown;
      }
    });
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SliverAppBar(
      elevation: 0,
      toolbarHeight: 0,
      pinned: true,
      backgroundColor: Color(weatherCondition.toColor(isDarkMode)),
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
      context.read<WeatherBloc>().add(WeatherFetchRequested(locations: result));
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
      final state = bloc.state;
      if (state is WeatherLoadSuccess) {
        return state.weather.title;
      } else {
        return '';
      }
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
      final state = bloc.state;
      if (state is WeatherLoadSuccess) {
        return state.weather.weatherForecasts.first.date;
      } else {
        return DateTime(2021);
      }
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
          child: FirstColumn(),
        ),
        Flexible(
          child: ConditionAnimation(),
        ),
      ],
    );
  }
}

class FirstColumn extends StatelessWidget {
  const FirstColumn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CurrentTemp(),
          ConditionTitle(),
          MinMaxTemperature(),
        ],
      ),
    );
  }
}

class CurrentTemp extends StatelessWidget {
  const CurrentTemp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFahrenheit = context.select((SettingsBloc bloc) =>
        bloc.state.settings.tempUnitSystem == TempUnitSystem.fahrenheit);
    final temp = context.select<WeatherBloc, Temperature?>((WeatherBloc bloc) {
      final state = bloc.state;
      if (state is WeatherLoadSuccess) {
        return state.weather.weatherForecasts.first.temp;
      }
    });
    final currentTemp = isFahrenheit ? temp?.fahrenheit : temp?.celsius;
    return Text(
      '${currentTemp?.round()}°',
      style: Theme.of(context).textTheme.headline1,
    );
  }
}

class ConditionTitle extends StatelessWidget {
  const ConditionTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherCondition =
        context.select<WeatherBloc, WeatherCondition>((WeatherBloc bloc) {
      final state = bloc.state;
      if (state is WeatherLoadSuccess) {
        return state.weather.weatherForecasts.first.condition;
      } else {
        return WeatherCondition.unknown;
      }
    });

    return Text(weatherCondition.toLocalizedTitle(context),
        style: Theme.of(context).textTheme.headline6);
  }
}

class MinMaxTemperature extends StatelessWidget {
  const MinMaxTemperature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFahrenheit = context.select((SettingsBloc bloc) =>
        bloc.state.settings.tempUnitSystem == TempUnitSystem.fahrenheit);
    final weatherForecast =
        context.select<WeatherBloc, WeatherForecast?>((WeatherBloc bloc) {
      final state = bloc.state;
      if (state is WeatherLoadSuccess) {
        return state.weather.weatherForecasts.first;
      }
    });

    final maxTemp = isFahrenheit
        ? weatherForecast?.maxTemp.fahrenheit
        : weatherForecast?.maxTemp.celsius;

    final minTemp = isFahrenheit
        ? weatherForecast?.minTemp.fahrenheit
        : weatherForecast?.minTemp.celsius;
    return Row(
      children: [
        Text(
          '${maxTemp?.round()}°',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Text(
          '${minTemp?.round()}°',
          style: Theme.of(context).textTheme.subtitle2, //Todo: style
        ),
      ],
    );
  }
}

class ConditionAnimation extends StatelessWidget {
  const ConditionAnimation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String brightness =
        Theme.of(context).brightness == Brightness.light ? '' : 'colors/';
    final weatherCondition =
        context.select<WeatherBloc, WeatherCondition>((WeatherBloc bloc) {
      final state = bloc.state;
      if (state is WeatherLoadSuccess) {
        return state.weather.weatherForecasts.first.condition;
      } else {
        return WeatherCondition.unknown;
      }
    });
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
  const WeatherUtilitsWidget({Key? key}) : super(key: key);
  final borderRadius = 20.0;

  @override
  Widget build(BuildContext context) {
    final isImperial = context.select((SettingsBloc bloc) =>
        bloc.state.settings.lenghtUnit == LenghtUnit.imperial);

    final weatherState =
        context.select<WeatherBloc, WeatherForecast?>((WeatherBloc bloc) {
      final state = bloc.state;
      if (state is WeatherLoadSuccess) {
        return state.weather.weatherForecasts.first;
      }
    });

    final windSpeed = isImperial
        ? '${weatherState?.windSpeed.imperial.round()} mph'
        : '${weatherState?.windSpeed.metric.round()} km/h';

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
                    Text('${weatherState?.humidity.round()}%'),
                    Text(AppLocalizations.of(context).humidity)
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('${weatherState?.airPressure.toStringAsFixed(1)} mb'),
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
  const WeatherLastUpdated({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = context.select<WeatherBloc, DateTime?>((bloc) {
      final state = bloc.state;
      if (state is WeatherLoadSuccess) {
        return state.weather.time;
      }
    });
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.xlarge),
      child: Center(
        child: Text(AppLocalizations.of(context)
            .homepageLastUpdated(time?.toLocal() ?? DateTime(0))),
      ),
    );
  }
}

class DailyForecastList extends StatelessWidget {
  const DailyForecastList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherForecastList =
        context.select<WeatherBloc, List<WeatherForecast>?>((WeatherBloc bloc) {
      final state = bloc.state;
      if (state is WeatherLoadSuccess) {
        return state.weather.weatherForecasts;
      }
    });

    return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(
            vertical: Insets.medium, horizontal: kLateralPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Todo: l10n
            ...List.generate(
                weatherForecastList?.length ?? 0,
                (index) => DailyForecastItem(
                      index: index,
                      weatherForecast: weatherForecastList?[index],
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
  final WeatherForecast? weatherForecast;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isFahrenheit = context.select((SettingsBloc bloc) =>
        bloc.state.settings.tempUnitSystem == TempUnitSystem.fahrenheit);

    final maxTemp = isFahrenheit
        ? weatherForecast?.maxTemp.fahrenheit
        : weatherForecast?.maxTemp.celsius;

    final minTemp = isFahrenheit
        ? weatherForecast?.minTemp.fahrenheit
        : weatherForecast?.minTemp.celsius;

    late String weekDay;

    switch (index) {
      case 0:
        weekDay = AppLocalizations.of(context).weekToday;
        break;
      case 1:
        weekDay = AppLocalizations.of(context).weekTomorrow;
        break;
      default:
        weekDay = AppLocalizations.of(context)
            .weekDay(weatherForecast?.date.toLocal() ?? DateTime(0));
    }
    log(index.toString());

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
              child: Text(
                  weatherForecast?.condition.toLocalizedTitle(context) ?? ''),
            ),
            //Todo: include icon
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('${maxTemp?.round()}°/${minTemp?.round()}°'))),
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
        ]),
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
