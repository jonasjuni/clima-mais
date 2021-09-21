part of 'location_search_bloc.dart';

@immutable
abstract class LocationSearchState {
  const LocationSearchState();
}

class LocationSearchInitial extends LocationSearchState {}

class LocationFetchInProgess extends LocationSearchState {
  const LocationFetchInProgess();
}

class LocationFetchSuccess extends LocationSearchState {
  final List<Location> locations;
  const LocationFetchSuccess({required this.locations});
}

class LocationAddSuccess extends LocationSearchState {
  final List<Location> locations;
  const LocationAddSuccess({required this.locations});
}

class LocationFetchFail extends LocationSearchState {
  final Exception e;
  const LocationFetchFail({
    required this.e,
  });
}
