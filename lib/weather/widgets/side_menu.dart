import 'dart:developer';

import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/settings/settings.dart';
import 'package:clima_mais/theme.dart';
import 'package:clima_mais/weather/bloc/weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Insets.small),
        child: Column(
          children: [
            SideTopMenu(),
            SideMenuLogo(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your locations',
                semanticsLabel:
                    'Locations list, the location on start will be displayed in the main page.',
              ),
            ),
            Expanded(child: LocationManagementList()),
            SideMenuFooter()
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
          tooltip: 'Settings', //TODO: l10n
        ),
      ],
    );
  }
}

class SideMenuLogo extends StatelessWidget {
  const SideMenuLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlutterLogo(
        size: 150,
      ),
    );
  }
}

class LocationManagementList extends StatelessWidget {
  const LocationManagementList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locations = context.select((WeatherBloc bloc) {
      final state = bloc.state;
      if (state is WeatherLoadSuccess) {
        return state.locations;
      }
      return <Location>[];
    });

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Insets.small),
      //Todo: a Merge is removing CustomSemanticsAction https://github.com/flutter/flutter/issues/71396
      child: ReorderableListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: locations.length,
        onReorder: (oldIndex, newIndex) => context.read<WeatherBloc>().add(
            WeatherLocationOrderChanged(
                oldIndex: oldIndex, newIndex: newIndex, locations: locations)),
        itemBuilder: (context, index) => ListItemTest(
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
    );
  }
}

class LocationManagementTile extends StatelessWidget {
  const LocationManagementTile({required this.key, required this.location})
      : super(key: key);

  final Location location;
  final Key key;
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
    log(key.toString());
    return Dismissible(
      key: key,
      dismissThresholds: {DismissDirection.endToStart: 0.2},
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).errorColor,
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {},
              ),
              content: Text('${location.title} Deleted'),
            ),
          );
        return Future.delayed(Duration(seconds: 5), () => false);
      },
      onDismissed: (direction) => null,
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: Insets.medium),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete),
      ),
      child: ListTile(
        leading: Icon(_getIconData(location.locationType)),
        title: Text(location.title),
        onTap: () => null,
        trailing: const Icon(Icons.drag_indicator),
      ),
    );
  }
}

class SideMenuFooter extends StatelessWidget {
  const SideMenuFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Insets.medium),
      child: Center(
        child: Text('jcsj.dev'),
      ),
    );
  }
}

class ListItemTest extends StatelessWidget {
  const ListItemTest({required Key key, required this.location, this.onDelete})
      : super(key: key);

  final Location location;
  final VoidCallback? onDelete;

  Icon _getIconData(LocationType locationType) {
    switch (locationType) {
      case LocationType.physical:
        return Icon(
          Icons.location_on_outlined,
          semanticLabel: 'GPS location', //Todo: l10n
        );
      case LocationType.saved:
        return Icon(
          Icons.bookmark_outlined,
          semanticLabel: 'Saved location',
        );
      case LocationType.history:
        return Icon(Icons.history_outlined);
      case LocationType.fetched:
        return Icon(Icons.location_city_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deleteL10n = MaterialLocalizations.of(context).deleteButtonTooltip;
    return Slidable(
      key: key,
      actionPane: SlidableBehindActionPane(),
      secondaryActions: [
        SlideAction(
          child: Container(
            color: Theme.of(context).errorColor,
            width: double.infinity,
            height: double.infinity,
            child: Icon(
              Icons.delete,
              semanticLabel: deleteL10n,
            ),
          ),
          onTap: () async {
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
                        ], //todo l10n
                      ),
                      content: Text(
                          'Do you want to delete ${location.title}?'), //todo l10n,
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('No'), //todo l10n
                        ),
                        TextButton(
                          onPressed: onDelete,
                          child: Text('Yes'), //todo l10n
                        ),
                      ],
                    ));
          },
        ),
      ],
      child: Container(
        // color: Theme.of(context).scaffoldBackgroundColor,
        child: Material(
          child: ListTile(
            leading: _getIconData(location.locationType),
            title: Text(location.title),
            trailing: const Icon(
              Icons.drag_indicator,
            ),
          ),
        ),
      ),
    );
  }
}
