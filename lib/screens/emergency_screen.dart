import 'dart:math'; // For math functions like sin, cos, etc.
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching Google Maps
import 'package:provider/provider.dart'; // For sending SMS
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart'; // For video background

import 'package:safetravel/providers/emergency_provider.dart'; // Your existing provider
import 'package:safetravel/screens/contacts_screen.dart'; // Your ContactsScreen that was working before

class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  List<Map<String, dynamic>> _guides = []; // For fetched nearby places
  String? emergencyContactNumber = '+216 28581523'; // Default contact number
  Location location = Location();
  bool _isGettingLocation = false;
  double? _latitude;
  double? _longitude;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Initialize the video background
    _controller = VideoPlayerController.asset('assets/6133772-uhd_4096_2160_25fps.mp4');
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.setLooping(true);
      _controller.play();
    });

    _getLocation(); // Fetch the current location when the screen initializes
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Fetch the current location
  Future<void> _getLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }

    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }

    if (_permissionGranted == PermissionStatus.granted) {
      final locationData = await location.getLocation();
      setState(() {
        _latitude = locationData.latitude;
        _longitude = locationData.longitude;
      });

      // Fetch nearby places
      _fetchNearbyPlaces(_latitude!, _longitude!);
    }

    setState(() {
      _isGettingLocation = false;
    });
  }

  // Fetch nearby places using Nominatim API (OpenStreetMap)
  Future<void> _fetchNearbyPlaces(double latitude, double longitude) async {
    List<String> placeTypes = ['hospital', 'embassy', 'police', 'fire_station'];
    List<Map<String, dynamic>> places = [];

    for (String type in placeTypes) {
      final String apiUrl = 'https://nominatim.openstreetmap.org/search';
      final queryUrl =
          '$apiUrl?q=$type&format=json&addressdetails=1&limit=1&lat=$latitude&lon=$longitude';

      try {
        final response = await http.get(Uri.parse(queryUrl));

        if (response.statusCode == 200) {
          final List<dynamic> results = json.decode(response.body);

          if (results.isNotEmpty) {
            places.add({
              'name': results[0]['display_name'] ?? 'Unknown',
              'lat': double.tryParse(results[0]['lat'] ?? '0') ?? 0.0,
              'lon': double.tryParse(results[0]['lon'] ?? '0') ?? 0.0,
              'type': type,
            });
          }
        }
      } catch (e) {
        print('Error fetching $type: $e');
      }
    }

    if (places.isNotEmpty) {
      setState(() {
        _guides = places;
      });
    }
  }

  // Send an emergency SMS with location and nearby places
  Future<void> _sendEmergencySMS(BuildContext context) async {
    try {
      setState(() {
        _isGettingLocation = true;
      });

      final locationData = await location.getLocation();
      final latitude = locationData.latitude;
      final longitude = locationData.longitude;
      final googleMapsLink = 'https://maps.google.com/?q=$latitude,$longitude';

      // Create SMS message with nearby places
      String placesMessage = "Nearby places:\n";
      for (var place in _guides) {
        placesMessage +=
        "${place['name'] ?? 'Unknown'} (${_calculateDistance(place['lat'] ?? 0.0, place['lon'] ?? 0.0).toStringAsFixed(2)} km away)\n";
      }

      final smsMessage =
          "Emergency! My location: $googleMapsLink\n$placesMessage";

      if (emergencyContactNumber != null && emergencyContactNumber!.isNotEmpty) {
        await Provider.of<EmergencyProvider>(context, listen: false)
            .sendEmergencySMS(emergencyContactNumber!, smsMessage);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Emergency SMS sent with location!'),
          backgroundColor: Colors.green,
        ));
      } else {
        throw Exception('Emergency contact number is not set.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to send SMS: ${e.toString()}'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  // Calculate distance between two coordinates
  double _calculateDistance(double lat2, double lon2) {
    const double earthRadius = 6371; // Earth radius in km
    final lat1 = _latitude!;
    final lon1 = _longitude!;

    final double latDiff = _degreesToRadians(lat2 - lat1);
    final double lonDiff = _degreesToRadians(lon2 - lon1);

    final a = (sin(latDiff / 2) * sin(latDiff / 2)) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            (sin(lonDiff / 2) * sin(lonDiff / 2));

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // Distance in km
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Emergency Assistance',
          style: TextStyle(color: Colors.white.withOpacity(0.9)),
        ),
        backgroundColor: Colors.black.withOpacity(0.3), // Transparent header
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.contacts),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactsScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture, // Wait for video to initialize
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.3),
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 100), // Adjusted height
                    ElevatedButton.icon(
                      onPressed: _isGettingLocation
                          ? null
                          : () => _sendEmergencySMS(context),
                      icon: Icon(Icons.phone_in_talk, size: 30),
                      label: Text(
                        'Send Emergency SMS',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: _guides.isEmpty
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: _guides.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.lightGreen.withOpacity(0.8),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(15),
                              leading: Icon(
                                Icons.location_pin,
                                size: 40,
                                color: Colors.white,
                              ),
                              title: Text(
                                _guides[index]['name'] ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                '${_calculateDistance(_guides[index]['lat'] ?? 0.0, _guides[index]['lon'] ?? 0.0).toStringAsFixed(2)} km away',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70),
                              ),
                              trailing: Icon(Icons.map, color: Colors.white),
                              onTap: () {
                                String mapsLink =
                                    'https://maps.google.com/?q=${_guides[index]['lat'] ?? 0.0},${_guides[index]['lon'] ?? 0.0}';
                                _openMapLink(mapsLink);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // Method to open Google Maps with the link
  Future<void> _openMapLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not open the map.';
    }
  }
}
