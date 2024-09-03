// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:safetravel/screens/services_screen.dart';
import 'FeedScreen.dart';
import 'alerts_screen.dart';
import 'advice_screen.dart';
import 'emergency_screen.dart';


class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _features = [
    {'title': 'Security Alerts', 'icon': Icons.warning, 'screen': AlertsScreen()},
    {'title': 'AI Advice', 'icon': Icons.lightbulb, 'screen': AdviceScreen()},
    {'title': 'Emergency', 'icon': Icons.phone_in_talk, 'screen': EmergencyScreen()},
    {'title': 'Community', 'icon': Icons.forum, 'screen': FeedScreen()},
    {'title': 'Services', 'icon': Icons.miscellaneous_services, 'screen': ServicesScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/globe.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.3)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Safe Travel',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                Expanded(
                  child: GridView.builder(
                    itemCount: _features.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => _features[index]['screen']),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 10,
                          color: Colors.blueAccent.withOpacity(0.8),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _features[index]['icon'],
                                  size: 50,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _features[index]['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
