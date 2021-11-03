import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'package:clima_mais/weather/weather.dart';
import 'package:clima_mais/repositories/repositories.dart';

class LocatioMap extends StatefulWidget {
  const LocatioMap({Key? key, required this.latlng}) : super(key: key);

  @override
  State<LocatioMap> createState() => _LocatioMapState();

  final Coordinates latlng;
}

class _LocatioMapState extends State<LocatioMap> {
  late GoogleMapController _controller;
  String? mapStyle;
  Brightness? currentBrightness, previousBrightness;
  var isMapCreated = false;

  Future<void> _loadAsset() async {
    assert(isMapCreated == true);
    //context here? The newly created State object is associated with a BuildContext.
    final path = currentBrightness == Brightness.light
        ? 'assets/maps/light_style.json'
        : 'assets/maps/dark_style.json';
    //DefaulAsset alread caches string
    final style = await DefaultAssetBundle.of(context).loadString(path);
    _controller.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    //Save current Brightness
    currentBrightness = Theme.of(context).brightness;
    //If maps is created and there's a new brightness, update map style
    if (isMapCreated && currentBrightness != previousBrightness) {
      previousBrightness = currentBrightness;
      _loadAsset();
    }

    final latlng = LatLng(widget.latlng.latitude, widget.latlng.longitude);

    final _locationPosition = CameraPosition(
      target: latlng,
      zoom: 11.3,
    );
    if (isMapCreated) {
      assert(isMapCreated);
      _controller.moveCamera(CameraUpdate.newLatLng(latlng));
    }

    return SizedBox(
      height: 300,
      child: GoogleMap(
        onMapCreated: (controller) {
          isMapCreated = true;
          _controller = controller;
          _loadAsset();
        },
        initialCameraPosition: _locationPosition,
        liteModeEnabled: true,
      ),
    );
  }
}
