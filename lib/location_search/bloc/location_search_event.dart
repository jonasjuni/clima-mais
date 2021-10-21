part of 'location_search_bloc.dart';

@immutable
abstract class LocationSearchEvent {
  const LocationSearchEvent();
}

class LocationSearchByCoordinatesRequested extends LocationSearchEvent {
  final List<Location> userLocations;
  const LocationSearchByCoordinatesRequested({required this.userLocations});
}

class LocationSearchQueryChanged extends LocationSearchEvent {
  final String query;
  final List<Location> userLocations;
  const LocationSearchQueryChanged(
      {required this.query, required this.userLocations});
}

class LocationSearchFetched extends LocationSearchEvent {
  final String query;
  final List<Location> userLocations;
  const LocationSearchFetched(
      {required this.query, required this.userLocations});
}

class LocationSearchLocationSelected extends LocationSearchEvent {
  final Location selectedLocation;
  final List<Location> userLocations;
  const LocationSearchLocationSelected(
      {required this.selectedLocation, required this.userLocations});
}
