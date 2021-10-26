import 'dart:developer';

import 'package:clima_mais/repositories/repositories.dart';
import 'package:clima_mais/settings/settings.dart';
import 'package:clima_mais/theme.dart';
import 'package:clima_mais/weather/bloc/weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Insets.small),
        child: Column(
          children: [
            TopMenu(),
            Logo(),
            Expanded(child: LocationManagementList())
          ],
        ),
      ),
    );
  }
}

class TopMenu extends StatelessWidget {
  const TopMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close)),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

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
    log('side menu build');
    final locations = context.select((WeatherBloc bloc) {
      final state = bloc.state;
      if (state is WeatherLoadSuccess) {
        return state.locations;
      }
      return <Location>[];
    });
    return Container(
      child: ReorderableListView.builder(
        itemCount: locations.length,
        onReorder: (oldIndex, newIndex) => context.read<WeatherBloc>().add(
            WeatherLocationOrderChanged(
                oldIndex: oldIndex, newIndex: newIndex, locations: locations)),
        itemBuilder: (context, index) => LocationTile(
            key: ObjectKey(locations[index]), location: locations[index]),
      ),
    );
  }
}

class LocationTile extends StatelessWidget {
  const LocationTile({Key? key, required this.location}) : super(key: key);

  final Location location;

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
    return ListTile(
      leading: Icon(_getIconData(location.locationType)),
      title: Text(location.title),
      onTap: () => null,
      trailing: Icon(Icons.drag_indicator),
    );
  }
}
