import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/comment_model.dart';

class CommentsProvider with ChangeNotifier {
  List<Comment> _comments = [];

  List<Comment> get comments => _comments;

  Future<void> fetchCommentsByPost(String postId) async {
    final url = Uri.parse('http://localhost:4000/api/comments/post/$postId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _comments = data.map((comment) => Comment.fromJson(comment)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (error) {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> addComment(String postId, String userId, String text) async {
    final url = Uri.parse('http://localhost:4000/api/comments');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'text': text,
          'post': postId,
          'user': userId,
        }),
      );

      print("Request body: ${json.encode({
        'text': text,
        'post': postId,
        'user': userId,
      })}");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 201) {
        final newComment = Comment.fromJson(json.decode(response.body));
        _comments.add(newComment);
        notifyListeners();
      } else {
        throw Exception('Failed to add comment');
      }
    } catch (error) {
      print("Error: $error");
      throw error;
    }
  }


  Future<void> updateComment(String commentId, String newText) async {
    final url = Uri.parse('http://localhost:4000/api/comments/$commentId');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': newText}),
      );

      if (response.statusCode == 200) {
        final updatedComment = Comment.fromJson(json.decode(response.body));
        final commentIndex =
        _comments.indexWhere((comment) => comment.id == commentId);
        if (commentIndex != -1) {
          _comments[commentIndex] = updatedComment;
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update comment');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteComment(String commentId) async {
    final url = Uri.parse('http://localhost:4000/api/comments/$commentId');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        _comments.removeWhere((comment) => comment.id == commentId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete comment');
      }
    } catch (error) {
      throw Exception('Failed to delete comment');
    }
  }
}
