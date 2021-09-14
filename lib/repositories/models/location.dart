import 'models.dart';

class Location {
  final String title;
  final int woeid;
  final Coordinates lattLong;

  const Location(this.title, this.woeid, this.lattLong);
}
