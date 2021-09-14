import 'package:clima_mais/repositories/repositories.dart';

abstract class WeatherRepository {
  Future<List<Location>> getLocationIdByName(String name);
  Future<List<Location>> getLocationByCoordinates(Coordinates coordinates);
  Future<Weather> getWeatherById(int id);

  Future<Coordinates> getDeviceCoordinates();
}
