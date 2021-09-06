import 'package:meta_weather/meta_weather.dart';

class WeatherRepository {
  final WeatherApiClient weatherApiClient;

  WeatherRepository({required this.weatherApiClient});

  Future<Weather> getWeather(String city) async {
    final location = await weatherApiClient.getLocatioId(city);

    return location.isEmpty
        ? throw Exception('City not supported')
        : weatherApiClient.fetchWeather(location[0].woeid);
  }
}
