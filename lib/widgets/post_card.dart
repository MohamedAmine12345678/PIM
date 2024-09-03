import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/posts_provider.dart';
import '../screens/post_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final Post post;
  final int commentCount;

  PostCard({required this.post, required this.commentCount});

  @override
  Widget build(BuildContext context) {
    final int likeCount = post.likes;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  post.title ?? 'No title available',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF162447),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Post'),
                        content: Text('Are you sure you want to delete this post?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: Text('Delete'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      ),
                    );

                    if (shouldDelete == true) {
                      try {
                        await Provider.of<PostsProvider>(context, listen: false)
                            .deletePost(post.id ?? '');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Post deleted successfully')),
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to delete post')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              timeago.format(post.createdAt ?? DateTime.now()),
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            Text(post.body ?? 'No content available'),
            if (post.image != null && post.image!.isNotEmpty) ...[
              SizedBox(height: 10),
              CachedNetworkImage(
                imageUrl: 'http://localhost:4000/uploads/${post.image}',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ],
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(post: post),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.comment, color: Colors.grey[600]),
                      SizedBox(width: 5),
                      Text('$commentCount comments',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<PostsProvider>(context, listen: false)
                        .toggleLike(post.id ?? '');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.thumb_up, color: Colors.blue),
                      SizedBox(width: 5),
                      Text('$likeCount', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
