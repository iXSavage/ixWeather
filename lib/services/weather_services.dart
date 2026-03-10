import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_model.dart';

class WeatherService {
  static String get _apiKey => dotenv.env['WEATHER_API_KEY'] ?? '';

  // Fetch weather by city name (for manual search)
  static Future<WeatherModel> fetchWeather(String city) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=$_apiKey&q=$city&aqi=yes',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception('Failed to load weather');
    }
  }

  // Fetch weather by coordinates (for auto-location)
  static Future<WeatherModel> fetchWeatherByCoordinates(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=$_apiKey&q=$lat,$lon&aqi=yes',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception('Failed to load weather');
    }
  }

  // Fetch forecast by city name (for manual search)
  static Future<ForecastWeatherModel> fetchForecastWeather(String city) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=$_apiKey&q=$city&days=7',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final forecastData = json.decode(response.body);
      return ForecastWeatherModel.fromJson(forecastData);
    } else {
      throw Exception('Failed to load weather');
    }
  }

  // Fetch forecast by coordinates (for auto-location)
  static Future<ForecastWeatherModel> fetchForecastWeatherByCoordinates(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=$_apiKey&q=$lat,$lon&days=7',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final forecastData = json.decode(response.body);
      return ForecastWeatherModel.fromJson(forecastData);
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
