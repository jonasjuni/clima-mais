import 'models.dart';

enum LocationType { physical, saved, history, fetched }

class Location {
  final String title;
  final int woeid;
  final Coordinates lattLong;
  final LocationType locationType;

  const Location(this.title, this.woeid, this.lattLong, this.locationType);

  Location copyWith(
          {String? title,
          int? woeid,
          Coordinates? lattLong,
          LocationType? locationType}) =>
      Location(
        title = title ?? this.title,
        woeid = woeid ?? this.woeid,
        lattLong = lattLong ?? this.lattLong,
        locationType = locationType ?? this.locationType,
      );

  @override
  String toString() {
    return '$title: $woeid, $locationType';
  }
}
