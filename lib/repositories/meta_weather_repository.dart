import 'package:clima_mais/repositories/repositories.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta_weather/meta_weather.dart' as meta_weather;

class MetaWeatherRepository implements WeatherRepository {
  MetaWeatherRepository(
      {required meta_weather.WeatherApiClient weatherApiClient})
      : _weatherApiClient = weatherApiClient;

  final meta_weather.WeatherApiClient _weatherApiClient;

  // Future<List<Location>> getLocationIdByName(String name) async {
  //   final location = await _weatherApiClient.getLocatioId(name);

  //   return location.isEmpty
  //       ? throw Exception('City not supported')
  //       // : _weatherApiClient.fetchWeather(location[0].woeid);
  //       : location;
  // }

  @override
  Future<Coordinates> getDeviceCoordinates() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const PermissionDeniedException('Permission Denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw const PermissionDeniedException('Denied forever');
    }

    return (await Geolocator.getCurrentPosition()).toCoordinates();
  }

  @override
  Future<List<Location>> getLocationByCoordinates(
      Coordinates coordinates) async {
    return (await _weatherApiClient.getLocatioByLattLong(
            lattitude: coordinates.latitude, longitude: coordinates.longitude))
        .map((e) => e.toPhysicalLocation())
        .toList();
  }

  @override
  Future<List<Location>> getLocationIdByName(String name) async {
    return (await _weatherApiClient.getLocatioByQuery(name))
        .map((e) => e.toLocation())
        .toList();
  }

  @override
  Future<Weather> getWeatherById(int id) async {
    return (await _weatherApiClient.fetchWeather(id)).toWeather();
  }
}

//Convert to local models
extension GeolocationPositionXCoordinates on Position {
  Coordinates toCoordinates() => Coordinates(latitude, longitude);
}

extension MetaWeatherCoordinatesXCoordinates on meta_weather.Coordinates {
  Coordinates toCoordinates() => Coordinates(latitude!, longitude!);
}

extension MetaWeatherLocationXLocation on meta_weather.Location {
  Location toLocation() =>
      Location(title, woeid, lattLong.toCoordinates(), LocationType.fetched);
  Location toPhysicalLocation() =>
      Location(title, woeid, lattLong.toCoordinates(), LocationType.physical);
}

extension ConsolidatedWeatherdXWeatherForecast
    on meta_weather.ConsolidatedWeather {
  WeatherForecast toWeatherForecast() {
    final WeatherCondition weatherCondition;
    switch (weatherState) {
      case meta_weather.WeatherState.snow:
        weatherCondition = WeatherCondition.mediumSnow;
        break;
      case meta_weather.WeatherState.sleet:
        weatherCondition = WeatherCondition.sleet;
        break;
      case meta_weather.WeatherState.hail:
        weatherCondition = WeatherCondition.unknown;
        break;
      case meta_weather.WeatherState.thunderstorm:
        weatherCondition = WeatherCondition.thunderstorm;
        break;
      case meta_weather.WeatherState.heavyRain:
        weatherCondition = WeatherCondition.heavyRain;
        break;
      case meta_weather.WeatherState.lightRain:
        weatherCondition = WeatherCondition.lightRain;
        break;
      case meta_weather.WeatherState.showers:
        weatherCondition = WeatherCondition.mediumRain;
        break;
      case meta_weather.WeatherState.heavyCloud:
        weatherCondition = WeatherCondition.cloudy;
        break;
      case meta_weather.WeatherState.lightCloud:
        weatherCondition = WeatherCondition.partlyCloudy;
        break;
      case meta_weather.WeatherState.clear:
        weatherCondition = WeatherCondition.sunny;
        break;
      case meta_weather.WeatherState.unknownEntry:
        weatherCondition = WeatherCondition.unknown;
        break;
    }

    return WeatherForecast(
      condition: weatherCondition,
      weatherStateName: weatherStateName,
      minTemp: Temperature.fromCelsius(minTemp),
      maxTemp: Temperature.fromCelsius(maxTemp),
      temp: Temperature.fromCelsius(theTemp),
      humidity: humidity,
      airPressure: airPressure,
      windSpeed: Speed.fromImperial(windSpeed),
      windDirection: windDirectionCompass,
      created: created,
      date: applicableDate,
    );
  }
}

extension MetaWeatherXWeather on meta_weather.Weather {
  Weather toWeather() => Weather(
      consolidatedWeather.map((e) => e.toWeatherForecast()).toList(),
      lattLong.toCoordinates(),
      sunRise,
      sunSet,
      time,
      timezone,
      timezoneName,
      title,
      woeid);
}
