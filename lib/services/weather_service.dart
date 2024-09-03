import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = 'L7slYr2lmHvkHRCtTtoP1fdBhZ68rPEE';
  static const String baseUrl = 'https://api.tomorrow.io/v4/timelines';

  Future<Map<String, dynamic>> getWeather(double latitude, double longitude) async {
    final url = '$baseUrl?location=$latitude,$longitude&fields=temperature,precipitationType&timesteps=current&units=metric&apikey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
