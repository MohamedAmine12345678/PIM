import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdviceProvider with ChangeNotifier {
  String _advice = '';

  String get advice => _advice;

  Future<void> fetchAdvice(String location) async {
    final url = Uri.parse('http://localhost:4000/api/adivce/$location');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Assuming the API returns the advice as plain text
        final extractedData = json.decode(response.body);
        if (extractedData is String) {
          _advice = extractedData;
        } else {
          _advice = extractedData.toString();  // Ensure it's a string
        }
      } else {
        throw Exception('Failed to load advice');
      }
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to load advice');
    }
  }
}
