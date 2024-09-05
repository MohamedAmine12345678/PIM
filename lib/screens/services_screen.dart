import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Initialize the video player (same as HomeScreen)
    _controller = VideoPlayerController.asset('assets/3678380-hd_1920_1080_30fps.mp4');
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
      extendBodyBehindAppBar: true, // Ensures the app bar is transparent
      appBar: AppBar(
        title: Text(
          'Useful Integrated Services',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white.withOpacity(0.9), // Header text color
          ),
        ),
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow
      ),
      body: Stack(
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
          // Center the services in the middle of the screen
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
                children: _services.map((service) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(service['route']);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Same rounded corners as HomeScreen
                      ),
                      elevation: 10,
                      color: Colors.black.withOpacity(0.3), // Same transparency for consistency
                      child: ListTile(
                        contentPadding: EdgeInsets.all(15),
                        leading: Icon(
                          service['icon'],
                          size: 40,
                          color: Colors.white.withOpacity(0.8), // Consistent icon color
                        ),
                        title: Text(
                          service['title'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.9), // Consistent title text
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            service['description'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70, // Slightly faded subtitle for readability
                            ),
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.8)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
