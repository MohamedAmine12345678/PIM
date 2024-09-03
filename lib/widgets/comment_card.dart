import 'package:flutter/material.dart';
import '../models/comment_model.dart'; // Import your Comment model here
import 'package:provider/provider.dart';
import '../providers/comments_provider.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;

  CommentCard({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: ListTile(
        title: Text(comment.text ?? 'No comment text'),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            try {
              await Provider.of<CommentsProvider>(context, listen: false).deleteComment(comment.id ?? '');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Comment deleted')),
              );
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to delete comment')),
              );
            }
          },
        ),
      ),
    );
  }
}
