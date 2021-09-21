import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/location_search/location_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class LocationSearchPage extends StatelessWidget {
  const LocationSearchPage({Key? key, required this.userLocations})
      : super(key: key);

  final List<Location> userLocations;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationSearchBloc(
        weatherRepository: context.read<WeatherRepository>(),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<LocationSearchBloc, LocationSearchState>(
          listenWhen: (previous, current) =>
              current is LocationAddSuccess || current is LocationFetchFail,
          listener: (context, state) {
            if (state is LocationAddSuccess) {
              Navigator.pop<List<Location>>(context, state.locations);
            }
          },
          builder: (context, state) {
            final isLoading = state is LocationFetchInProgess;
            return FloatingSearchBar(
                //Todo: create my own search widget
                clearQueryOnClose: false,
                progress: isLoading,
                hint: 'Search available cities', //TODO: l10n
                isScrollControlled: true,
                builder: (context, _) {
                  if (state is LocationFetchSuccess) {
                    return Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        children: state.locations
                            .map((e) =>
                                LocationItem(title: e.title, id: e.woeid))
                            .toList(),
                      ),
                    );
                  }
                  return Container();
                },
                onSubmitted: (value) => context.read<LocationSearchBloc>().add(
                    LocationSearchByNameRequested(
                        query: value, userLocations: userLocations)),
                onQueryChanged: (value) => context
                    .read<LocationSearchBloc>()
                    .add(LocationSearchQueryChanged(
                        query: value, userLocations: userLocations)),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () => context.read<LocationSearchBloc>().add(
                              LocationSearchByCoordinatesRequested(
                                  userLocations: userLocations)),
                      child: const Text('Use you location'), //TODO: l10n
                    ),
                  ],
                ));
          },
        ),
      ),
    );
  }
}

class LocationItem extends StatelessWidget {
  final String title;
  final int id;

  const LocationItem({Key? key, required this.title, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
    );
  }
}
