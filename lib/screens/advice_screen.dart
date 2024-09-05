import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:safetravel/providers/advice_provider.dart';

class AdviceScreen extends StatefulWidget {
  @override
  _AdviceScreenState createState() => _AdviceScreenState();
}

class _AdviceScreenState extends State<AdviceScreen> {
  final _locationController = TextEditingController();
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Initialize the video controller
    _controller = VideoPlayerController.asset('assets/8979495-hd_1080_1920_30fps.mp4');
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.setLooping(true);
      _controller.play();
    });
  }

  void _fetchAdvice() {
    final location = _locationController.text.trim();
    if (location.isNotEmpty) {
      Provider.of<AdviceProvider>(context, listen: false).fetchAdvice(location);
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adviceProvider = Provider.of<AdviceProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'AI-Personalized Advice',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.3), // Transparent header
        elevation: 0,
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
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.3)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Column(
            children: [
              // Padding adjusted for the text field
              SizedBox(height: 120), // Adjust this value to position the text field lower
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _locationController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Where to go?',
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: _fetchAdvice,
                    ),
                  ),
                  onSubmitted: (_) => _fetchAdvice(),
                ),
              ),
              Expanded(
                child: Consumer<AdviceProvider>(
                  builder: (ctx, adviceProvider, _) {
                    if (adviceProvider.advice.isEmpty) {
                      return Center(
                        child: Text(
                          'No advice available.',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: Colors.black.withOpacity(0.5),
                            shadowColor: Colors.black54,
                            elevation: 10,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(20),
                              leading: Icon(
                                Icons.lightbulb_outline,
                                size: 40,
                                color: Colors.yellowAccent,
                              ),
                              title: Text(
                                'Advice',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  adviceProvider.advice,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
