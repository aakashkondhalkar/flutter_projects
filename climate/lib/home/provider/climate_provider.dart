import 'dart:convert';

import 'package:climate/api_key.dart';
import 'package:climate/home/model/model.dart';
import 'package:http/http.dart' as http;

class ClimateProvider {
  static Future<Climate> fetchClimate(
      {required String city, required String countryCode}) async {
    String api =
        'http://api.openweathermap.org/data/2.5/weather?q=$city,$countryCode&appid='
        '$appID&units=metric';

    final response = await http.get(Uri.parse(api));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body.toString());
      return Climate.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load climate');
    }
  }
}
