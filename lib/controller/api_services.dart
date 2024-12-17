import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../model/current_weather_data.dart';
import '../model/hourly_weather_data.dart';
import 'package:geolocator/geolocator.dart';

const String apiKey = "5f6a56fc55c9eaadadec9e3cae418df7";
const String baseUrl = "https://api.openweathermap.org/data/2.5/weather";
const String currentEndpoint =
    "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid=$apiKey";

final weatherProvider =
    FutureProvider.autoDispose<CurrentWeatherData>((ref) async {
  final position = await getUserLocation();
  if (position == null) {
    throw Exception("Failed to get user location");
  }
  final lat = position.latitude.toString();
  final lon = position.longitude.toString();
  final response =
      await http.get(Uri.parse("$baseUrl?lat=$lat&lon=$lon&appid=$apiKey"));

  if (response.statusCode == 200) {
    var data = currentWeatherDataFromJson(response.body.toString());
    log("Data received successfully");
    return data;
  } else {
    throw Exception("Failed to load weather data");
  }
});

final hourlyProvider =
    FutureProvider.autoDispose<HourlyWeatherData>((ref) async {
  final position = await getUserLocation();
  if (position == null) {
    throw Exception("Failed to get user location");
  }
  final lat = position.latitude.toString();
  final lon = position.longitude.toString();
  final response = await http.get(Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey"));

  if (response.statusCode == 200) {
    var data = hourlyWeatherDataFromJson(response.body.toString());
    log("Data received successfully");
    return data;
  } else {
    throw Exception("Failed to load weather data");
  }
});

Future<Position?> getUserLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permission denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permission permanently denied');
  }

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  return position;
}

final locationProvider = FutureProvider<Position?>((ref) async {
  return await getUserLocation();
});
