import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context)
              .appBarTheme
              .systemOverlayStyle
              ?.copyWith(statusBarColor: Colors.transparent) ??
          const SystemUiOverlayStyle(),
      child: BlocProvider(
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
                  hint: AppLocalizations.of(context).locationSearch,
                  isScrollControlled: true,
                  builder: (context, _) {
                    if (state is LocationFetchSuccess) {
                      return Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Material(
                          child: Column(
                            children: state.locations
                                .map((e) => LocationTile(
                                      location: e,
                                      userLocations: userLocations,
                                    ))
                                .toList(),
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                  onSubmitted: (value) => context
                      .read<LocationSearchBloc>()
                      .add(LocationSearchQueryChanged(
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
                        child: Text(
                            AppLocalizations.of(context).locationSearchGPS),
                      ),
                    ],
                  ));
            },
          ),
        ),
      ),
    );
  }
}

class LocationTile extends StatelessWidget {
  const LocationTile(
      {Key? key, required this.location, required this.userLocations})
      : super(key: key);

  final Location location;
  final List<Location> userLocations;

  IconData _getIconData(LocationType locationType) {
    switch (locationType) {
      case LocationType.physical:
        return Icons.location_on_outlined;
      case LocationType.saved:
        return Icons.bookmark_outlined;
      case LocationType.history:
        return Icons.history_outlined;
      case LocationType.fetched:
        return Icons.location_city_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_getIconData(location.locationType)),
      title: Text(location.title),
      onTap: () => context.read<LocationSearchBloc>().add(
          LocationSearchLocationSelected(
              selectedLocation: location, userLocations: userLocations)),
    );
  }
}
