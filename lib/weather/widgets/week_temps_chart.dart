import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:clima_mais/theme.dart';
import 'package:clima_mais/settings/settings.dart';
import 'package:clima_mais/repositories/repositories.dart';

const kHumidityColors = [
  Color(0x054AACFE),
  Color(0xFF4AACFE),
  Color(0xff00f2fe),
  Color(0x0500f2fe),
];
const kTempColors = [
  Color(0x10f9d423),
  Color(0xFFf9d423),
  Color(0xffff4e50),
  Color(0x10ff4e50),
];
const kWindColors = [
  Color(0x108baaaa),
  Color(0xFF8baaaa),
  Color(0xFFae8b9c),
  Color(0x10ae8b9c),
];

const barColorsList = [kHumidityColors, kTempColors, kWindColors];

class DailyForecastChart extends StatefulWidget {
  const DailyForecastChart({
    Key? key,
    required this.weatherForecasts,
  }) : super(key: key);

  @override
  State<DailyForecastChart> createState() => _DailyForecastChartState();

  final List<WeatherForecast> weatherForecasts;
}

class _DailyForecastChartState extends State<DailyForecastChart> {
  var _selectedIndex = 1;

  void _selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFahrenheit = context.select<SettingsBloc, bool>(
        (SettingsBloc bloc) => bloc.state.settings.isFahrenheit);

    final isImperial = context.select<SettingsBloc, bool>(
        (SettingsBloc bloc) => bloc.state.settings.isImperial);

    final weatherForecasts = widget.weatherForecasts;

    //Map
    final tempData = <FlSpot>[];
    final humidityData = <FlSpot>[];
    final windData = <FlSpot>[];
    for (var i = 0; i < weatherForecasts.length; i++) {
      final temperature = isFahrenheit
          ? weatherForecasts[i].temp.fahrenheit
          : weatherForecasts[i].temp.celsius;
      final windSpeed = isImperial
          ? weatherForecasts[i].windSpeed.imperial
          : weatherForecasts[i].windSpeed.metric;
      tempData.add(FlSpot(i.toDouble(), temperature));
      humidityData.add(FlSpot(i.toDouble(), weatherForecasts[i].humidity));
      windData.add(FlSpot(i.toDouble(), windSpeed));
    }

    final spotDataList = [humidityData, tempData, windData];
    final unitList = ['%', '°', isImperial ? ' mph' : ' km/h'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kLateralPadding),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: Insets.small),
            padding: const EdgeInsets.symmetric(
                horizontal: Insets.medium), //lable cliping
            height: 200,
            child: LineChart(
              LineChartData(
                // read about it in the LineChartData section
                gridData: FlGridData(
                  show: true,
                  verticalInterval: 1,
                  drawHorizontalLine: false,
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: SideTitles(showTitles: false),
                  leftTitles: SideTitles(showTitles: false),
                  rightTitles: SideTitles(showTitles: false),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (context, index) => Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.bold),
                    margin: Insets.medium,

                    getTitles: (value) {
                      if (value % 1 == 0) {
                        final int index = value.toInt();
                        return AppLocalizations.of(context)
                            .weekDayAbbr(weatherForecasts[index].date);
                      } else {
                        return '';
                      }
                    }, //Todo: localize date
                  ),
                ),
                lineTouchData: LineTouchData(
                  //Todo: a11y
                  touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Theme.of(context).cardColor,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          return LineTooltipItem(
                              '${touchedSpot.y.round()}${unitList[_selectedIndex]}',
                              const TextStyle());
                        }).toList();
                      }),
                ),
                lineBarsData: [
                  LineChartBarData(
                    curveSmoothness: 0.2,
                    spots: spotDataList[_selectedIndex],
                    barWidth: 3.5,
                    isCurved: true,
                    isStepLineChart: _selectedIndex == 0,
                    colors: barColorsList[_selectedIndex],
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
              swapAnimationDuration: const Duration(milliseconds: 500),
              swapAnimationCurve: Curves.linear,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: Insets.medium),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: Text(AppLocalizations.of(context).humidity),
                    selected: _selectedIndex == 0,
                    onSelected: (value) => _selectIndex(0),
                  ),
                ),
                Expanded(
                  child: ChoiceChip(
                    label: Text(AppLocalizations.of(context).settingsTemp),
                    selected: _selectedIndex == 1,
                    onSelected: (value) => _selectIndex(1),
                  ),
                ),
                Expanded(
                  child: ChoiceChip(
                    label: Text(AppLocalizations.of(context).windSpeed),
                    selected: _selectedIndex == 2,
                    onSelected: (value) => _selectIndex(2),
                  ),
                ),
              ],
            ),
          ), //Todo: localize
        ],
      ),
    );
  }
}
