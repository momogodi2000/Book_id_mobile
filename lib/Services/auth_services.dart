import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Authservices with ChangeNotifier {
  // Base URL of the Django backend
  final String baseUrl = 'http://192.168.1.173:8000/api';

  // Token and phone for authenticated sessions
  String? _token;
  String? _phone;

  // Getters for token and phone
  String? get token => _token;
  String? get phone => _phone;

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
        notifyListeners();
      } else {
        throw Exception('Failed to sign up');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signin(String email, String password, BuildContext context) async {
    final url = Uri.parse('$baseUrl/login/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _token = responseData['token']; // Handle token
        String userRole = responseData['data']['role']; // Extract user role

        // Redirect based on user role
        _redirectBasedOnRole(userRole, context);

        notifyListeners();
      } else {
        throw Exception('Failed to sign in');
      }
    } catch (error) {
      throw error;
    }
  }

  void _redirectBasedOnRole(String role, BuildContext context) {
    switch (role) {
      case 'admin':
        Navigator.pushReplacementNamed(context, '/admin_panel');
        break;
      case 'officer':
        Navigator.pushReplacementNamed(context, '/police_panel');
        break;
      default:
        Navigator.pushReplacementNamed(context, '/clients_panel');
        break;
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
        notifyListeners();
      } else {
        throw Exception('Failed to request password reset');
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
        notifyListeners();
      } else {
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
        _phone = phone;
        notifyListeners();
      } else {
        throw Exception('Failed to link phone number');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> verifyOTP(String otp) async {
    final url = Uri.parse('$baseUrl/verify-otp/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'otp': otp}),
      );
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (error) {
      throw error;
    }
  }

  void logout() {
    _token = null;
    _phone = null;
    notifyListeners();
  }
}