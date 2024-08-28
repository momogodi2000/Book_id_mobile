import 'package:flutter/material.dart';
import '../Services/auth_services.dart';

class AuthProvider with ChangeNotifier {
  final Authservices _authservices = Authservices();
  String? _token;
  String? _phone;

  String? get token => _token;
  String? get phone => _phone;

  Future<void> signin(String username, String password) async {
    try {
      // Perform sign in using Authservices
      await _authservices.signin(username, password);
      _token = 'mocked_token'; // Replace with actual token from the response
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      // Perform sign up using Authservices
      await _authservices.signup(name, email, password);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      // Perform forgot password request using Authservices
      await _authservices.forgotPassword(email);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    try {
      // Perform reset password using Authservices
      await _authservices.resetPassword(email, newPassword);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> linkPhoneNumber(String phone) async {
    try {
      // Link phone number using Authservices
      await _authservices.linkPhoneNumber(phone);
      _phone = phone;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      // Perform OTP verification using Authservices
      await _authservices.verifyOTP(otp);
      notifyListeners();
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
