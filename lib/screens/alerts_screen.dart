import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:safetravel/screens/home_screen.dart'; // Make sure to import your HomeScreen

class AlertsScreen extends StatefulWidget {
  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<Map<String, dynamic>> _alerts = [];
  bool _isLoading = true;
  bool _isError = false;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Initialize video player controller
    _controller = VideoPlayerController.asset('assets/vecteezy_slow-motion-rain-background_30756198.mp4');
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {
        _controller.setLooping(true);
        _controller.play();
      });
    });

    // Fetch weather alerts
    _fetchWeatherAlerts();
  }

  Future<void> _fetchWeatherAlerts() async {
    final String apiUrl = 'http://localhost:4000/api/weather?lat=51.5074&lon=-0.1278';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> fetchedAlerts = data['alerts'];

        setState(() {
          _alerts = fetchedAlerts != null && fetchedAlerts.isNotEmpty
              ? fetchedAlerts.map((alert) {
            return {
              'title': alert['event'] ?? 'Weather Alert',
              'description': alert['description'] ?? 'No description available.',
              'time': _formatTime(alert['start']),
            };
          }).toList()
              : [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isError = true;
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  String _formatTime(String isoDate) {
    final DateTime dateTime = DateTime.parse(isoDate);
    return '${dateTime.hour}:${dateTime.minute} ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Real-Time Security Alerts'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate back to HomeScreen
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // Background video
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
                return Center(
                  child: CircularProgressIndicator(), // Show loading while video is initializing
                );
              }
            },
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.3)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          // Title text positioned lower
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Text(
              'Real-Time Security Alerts',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
          // Loading, error, or list of alerts
          Positioned.fill(
            top: 100,
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white.withOpacity(0.9)))
                : _isError
                ? Center(child: Text('Failed to load alerts. Please try again later.', style: TextStyle(color: Colors.white)))
                : _alerts.isEmpty
                ? Center(child: Text('No alerts available.', style: TextStyle(color: Colors.white)))
                : ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: _alerts.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white.withOpacity(0.2),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    title: Text(
                      _alerts[index]['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          _alerts[index]['description'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _alerts[index]['time'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.9)),
                    onTap: () {
                      // Navigate to detailed alert screen or take action
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
