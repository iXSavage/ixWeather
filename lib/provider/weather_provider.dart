import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/weather_services.dart';

/// Singleton helper to manage location permission
class LocationHelper {
  static Position? _lastPosition;
  static DateTime? _lastUpdate;

  static const Duration _cacheDuration = Duration(minutes: 15);

  static Future<Position> getPosition() async {
    // Return cached position if still valid
    if (_lastPosition != null &&
        _lastUpdate != null &&
        DateTime.now().difference(_lastUpdate!) < _cacheDuration) {
      return _lastPosition!;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied. Try again.");
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        "Location permission permanently denied. Please enable it in settings.",
      );
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );

    _lastPosition = position;
    _lastUpdate = DateTime.now();

    debugPrint("GPS Coordinates: ${position.latitude}, ${position.longitude}");

    return _lastPosition!;
  }

  static void clearCache() {
    _lastPosition = null;
    _lastUpdate = null;
  }
}

class WeatherProvider extends ChangeNotifier {
  WeatherModel? _weather;
  bool _isLoading = false;
  String? _error;

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch using coordinates (can be called with shared position)
  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await WeatherService.fetchWeatherByCoordinates(lat, lon);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _weather = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Auto-fetch weather using GPS coordinates
  Future<void> autoFetchCurrentLocationWeather() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final position = await LocationHelper.getPosition();
      _weather = await WeatherService.fetchWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      _weather = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetch weather by city name (for manual search)
  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await WeatherService.fetchWeather(city);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _weather = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}

class ForecastWeatherProvider extends ChangeNotifier {
  ForecastWeatherModel? _weather;
  bool _isLoading = false;
  String? _error;

  ForecastWeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch using coordinates (can be called with shared position)
  Future<void> fetchForecastByCoordinates(double lat, double lon) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await WeatherService.fetchForecastWeatherByCoordinates(
        lat,
        lon,
      );
      _error = null;
    } catch (e) {
      _error = 'Could not fetch forecast';
      _weather = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Auto-fetch forecast using GPS coordinates
  Future<void> autoFetchForecastLocationWeather() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final position = await LocationHelper.getPosition();
      _weather = await WeatherService.fetchForecastWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      _weather = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetch forecast by city name (for manual search)
  Future<void> fetchForecastWeather(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await WeatherService.fetchForecastWeather(city);
      _error = null;
    } catch (e) {
      _error = 'Could not fetch forecast';
      _weather = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}
