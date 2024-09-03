import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/post.dart';
import '../services/ApiService.dart';

class PostsProvider with ChangeNotifier {
  List<Post>? _posts;

  List<Post>? get posts => _posts;

  Future<void> fetchPosts() async {
    final url = 'http://localhost:4000/api/posts';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _posts = data.map((item) => Post.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addPost(String title, String body, File image, String userId) async {
    final url = 'http://localhost:4000/api/posts';
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['title'] = title;
      request.fields['body'] = body;
      request.fields['userId'] = userId;
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      var response = await request.send();

      if (response.statusCode == 201) {
        final res = await http.Response.fromStream(response); // Ensure 'res' is defined
        final newPost = Post.fromJson(json.decode(res.body));
        _posts?.add(newPost);
        notifyListeners();
      } else {
        print('Failed to add post: ${response.reasonPhrase}');
        throw Exception('Failed to add post');
      }
    } catch (error) {
      throw error;
    }
  }


  Future<void> deletePost(String postId) async {
    final url = 'http://localhost:4000/api/posts/$postId';
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        _posts?.removeWhere((post) => post.id == postId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (error) {
      throw error;
    }
  }


  Future<void> likePost(String postId) async {
    final url = 'http://localhost:4000/api/posts/$postId/like';

    try {
      final response = await http.put(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to like post');
      }

      // Update local post data if needed
      fetchPosts();
    } catch (error) {
      throw error;
    }
  }

  void toggleLike(String postId) async {
    try {
      if (_posts == null) {
        print('Posts list is null');
        return;
      }

      final postIndex = _posts!.indexWhere((post) => post.id == postId);
      if (postIndex == -1) return;

      final post = _posts![postIndex];

      if (post.likes == 0) {
        post.addLike();
      } else {
        post.removeLike();
      }

      notifyListeners();

      final url = Uri.parse('http://localhost:4000/api/posts/$postId/like');
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode != 200) {
        throw Exception('Failed to toggle like');
      }
    } catch (error) {
      print('Failed to toggle like: $error');
    }
  }



}
