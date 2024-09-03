// screens/advice_screen.dart
import 'package:flutter/material.dart';

class AdviceScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _advice = [
    {
      'title': 'Health Precautions',
      'description': 'Make sure to carry necessary medications and a first aid kit.',
      'icon': Icons.local_hospital,
    },
    {
      'title': 'Travel Safety',
      'description': 'Avoid traveling alone at night in unfamiliar areas.',
      'icon': Icons.security,
    },
    {
      'title': 'Weather Conditions',
      'description': 'Check the weather forecast and pack accordingly.',
      'icon': Icons.wb_sunny,
    },
    {
      'title': 'Local Laws',
      'description': 'Familiarize yourself with local laws and customs.',
      'icon': Icons.gavel,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI-Personalized Advice'),
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
            itemCount: _advice.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.blueAccent.withOpacity(0.8),
                child: ListTile(
                  contentPadding: EdgeInsets.all(15),
                  leading: Icon(
                    _advice[index]['icon'],
                    size: 40,
                    color: Colors.white,
                  ),
                  title: Text(
                    _advice[index]['title'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      _advice[index]['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
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
