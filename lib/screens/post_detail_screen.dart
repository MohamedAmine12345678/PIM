import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/comment_model.dart';
import '../providers/comments_provider.dart';
import '../models/post.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  PostDetailScreen({required this.post});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  String? _editingCommentId;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      await Provider.of<CommentsProvider>(context, listen: false)
          .fetchCommentsByPost(widget.post.id!);

      // Update the post with the fetched comments
      setState(() {
        widget.post.comments = Provider.of<CommentsProvider>(context, listen: false).comments;
      });
    } catch (error) {
      print('Error loading comments: $error');
    }
  }


  Future<void> _addOrUpdateComment() async {
    try {
      final userId = '66ce2f1de2b1f49edd5bf519'; // Using provided user ID

      if (_editingCommentId == null) {
        await Provider.of<CommentsProvider>(context, listen: false).addComment(
          widget.post.id!,
          userId,
          _commentController.text,
        );
      } else {
        await Provider.of<CommentsProvider>(context, listen: false)
            .updateComment(_editingCommentId!, _commentController.text);
      }

      _commentController.clear();
      _editingCommentId = null;
    } catch (error) {
      print('Error adding/updating comment: $error');
    }
  }

  void _editComment(Comment comment) {
    _commentController.text = comment.text;
    setState(() {
      _editingCommentId = comment.id;
    });
  }

  void _deleteComment(String commentId) async {
    try {
      await Provider.of<CommentsProvider>(context, listen: false)
          .deleteComment(commentId);
    } catch (error) {
      print('Error deleting comment: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<CommentsProvider>(context).comments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title!),
        backgroundColor: Color(0xFF162447),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (ctx, i) {
                final comment = comments[i];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      comment.text,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      comment.username ?? 'Unknown user',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () {
                            _editComment(comment);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            _deleteComment(comment.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF4077FF),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _addOrUpdateComment,
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
