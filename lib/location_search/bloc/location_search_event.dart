part of 'location_search_bloc.dart';

@immutable
abstract class LocationSearchEvent {
  const LocationSearchEvent();
}

class DeviceLocationRequested extends LocationSearchEvent {
  const DeviceLocationRequested();
}

class SearchLocationByNameRequested extends LocationSearchEvent {
  final String cityName;

  const SearchLocationByNameRequested(this.cityName);
}

class LocationSearchQueryChanged extends LocationSearchEvent {
  final String? cityName;
  const LocationSearchQueryChanged(this.cityName);
}
