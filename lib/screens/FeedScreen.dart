import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
        backgroundColor: Color(0xFF4077FF),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search posts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<PostsProvider>(context, listen: false)
                  .fetchPosts(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: LoadingIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Failed to load posts. Please try again later.'));
                } else {
                  return Consumer<PostsProvider>(
                    builder: (ctx, postsProvider, _) {
                      final posts = postsProvider.posts ?? [];
                      final filteredPosts = posts.where((post) {
                        return post.title!
                            .toLowerCase()
                            .contains(searchQuery) ||
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NewPostScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF4077FF),
      ),
    );
  }
}
