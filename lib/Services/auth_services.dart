import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Authservices with ChangeNotifier {
  // Base URL of the Django back end
  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<void> signup(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/register/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 201) {
        // Handle successful signup
        notifyListeners();
      } else {
        // Handle error
        throw Exception('Failed to sign up');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signin(String username, String password) async {
    final url = Uri.parse('$baseUrl/login/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        // Handle successful signin
        notifyListeners();
      } else {
        // Handle error
        throw Exception('Failed to sign in');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/forgot-password/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );
      if (response.statusCode == 200) {
        // Handle successful password reset request
        notifyListeners();
      } else {
        // Handle error
        throw Exception('Failed to send password reset email');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    final url = Uri.parse('$baseUrl/reset-password/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'new_password': newPassword,
        }),
      );
      if (response.statusCode == 200) {
        // Handle successful password reset
        notifyListeners();
      } else {
        // Handle error
        throw Exception('Failed to reset password');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> linkPhoneNumber(String phone) async {
    final url = Uri.parse('$baseUrl/link-phone/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone}),
      );
      if (response.statusCode == 200) {
        // Handle successful phone number linking
        notifyListeners();
      } else {
        // Handle error
        throw Exception('Failed to link phone number');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String, dynamic>> verifyOTP(String otp) async {
    final url = Uri.parse('$baseUrl/verify-otp/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'otp': otp}),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body); // Return the decoded response
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (error) {
      throw error;
    }
  }
}
