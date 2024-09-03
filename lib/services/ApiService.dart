import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://localhost:4000/api';

  static Future<void> toggleLike(String postId) async {
    final url = Uri.parse('$baseUrl/posts/$postId/like');
    final response = await http.put(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle like');
    }
  }
}
