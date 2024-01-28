import 'package:flutter/foundation.dart';
import 'package:shubham_weather/constants/env.dart';
import 'package:weather/weather.dart';

class WeatherService {
  final WeatherFactory _weatherFactory = WeatherFactory(openWeatherApiKey);

  Future<Weather?> getCurrentWeather(String cityName) async {
    try {
      return await _weatherFactory.currentWeatherByCityName(cityName);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching weather data: $error');
      }
      return null;
    }
  }

  Future<Weather?> getCurrentWeatherByLocation(double lat, double lon) async {
    try {
      return await _weatherFactory.currentWeatherByLocation(lat, lon);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching weather data: $error');
      }
      return null;
    }
  }

  Future<List<Weather>> getForecastWeather(String cityName) async {
    try {
      return await _weatherFactory.fiveDayForecastByCityName(cityName);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching weather data: $error');
      }
      return [];
    }
  }
}
