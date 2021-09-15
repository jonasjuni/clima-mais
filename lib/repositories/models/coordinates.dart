class Coordinates {
  const Coordinates(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  @override
  String toString() {
    return 'Latitude: $latitude, Longitude: $longitude';
  }
}
