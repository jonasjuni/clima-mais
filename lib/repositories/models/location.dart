import 'models.dart';

enum LocationType { physical, saved, history, fetched }

class Location {
  final String title;
  final int woeid;
  final Coordinates lattLong;
  final LocationType locationType;

  const Location(this.title, this.woeid, this.lattLong, this.locationType);

  @override
  String toString() {
    return '$title: $woeid, $locationType';
  }
}
