import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/settings/views/view.dart';
import 'package:clima_mais/theme/bloc/theme_bloc.dart';
import 'package:clima_mais/weather/bloc/weather_bloc.dart';
import 'package:clima_mais/weather/views/city_selection_view.dart';
import 'package:clima_mais/weather/widgets/widgets.dart';

class WeatherHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WeatherBloc(weatherRepository: context.read<WeatherRepository>()),
      child: WeatherView(),
    );
  }
}

class WeatherView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Weather'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                final city = await Navigator.push<String>(context,
                    MaterialPageRoute(builder: (context) => CitySelection()));
                if (city != null)
                  context.read<WeatherBloc>().add(WeatherRequested(city: city));
              }),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsPageView()));
              }),
        ],
      ),
      body: Center(
        child:
            BlocConsumer<WeatherBloc, WeatherState>(listener: (context, state) {
          if (state is WeatherLoadSuccess)
            context
                .read<ThemeBloc>()
                .add(WeatherChanged(weather: state.weather));
        }, builder: (context, state) {
          if (state is WeatherInitial) {
            return WeatherEmpty();
          }
          if (state is WeatherLoadInProgress) {
            return WeatherLoading();
          }
          if (state is WeatherLoadSuccess) {
            return WeatherSuccess(weather: state.weather);
          }
          if (state is WeatherLoadFailure) {
            return WeatherFailure(exception: state.exception);
          }
          throw Error();
        }),
      ),
    );
  }
}
