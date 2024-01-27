// weather_service.dart
import 'package:shubham_weather/constants/env.dart';
import 'package:weather/weather.dart';

class WeatherService {
  final WeatherFactory _weatherFactory = WeatherFactory(OPENWEATHER_API_KEY);

  Future<Weather?> getCurrentWeather(String cityName) async {
    try {
      return await _weatherFactory.currentWeatherByCityName(cityName);
    } catch (error) {
      print('Error fetching weather data: $error');
      return null;
    }
  }
}
