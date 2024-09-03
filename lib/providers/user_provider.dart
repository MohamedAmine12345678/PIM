// providers/users_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';


class UsersProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchUsers() async {
    final url = Uri.parse('http://localhost:4000/api/users');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> usersJson = json.decode(response.body);
        _users = usersJson.map((json) => User.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      throw error;
    }
  }
}
