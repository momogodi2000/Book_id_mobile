import 'package:flutter/material.dart';
import '../Services/auth_services.dart';

class AuthProvider with ChangeNotifier {
  final Authservices _authservices = Authservices();
  String? _token;
  String? _phone;

  String? get token => _token;
  String? get phone => _phone;

  Future<void> signup(String name, String email, String password) async {
    try {
      await _authservices.signup(name, email, password);
      _token = null; // Or set the token if returned from the signup response
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signin(String email, String password) async {
    try {
      await _authservices.signin(email, password);
      _token = _authservices.token;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _authservices.forgotPassword(email);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    try {
      await _authservices.resetPassword(email, newPassword);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> linkPhoneNumber(String phone) async {
    try {
      await _authservices.linkPhoneNumber(phone);
      _phone = phone;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      await _authservices.verifyOTP(otp);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void logout() {
    _authservices.logout();
    _token = null;
    _phone = null;
    notifyListeners();
  }
}
