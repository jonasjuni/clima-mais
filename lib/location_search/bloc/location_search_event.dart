part of 'location_search_bloc.dart';

@immutable
abstract class LocationSearchEvent {
  const LocationSearchEvent();
}

class LocationSearchByNameRequested extends LocationSearchEvent {
  final String query;
  final List<Location> userLocations;

  const LocationSearchByNameRequested(
      {required this.query, required this.userLocations});
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
