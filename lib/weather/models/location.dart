import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

enum LocationType {
  @JsonValue('City')
  city,
  @JsonValue('Region')
  region,
  @JsonValue('State')
  state,
  @JsonValue('Province')
  province,
  @JsonValue('Country')
  country,
  @JsonValue('Continent')
  continent
}

@JsonSerializable()
class Location {
  final String title;
  final LocationType locationType;
  final int woeid;
  @JsonKey(name: 'latt_long')
  final Coordinates lattLong;

  const Location(this.title, this.locationType, this.woeid, this.lattLong);

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

class Coordinates {
  final double? latitude;
  final double? longitude;

  const Coordinates({this.latitude, this.longitude});

  factory Coordinates.fromJson(String? json) {
    if (json != null) {
      final part = json.split(',');
      if (part.length == 2) {
        return Coordinates(
            latitude: double.tryParse(part[0]),
            longitude: double.tryParse(part[1]));
      }
    }
    return Coordinates();
  }

  String? toJson() => '${latitude ?? ''},${longitude ?? ''}';
}
