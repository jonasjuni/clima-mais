part of 'location_search_bloc.dart';

@immutable
abstract class LocationSearchState {}

class LocationSearchInitial extends LocationSearchState {}

class LocationSearchInProgess extends LocationSearchState {}

class LocationSearchSuccess extends LocationSearchState {}

class LocationSearchFail extends LocationSearchState {
  final Exception exception;
  final String query;

  LocationSearchFail({required this.exception, required this.query});
}
