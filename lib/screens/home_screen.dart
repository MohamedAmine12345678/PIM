import 'package:flutter/material.dart';
import 'package:safetravel/screens/services_screen.dart';
import 'FeedScreen.dart';
import 'alerts_screen.dart';
import 'advice_screen.dart';
import 'emergency_screen.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the video player
    _controller = VideoPlayerController.asset('assets/3678380-hd_1920_1080_30fps.mp4');
    _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
      _controller!.setLooping(true);
      _controller!.play();
    });

    // Initialize the animation controller and animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeIn,
    );

    // Start the animation after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _animationController!.forward();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController?.dispose();
    super.dispose();
  }

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
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller!),
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
          // Animated Welcome Message
          if (_animation != null)
            FadeTransition(
              opacity: _animation!,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                ),
              ),
            ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 150), // Adjust to make space for the welcome text
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
                          color: Colors.black.withOpacity(0.3), // Transparent black background for the card
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _features[index]['icon'],
                                  size: 50,
                                  color: Colors.white.withOpacity(0.8), // Adjusted icon opacity
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _features[index]['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(0.9), // Adjusted text opacity
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
