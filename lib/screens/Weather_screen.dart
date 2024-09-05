import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:video_player/video_player.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  LatLng _selectedLocation = LatLng(36.8065, 10.1815); // Default to Tunisia
  Map<String, dynamic>? _weatherData;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();

    // Initialize the video player for the white section
    _controller = VideoPlayerController.asset('assets/vecteezy_slow-motion-rain-background_30756198.mp4');
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.setLooping(true);
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchWeatherData() async {
    final apiKey = 'L7slYr2lmHvkHRCtTtoP1fdBhZ68rPEE';
    final url =
        'https://api.tomorrow.io/v4/timelines?location=${_selectedLocation.latitude},${_selectedLocation.longitude}&fields=temperature,windSpeed,weatherCode&timesteps=1d&units=metric&apikey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _weatherData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      _selectedLocation = latlng;
    });
    _fetchWeatherData();
  }

  String getWeatherDescription(int weatherCode) {
    switch (weatherCode) {
      case 1000:
        return "Clear, Sunny";
      case 1001:
        return "Cloudy";
      case 1100:
        return "Mostly Clear";
      case 1101:
        return "Partly Cloudy";
      case 1102:
        return "Mostly Cloudy";
      case 2000:
        return "Fog";
      case 2100:
        return "Light Fog";
      case 3000:
        return "Light Wind";
      case 3001:
        return "Windy";
      case 3002:
        return "Strong Wind";
      case 4000:
        return "Drizzle";
      case 4001:
        return "Rain";
      case 4200:
        return "Light Rain";
      case 4201:
        return "Heavy Rain";
      case 5000:
        return "Snow";
      case 5001:
        return "Flurries";
      case 5100:
        return "Light Snow";
      case 5101:
        return "Heavy Snow";
      case 6000:
        return "Freezing Drizzle";
      case 6001:
        return "Freezing Rain";
      case 6200:
        return "Light Freezing Rain";
      case 6201:
        return "Heavy Freezing Rain";
      case 7000:
        return "Ice Pellets";
      case 7101:
        return "Heavy Ice Pellets";
      case 7102:
        return "Light Ice Pellets";
      case 8000:
        return "Thunderstorm";
      default:
        return "Unknown Weather Condition";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend the body behind the transparent AppBar
      appBar: AppBar(
        title: Text(
          'Weather Information',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.3), // Transparent black header to blend with the video
        elevation: 0,
      ),
      body: Column(
        children: [
          // Map section remains intact
          Expanded(
            flex: 2, // Adjust flex to make room for the bottom section
            child: FlutterMap(
              options: MapOptions(
                center: _selectedLocation,
                zoom: 5.0,
                onTap: _onMapTap,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _selectedLocation,
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red.withOpacity(0.7), // Make icon slightly transparent
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Weather information section with video background
          Expanded(
            flex: 3, // Adjusted flex to take more space
            child: Stack(
              children: [
                FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      );
                    } else {
                      return Container(color: Colors.black);
                    }
                  },
                ),
                _weatherData != null
                    ? _buildWeatherInfo()
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo() {
    final dailyData = _weatherData!['data']['timelines'][0]['intervals'];

    return ListView.builder(
      padding: EdgeInsets.only(top: 20),
      itemCount: dailyData.length,
      itemBuilder: (context, index) {
        final dayData = dailyData[index];
        final date = DateTime.parse(dayData['startTime']);
        final temperature = dayData['values']['temperature'];
        final windSpeed = dayData['values']['windSpeed'];
        final weatherCode = dayData['values']['weatherCode'];
        final weatherDescription = getWeatherDescription(weatherCode);

        return Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: Colors.black.withOpacity(0.5), // Transparent black to fit the video theme
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            title: Text(
              '${date.day}/${date.month}/${date.year}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9), // White text to stand out against the dark background
              ),
            ),
            subtitle: Text(
              'Temp: $temperature°C, Wind: $windSpeed m/s, Weather: $weatherDescription',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7), // Slightly faded white for the subtitle
              ),
            ),
          ),
        );
      },
    );
  }
}
