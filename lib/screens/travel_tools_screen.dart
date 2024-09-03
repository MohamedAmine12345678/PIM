import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TravelToolsScreen extends StatefulWidget {
  @override
  _TravelToolsScreenState createState() => _TravelToolsScreenState();
}

class _TravelToolsScreenState extends State<TravelToolsScreen> {
  String _weather = 'Loading weather...';
  double _convertedAmount = 0.0;
  String _translatedText = '';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final apiKey = '58910992da474c1ba4c144707242108';
    final city = 'London';  // Example city, you can modify this
    final url = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city';

    try {
      final response = await http.get(Uri.parse(url));
      final weatherData = json.decode(response.body);
      setState(() {
        _weather = '${weatherData['current']['temp_c']}°C, ${weatherData['current']['condition']['text']}';
      });
    } catch (error) {
      setState(() {
        _weather = 'Failed to load weather';
      });
    }
  }

  Future<void> _convertCurrency(double amount, String from, String to) async {
    final apiKey = 'f19694d21959874a32c68965';
    final url = 'https://v6.exchangerate-api.com/v6/$apiKey/pair/$from/$to/$amount';

    try {
      final response = await http.get(Uri.parse(url));
      final conversionData = json.decode(response.body);
      setState(() {
        _convertedAmount = conversionData['conversion_result'];
      });
    } catch (error) {
      setState(() {
        _convertedAmount = 0.0;
      });
    }
  }

  Future<void> _translateText(String text, String targetLanguage) async {
    final url = 'https://libretranslate.com/translate';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'q': text,
          'source': 'en',
          'target': targetLanguage,
          'format': 'text'
        }),
      );

      final translationData = json.decode(response.body);
      setState(() {
        _translatedText = translationData['translatedText'];
      });
    } catch (error) {
      setState(() {
        _translatedText = 'Failed to translate';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Tools'),
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
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              _buildToolCard(
                context,
                icon: Icons.wb_sunny,
                title: 'Weather Information',
                description: _weather,
                onTap: () => _fetchWeather(),
              ),
              SizedBox(height: 20),
              _buildToolCard(
                context,
                icon: Icons.monetization_on,
                title: 'Currency Conversion',
                description: '$_convertedAmount', // Display converted amount
                onTap: () => _convertCurrency(100, 'USD', 'EUR'), // Example conversion
              ),
              SizedBox(height: 20),
              _buildToolCard(
                context,
                icon: Icons.translate,
                title: 'Instant Translation',
                description: _translatedText.isEmpty ? 'Translate a phrase' : _translatedText,
                onTap: () => _translateText('Hello', 'es'), // Example translation
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, {required IconData icon, required String title, required String description, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.teal.withOpacity(0.8),
        child: ListTile(
          contentPadding: EdgeInsets.all(15),
          leading: Icon(
            icon,
            size: 40,
            color: Colors.white,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              description,
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
  }
}
