// providers/emergency_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:twilio_flutter/twilio_flutter.dart';

class EmergencyProvider with ChangeNotifier {
  List<Map<String, dynamic>> contacts = [];
  TwilioFlutter twilioFlutter;

  EmergencyProvider()
      : twilioFlutter = TwilioFlutter(
    accountSid: 'AC16f2914f01bc7fffbdde450482b2426c',
    authToken: 'dace0a90622bf64d5d9f92dcb01f0ef4',
    twilioNumber: '+13612385105',
  );

  Future<void> fetchContacts() async {
    final response = await http.get(Uri.parse('http://localhost:4000/api/contacts'));
    if (response.statusCode == 200) {
      contacts = List<Map<String, dynamic>>.from(json.decode(response.body));
      notifyListeners();
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  Future<void> addContact(String name, String phone) async {
    final response = await http.post(
      Uri.parse('http://localhost:4000/api/contacts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'phone': phone}),
    );
    if (response.statusCode == 201) {
      fetchContacts();
    } else {
      throw Exception('Failed to add contact');
    }
  }

  Future<void> deleteContact(String id) async {
    final response = await http.delete(Uri.parse('http://localhost:4000/api/contacts/$id'));
    if (response.statusCode == 200) {
      fetchContacts();
    } else {
      throw Exception('Failed to delete contact');
    }
  }

  Future<void> sendEmergencySMS(String phoneNumber, String googleMapsLink) async {
    await twilioFlutter.sendSMS(
      toNumber: phoneNumber,
      messageBody: 'Help! My current location: $googleMapsLink',
    );
  }
}
