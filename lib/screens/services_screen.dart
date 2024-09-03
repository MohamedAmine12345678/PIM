// screens/services_screen.dart
import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _services = [
    {
      'title': 'Weather Information',
      'description': 'Check real-time weather updates for your destination.',
      'icon': Icons.wb_sunny,
      'route': '/weather', // Placeholder route for navigation
    },
    {
      'title': 'Currency Conversion',
      'description': 'Convert currencies with the latest exchange rates.',
      'icon': Icons.monetization_on,
      'route': '/currency', // Placeholder route for navigation
    },
    {
      'title': 'Instant Translation',
      'description': 'Translate phrases into the local language instantly.',
      'icon': Icons.translate,
      'route': '/translate', // Placeholder route for navigation
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Useful Integrated Services'),
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
            itemCount: _services.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(_services[index]['route']);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.teal.withOpacity(0.8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    leading: Icon(
                      _services[index]['icon'],
                      size: 40,
                      color: Colors.white,
                    ),
                    title: Text(
                      _services[index]['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        _services[index]['description'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
