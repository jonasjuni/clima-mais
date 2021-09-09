// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Location',
      json,
      ($checkedConvert) {
        final val = Location(
          $checkedConvert('title', (v) => v as String),
          $checkedConvert(
              'location_type', (v) => _$enumDecode(_$LocationTypeEnumMap, v)),
          $checkedConvert('woeid', (v) => v as int),
          $checkedConvert(
              'latt_long', (v) => Coordinates.fromJson(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'locationType': 'location_type',
        'lattLong': 'latt_long'
      },
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'title': instance.title,
      'location_type': _$LocationTypeEnumMap[instance.locationType],
      'woeid': instance.woeid,
      'latt_long': instance.lattLong.toJson(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$LocationTypeEnumMap = {
  LocationType.city: 'City',
  LocationType.region: 'Region',
  LocationType.state: 'State',
  LocationType.province: 'Province',
  LocationType.country: 'Country',
  LocationType.continent: 'Continent',
};
