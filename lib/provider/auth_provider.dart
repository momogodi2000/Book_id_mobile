
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  // Define your authentication logic here
  Future<void> signup(String name, String email, String password) async {
    // Add signup logic
  }

  Future<void> signin(String username, String password) async {
    // Add signin logic
  }

  Future<void> forgotPassword(String email) async {
    // Add forgot password logic
  }

  Future<void> resetPassword(String email, String newPassword) async {
    // Add reset password logic
  }

  Future<void> linkPhoneNumber(String phone) async {
    // Add phone linking logic
  }

  void verifyOTP(String otp) {}
}
