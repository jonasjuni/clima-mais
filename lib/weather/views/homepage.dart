import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/settings/views/view.dart';
import 'package:clima_mais/theme/bloc/theme_bloc.dart';
import 'package:clima_mais/weather/bloc/weather_bloc.dart';
import 'package:clima_mais/weather/views/city_selection_view.dart';
import 'package:clima_mais/weather/widgets/widgets.dart';

class WeatherHomePage extends StatelessWidget {
  const WeatherHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WeatherBloc(weatherRepository: context.read<WeatherRepository>()),
      child: const WeatherView(),
    );
  }
}

class WeatherView extends StatelessWidget {
  const WeatherView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          final bloc = context.read<WeatherBloc>();
          final state = bloc.state;

          if (state is WeatherLoadSuccess) {
            bloc.add(WeatherRequested(city: state.weather.title));
          } else if (state is WeatherLoadFailure) {
            bloc.add(WeatherRequested(city: state.requestedCity));
          }
          return bloc.stream.firstWhere((element) =>
              element is WeatherLoadSuccess || element is WeatherLoadFailure);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              // backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      final city = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CitySelection()));
                      if (city != null) {
                        context
                            .read<WeatherBloc>()
                            .add(WeatherRequested(city: city));
                      }
                    }),
                IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () async {
                      Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPageView()));
                    }),
              ],
            ),
            const SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  BlocLogic(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlocLogic extends StatelessWidget {
  const BlocLogic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(listener: (context, state) {
      if (state is WeatherLoadSuccess) {
        context.read<ThemeBloc>().add(WeatherChanged(weather: state.weather));
      }
    }, builder: (context, state) {
      if (state is WeatherInitial) {
        return const WeatherEmpty();
      }
      if (state is WeatherLoadInProgress) {
        return const WeatherLoading();
      }
      if (state is WeatherLoadSuccess) {
        return WeatherSuccess(weather: state.weather);
      }
      if (state is WeatherLoadFailure) {
        return WeatherFailure(exception: state.exception);
      }
      throw Error();
    });
  }
}
