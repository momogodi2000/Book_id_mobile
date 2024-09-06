import 'dart:io';

import 'package:flutter/material.dart';
import '../Services/auth_services.dart';

class AuthProvider with ChangeNotifier {
  final Authservices _authservices = Authservices();
  String? _token;
  String? _phone;

  String? get token => _token;
  String? get phone => _phone;

  Future<void> signup(
      String username,
      String email,
      String password,
      String phone,
      File? profileImage,
      ) async {
    try {
      await _authservices.signup(username, email, password, phone, profileImage);
      _token = null; // Or set the token if returned from the signup response
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signin(String email, String password, BuildContext context) async {
    try {
      await _authservices.signin(email, password, context);
      _token = _authservices.token;
      notifyListeners();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
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
