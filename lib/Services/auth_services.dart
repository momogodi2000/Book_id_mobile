import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Authservices with ChangeNotifier {
  // Base URL of the Django backend
  final String baseUrl = 'http://192.168.1.173:8000/api';

  // Token and phone for authenticated sessions
  String? _token;
  String? _phone;
  String? _name;
  String? _profilePicture;
  String? _email;
  int? _userId;



  String? get token => _token;
  String? get phone => _phone;
  String? get name => _name;
  String? get profilePicture => _profilePicture;
  String? get email => _email;



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
        _token = responseData['token'];
        String userRole = responseData['data']['role'];
        _redirectBasedOnRole(userRole, context);
        notifyListeners();
      } else if (response.statusCode == 400) {
        // Show specific error messages
        final responseData = json.decode(response.body);
        throw Exception(responseData['message'] ?? 'Invalid credentials');
      } else {
        throw Exception('Failed to sign in');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
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




  Future<http.Response> uploadID({
    required String username,
    required String phone,
    required String email,
    required String dateFound,
    required String imagePath,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/missing-cards/'), // Update with your actual endpoint
    );

    request.fields['name'] = username;
    request.fields['phone'] = phone;
    request.fields['email'] = email;
    request.fields['date_found'] = dateFound;

    request.files.add(
      await http.MultipartFile.fromPath(
        'id_card_image',
        imagePath,
      ),
    );

    final response = await request.send();
    return await http.Response.fromStream(response);
  }



// Method to send a contact us message
  Future<void> contactUs(String name, String email, String message) async {
    final url = Uri.parse('$baseUrl/contact-us/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name, // Include the name in the request
          'email': email,
          'message': message,
        }),
      );
      if (response.statusCode == 201) {
        // Successfully sent message
        notifyListeners();
      } else {
        throw Exception('Failed to send message');
      }
    } catch (error) {
      throw error;
    }
  }


  Future<List<dynamic>> fetchMissingIDCards() async {
    final url = Uri.parse('$baseUrl/missing-cards/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to load missing IDs');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<dynamic>> fetchCommunications() async {
    final url = Uri.parse('$baseUrl/communications/'); // Adjust endpoint as needed
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']; // Adjust based on your API response
      } else {
        throw Exception('Failed to load communications');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchUserDetails() async {
    final url = Uri.parse('$baseUrl/user/');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _userId = data['data']['id']; // Set the user ID here
        _name = data['data']['name'] ?? 'Unknown User';
        _profilePicture = data['data']['profile_picture'] ?? 'https://example.com/default_avatar.png';
        notifyListeners();
      } else {
        switch (response.statusCode) {
          case 401:
            throw Exception('Unauthorized access. Please log in again.');
          case 404:
            throw Exception('User not found.');
          default:
            throw Exception('Failed to load user details. Status code: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error fetching user details: $error');
      throw Exception('Failed to fetch user details: $error');
    }
  }



  int get userId {
    if (_userId != null) {
      return _userId!;
    } else {
      throw Exception('User ID is not available.');
    }
  }

  void setUserId(int id) {
    _userId = id;
  }

  Future<void> updateProfile(int userId, String name, String email, String password, String profilePicture) async {
    final url = Uri.parse('$baseUrl/api/user/$userId/'); // Ensure correct URL
    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $_token', // Ensure token is included
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password, // Handle password securely
          'profile_picture': profilePicture, // Image handling should be managed separately
        }),
      );

      if (response.statusCode == 200) {
        _name = name;
        _email = email;
        _profilePicture = profilePicture; // Update local state
        notifyListeners();
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (error) {
      throw error;
    }
  }


  // New method to send a support message
  Future<String> sendSupportMessage(String message) async {
    if (_token == null) {
      throw Exception('User is not authenticated');
    }

    final url = Uri.parse('$baseUrl/support/');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      } else {
        throw Exception('Failed to send message: ${response.body}');
      }
    } catch (error) {
      throw error;
    }
  }
}




