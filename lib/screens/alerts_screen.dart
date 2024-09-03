// screens/alerts_screen.dart
import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _alerts = [
    {
      'title': 'Earthquake in Japan',
      'description': 'A magnitude 7.0 earthquake has struck Japan.',
      'time': '10 mins ago',
    },
    {
      'title': 'Protests in Paris',
      'description': 'Large-scale protests are taking place in the center of Paris.',
      'time': '30 mins ago',
    },
    {
      'title': 'Hurricane in Florida',
      'description': 'A Category 5 hurricane is approaching the Florida coast.',
      'time': '1 hour ago',
    },
    {
      'title': 'Flooding in Venice',
      'description': 'Severe flooding has been reported in Venice due to heavy rainfall.',
      'time': '2 hours ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Security Alerts'),
        backgroundColor: Color(0xFF162447),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/globe.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.3)],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
          child: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: _alerts.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.redAccent.withOpacity(0.8),
                child: ListTile(
                  contentPadding: EdgeInsets.all(15),
                  title: Text(
                    _alerts[index]['title'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () {
                    // Navigate to detailed alert screen or take action
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
