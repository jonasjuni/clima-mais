import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:clima_mais/location_search/location_search.dart';
import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/settings/settings.dart';
import 'package:clima_mais/weather/bloc/weather_bloc.dart';
import 'package:clima_mais/theme.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Insets.small),
        child: ListView(
          children: [
            const SideTopMenu(),
            const SideMenuLogo(),
            BlocBuilder<WeatherBloc, WeatherState>(
              buildWhen: (previous, current) {
                return current is WeatherLoadSuccess;
              },
              builder: (context, state) {
                if (state is WeatherLoadSuccess) {
                  return LocationManagementList(locations: state.locations);
                }
                return const SizedBox(
                  height: 56 * 5,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SideTopMenu extends StatelessWidget {
  const SideTopMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
          icon: const Icon(Icons.settings),
          tooltip: AppLocalizations.of(context).settingsTitle,
        ),
      ],
    );
  }
}

class SideMenuLogo extends StatelessWidget {
  const SideMenuLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Insets.medium),
      alignment: Alignment.center,
      //TODO include clima mais logo
      child: const FlutterLogo(
        size: 150,
      ),
    );
  }
}

class LocationManagementList extends StatelessWidget {
  const LocationManagementList({Key? key, required this.locations})
      : super(key: key);
  final List<Location> locations;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.medium),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context).locationsSaved,
              semanticsLabel: AppLocalizations.of(context).locationsSaved,
            ),
          ),
          Container(
            height: 56 * 5,
            margin: const EdgeInsets.symmetric(vertical: Insets.small),
            //TODO A11y a Merge is removing CustomSemanticsAction https://github.com/flutter/flutter/issues/71396
            child: ReorderableListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: locations.length,
              // prototypeItem: const ListTile(), // Prototype jumps down bug
              onReorder: (oldIndex, newIndex) => context
                  .read<WeatherBloc>()
                  .add(WeatherLocationOrderChanged(
                      oldIndex: oldIndex,
                      newIndex: newIndex,
                      locations: locations)),
              itemBuilder: (context, index) => SlidableListTile(
                key: ObjectKey(locations[index]),
                location: locations[index],
                onDelete: () {
                  context
                      .read<WeatherBloc>()
                      .add(WeatherLocationDeleted(index: index));
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          AddNewCityButton(
            onPressed: locations.length < 5
                ? () async {
                    final result = await Navigator.push<List<Location>>(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LocationSearchPage(userLocations: locations)),
                    );

                    if (result == null) {
                      return;
                    } else {
                      Navigator.of(context).pop();
                      context
                          .read<WeatherBloc>()
                          .add(WeatherFetchRequested(locations: result));
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class AddNewCityButton extends StatelessWidget {
  const AddNewCityButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add),
            Text(AppLocalizations.of(context).addNewCity),
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class SlidableListTile extends StatelessWidget {
  const SlidableListTile(
      {required Key key, required this.location, this.onDelete})
      : super(key: key);

  final Location location;
  final VoidCallback? onDelete;

  Icon _getIconData(LocationType locationType) {
    switch (locationType) {
      case LocationType.physical:
        return const Icon(
          Icons.location_on_outlined,
          semanticLabel: 'GPS location', //TODO A11y
        );
      case LocationType.saved:
        return const Icon(
          Icons.bookmark_outlined,
          semanticLabel: 'Saved location', //TODO A11y
        );
      case LocationType.history:
        return const Icon(Icons.history_outlined);
      case LocationType.fetched:
        return const Icon(Icons.location_city_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deleteL10n = MaterialLocalizations.of(context).deleteButtonTooltip;
    return Slidable(
      key: key,
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.24,
        children: [
          SlidableAction(
            label: deleteL10n,
            icon: Icons.delete,
            backgroundColor: Theme.of(context).errorColor,
            onPressed: (context) async {
              showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Row(
                          children: [
                            const Icon(Icons.delete),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Insets.small),
                              child: Text(deleteL10n),
                            )
                          ],
                        ),
                        content: Text(AppLocalizations.of(context)
                            .deletePrompt(location.title)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(AppLocalizations.of(context).no),
                          ),
                          TextButton(
                            onPressed: onDelete,
                            child: Text(AppLocalizations.of(context).yes),
                          ),
                        ],
                      ));
            },
          ),
        ],
      ),
      child: ListTile(
        leading: _getIconData(location.locationType),
        title: Text(location.title),
        trailing: const Icon(
          Icons.drag_indicator,
        ),
      ),
    );
  }
}
