import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../model/current_weather_data.dart';
import '../model/hourly_weather_data.dart';

const String apiKey = "5f6a56fc55c9eaadadec9e3cae418df7";
const String baseUrl = "https://api.openweathermap.org/data/2.5/weather";
const String lat = "31.582045";
const String long = "74.329376";
const String currentEndpoint = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid=$apiKey";
const String hourlyLink = "api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apiKey";



final weatherProvider = FutureProvider.autoDispose<CurrentWeatherData>((ref) async {
  final response = await http.get(Uri.parse("$baseUrl?lat=$lat&lon=$long&appid=$apiKey"));

  if (response.statusCode == 200) {
    var data = currentWeatherDataFromJson(response.body.toString());
    log("Data received successfully");
    return data;
  } else {
    throw Exception("Failed to load weather data");
  }
});

final hourlyProvider = FutureProvider.autoDispose<HourlyWeatherData>((ref) async {
  final response = await http.get(Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apiKey"
  ));

  if (response.statusCode == 200) {
    var data = hourlyWeatherDataFromJson(response.body.toString());
    log("Data received successfully");
    return data;
  } else {
    throw Exception("Failed to load weather data");
  }
});