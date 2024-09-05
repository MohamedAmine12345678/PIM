import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../providers/posts_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/loading_indicator.dart';
import 'new_post_screen.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String searchQuery = '';
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Initialize the video controller
    _controller = VideoPlayerController.asset('assets/9669392-hd_1080_1920_30fps.mp4');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Feed',
          style: TextStyle(color: Colors.white.withOpacity(0.9)),
        ),
        backgroundColor: Colors.black.withOpacity(0.3),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Video background
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
          // Gradient overlay for better readability
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
              SizedBox(height: 120), // Adjusted the search bar lower for better accessibility
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search posts...',
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.4), // Semi-transparent search bar
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: Provider.of<PostsProvider>(context, listen: false).fetchPosts(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: LoadingIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                            'Failed to load posts. Please try again later.',
                            style: TextStyle(color: Colors.white),
                          ));
                    } else {
                      return Consumer<PostsProvider>(
                        builder: (ctx, postsProvider, _) {
                          final posts = postsProvider.posts ?? [];
                          final filteredPosts = posts.where((post) {
                            return post.title!.toLowerCase().contains(searchQuery) ||
                                post.body!.toLowerCase().contains(searchQuery);
                          }).toList();

                          return ListView.builder(
                            itemCount: filteredPosts.length,
                            itemBuilder: (ctx, index) {
                              final post = filteredPosts[index];

                              // Fetch comments count for each post
                              final int commentCount = post.comments?.length ?? 0;

                              return PostCard(post: post, commentCount: commentCount);
                            },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NewPostScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
    );
  }
}
