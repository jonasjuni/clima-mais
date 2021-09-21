import 'package:clima_mais/location_search/location_search.dart';
import 'package:clima_mais/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeatherEmpty extends StatelessWidget {
  const WeatherEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                final result = await Navigator.push<List<Location>>(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const LocationSearchPage(userLocations: [])),
                );

                if (result == null) {
                  return;
                } else {
                  context
                      .read<WeatherBloc>()
                      .add(WeatherRequested(locations: result));
                }
              }),
          Text(AppLocalizations.of(context).homepageSelectCityRequest),
        ],
      ),
    ));
  }
}
