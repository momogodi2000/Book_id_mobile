import 'dart:io';
import 'package:path/path.dart'; // Import this
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/police_models/User_models.dart';
import '../models/police_models/appointment.dart';
import '../models/police_models/missing_id_card.dart';


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




  Future<void> signup(
      String username,
      String email,
      String password,
      String phone,
      File? profilePicture,
      ) async {
    final url = Uri.parse('$baseUrl/register/');
    try {
      var request = http.MultipartRequest('POST', url)
        ..fields['username'] = username
        ..fields['email'] = email
        ..fields['password'] = password
        ..fields['phone'] = phone;

      if (profilePicture != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_picture',
            profilePicture.path,
          ),
        );
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        print('Signup successful: $responseData');
      } else {
        print('Error response: $responseData');
        throw Exception('Failed to create account: ${json.decode(responseData)['errors'] ?? 'Unknown error'}');
      }
    } catch (error) {
      print('Error signing up: $error');
      throw Exception('Error signing up: $error');
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
        await saveUserId(responseData['data']['id']);
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


  Future<void> uploadID({
    required String username,
    required String phone,
    required String email,
    required DateTime dateFound, // Accept DateTime
    required String imagePath,
  }) async {
    final url = Uri.parse('$baseUrl/missing-cards/');

    try {
      // Format the date to YYYY-MM-DD
      String formattedDate = DateFormat('yyyy-MM-dd').format(dateFound);

      // Create a multipart request for the POST operation
      final request = http.MultipartRequest('POST', url)
        ..fields['name'] = username
        ..fields['phone'] = phone
        ..fields['email'] = email
        ..fields['date_found'] = formattedDate; // Use the formatted date

      // Add the image file to the request
      request.files.add(await http.MultipartFile.fromPath('id_card_image', imagePath));

      // Send the request
      final streamedResponse = await request.send();

      // Get the response from the stream
      final response = await http.Response.fromStream(streamedResponse);

      // Check for success (status code 201)
      if (response.statusCode == 201) {
        // Successful upload
        return; // No need to throw an exception for success
      } else {
        // Handle failure (status codes other than 201)
        throw Exception('Failed to upload ID: ${response.body}');
      }
    } catch (error) {
      // Handle any errors that occurred during the upload process
      throw Exception('Error during upload: $error');
    }
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


  // Method to delete an ID card
  Future<void> deleteIDCard(String id) async {
    final url = Uri.parse('$baseUrl/missing-cards/$id/'); // Endpoint for deleting the ID card

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Add any authentication headers if required, e.g., 'Authorization': 'Bearer your_token',
        },
      );

      if (response.statusCode == 204) {
        // Successfully deleted the ID card
        print('ID card deleted successfully');
      } else if (response.statusCode == 404) {
        // ID card not found
        print('ID card not found');
      } else {
        // Handle other status codes
        print('Failed to delete ID card: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting ID card: $error');
      throw error; // Re-throw the error to handle it in the UI if needed
    }
  }




  Future<List<dynamic>> fetchCommunications() async {
    final url = Uri.parse('$baseUrl/communications/'); // Adjust endpoint as needed
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.body);
        final data = json.decode(response.body);
        return data['data']; // Adjust based on your API response
      } else {
        throw Exception('Failed to load communications');
      }
    } catch (error) {
      throw error;
    }
  }

  // Add new communication
  Future<void> addCommunication(String title, String filePath) async {
    final url = Uri.parse('$baseUrl/communications/');
    var request = http.MultipartRequest('POST', url);
    try {
      request.fields['title'] = title;
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      final response = await request.send();
      if (response.statusCode == 201) {
        print("Communication added successfully");
      } else {
        throw Exception('Failed to add communication');
      }
    } catch (error) {
      throw error;
    }
  }

// Edit communication
  Future<void> editCommunication(int id, String title, String filePath) async {
    final url = Uri.parse('$baseUrl/communications/$id/');
    var request = http.MultipartRequest('PUT', url);
    try {
      request.fields['title'] = title;
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      final response = await request.send();
      if (response.statusCode == 201) {
        print("Communication edited successfully");
      } else {
        throw Exception('Failed to edit communication');
      }
    } catch (error) {
      throw error;
    }
  }

// Delete communication
  Future<void> deleteCommunication(int id) async {
    final url = Uri.parse('$baseUrl/communications/$id/');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        print("Communication deleted successfully");
      } else {
        throw Exception('Failed to delete communication');
      }
    } catch (error) {
      throw error;
    }
  }
















  Future<void> fetchUserDetails() async {
    final userId = await getCurrentUserId(); // Get current user ID
    final url = Uri.parse('$baseUrl/user/$userId/'); // Updated endpoint to include user ID

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _userId = data['id']; // Extract user ID from response
        _name = data['name'] ?? 'Unknown User';
        _profilePicture = data['profile_picture'] ?? 'https://assets/imsge/yvan.jpg';
        notifyListeners(); // Notify listeners of the change
      } else {
        _handleHttpError(response.statusCode);
      }
    } catch (error) {
      print('Error fetching user details: $error');
      throw Exception('Failed to fetch user details: $error');
    }
  }


  void _handleHttpError(int statusCode) {
    switch (statusCode) {
      case 401:
        throw Exception('Unauthorized access. Please log in again.');
      case 404:
        throw Exception('User not found.');
      default:
        throw Exception('Failed to load user details. Status code: $statusCode');
    }
  }




  Future<void> updateProfile(String name, String email, String password, String profilePicture) async {
    final userId = await getCurrentUserId(); // Get current user ID
    final url = Uri.parse('$baseUrl/user/$userId/'); // Ensure correct URL

    try {
      var request = http.MultipartRequest('PUT', url)
        ..headers.addAll({
          'Authorization': 'Bearer $_token', // Ensure token is included
        })
        ..fields['name'] = name
        ..fields['email'] = email;

      if (password.isNotEmpty) {
        request.fields['password'] = password; // Handle password securely
      }

      // Check if profilePicture is provided and add it to the request
      if (profilePicture.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          profilePicture,
        ));
      }

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        // Process the response
        final responseData = await http.Response.fromStream(response);
        final data = json.decode(responseData.body);

        _name = data['name'];
        _email = data['email'];
        _profilePicture = data['profile_picture']; // Update local state
        notifyListeners();
      } else {
        throw Exception('Failed to update profile: ${response.reasonPhrase}');
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

// near by police
  Future<List<dynamic>> fetchPoliceStations(double lat, double lng) async {
    final url = Uri.parse('$baseUrl/nearby-police-stations/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'latitude': lat, 'longitude': lng}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody.containsKey('police_stations')) {
          return responseBody['police_stations'];
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load police stations: ${response.statusCode}');
      }
    } catch (error) {
      // Handle or log the error
      throw Exception('Failed to fetch police stations: $error');
    }
  }




  Future<void> uploadDocuments(Map<String, File?> documents) async {
    final uri = Uri.parse('$baseUrl/documents/');
    final request = http.MultipartRequest('POST', uri);
    final userId = (await getCurrentUserId()).toString();

    request.fields['user'] = userId;

    for (var entry in documents.entries) {
      if (entry.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            entry.key,
            entry.value!.path,
            filename: basename(entry.value!.path), // Use basename here
          ),
        );
      }
    }

    final response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to upload documents');
    }
  }



  // Method to save user ID (this should be called after login)
  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  // Method to get user ID
  Future<int> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      return userId;
    } else {
      throw Exception('User ID not found');
    }
  }




// book appointment
  Future<void> bookAppointment({
    required DateTime date,
    required String time,
    required int userId,
    required String office, // Add the 'office' field
  }) async {
    final url = Uri.parse('$baseUrl/appointments/get-add/');

    // Format the date to YYYY-MM-DD
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $_token', // Uncomment if using token
        },
        body: json.encode({
          'date': formattedDate, // Correctly formatted date
          'time': time,          // Correct time format
          'user': userId,        // User ID
          'office': office,      // Add the 'office' field
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to book appointment: ${response.body}');
      }
    } catch (error) {
      throw error;
    }
  }


// Make payment for user
  Future<Map<String, dynamic>> submitPayment(String phone) async {
    // Validate the phone number format here if necessary
    final url = Uri.parse('$baseUrl/payments/');
    final userId = (await getCurrentUserId()).toString();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': phone,  // Ensure valid phone number format
          'user': {'id': userId},
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorResponse = response.body.isNotEmpty
            ? json.decode(response.body)
            : {'message': 'Unknown error occurred'};
        throw Exception('Payment failed: ${errorResponse['message']}');
      }
    } catch (error) {
      throw Exception('An error occurred during payment: $error');
    }
  }


  // police panel

  Future<List<dynamic>> fetchContactUsMessages() async {
    final url = Uri.parse('$baseUrl/contact-us/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['data']; // Assuming the data is in the 'data' field
      } else {
        throw Exception('Failed to load contact us messages');
      }
    } catch (error) {
      print('Error fetching contact us messages: $error');
      throw error;
    }
  }


  Future<void> deleteContactUsMessage(int id) async {
    final url = Uri.parse('$baseUrl/contact-us/$id/delete/');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 204) {
        notifyListeners();
      } else {
        throw Exception('Failed to delete contact us message');
      }
    } catch (error) {
      print('Error deleting contact us message: $error');
      throw error;
    }
  }


  Future<void> replyToContactUsMessage(int id, String replyMessage) async {
    final url = Uri.parse('$baseUrl/contact-us/$id/reply/');
    try {
      final response = await http.post(
        url,
        body: {
          'reply_message': replyMessage,
        },
      );

      if (response.statusCode == 200) {
        // Handle success, e.g., notifyListeners() if necessary
        print('Reply sent successfully!');
      } else if (response.statusCode == 400) {
        // Handle bad request, such as empty reply message
        print('Failed to send reply: ${response.body}');
        throw Exception('Failed to send reply: Bad request');
      } else if (response.statusCode == 404) {
        // Handle case where the contact us message was not found
        print('Failed to send reply: Message not found');
        throw Exception('Failed to send reply: Message not found');
      } else {
        // Handle other unexpected status codes
        print('Failed to send reply: Unexpected error');
        throw Exception('Failed to send reply: Unexpected error');
      }
    } catch (error) {
      print('Error sending reply: $error');
      throw error;
    }
  }


  Future<List<User>> fetchUsers() async {
    final url = Uri.parse('$baseUrl/user/get-add/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        final List<User> users = data.map((json) => User.fromJson(json)).toList();
        return users; // Returning the list of users
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (error) {
      print('Error fetching users: $error');
      throw error;
    }
  }


    Future<List<Appointment>> fetchAppointments() async {
    final response = await http.get(Uri.parse('$baseUrl/get-add/'));
    if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body)['data'];
    return body.map((json) => Appointment.fromJson(json)).toList();
    } else {
    throw Exception('Failed to load appointments');
    }
    }

    Future<bool> takeAction(int appointmentId, String action, String message) async {
    final url = Uri.parse('$baseUrl/edit-delete/$appointmentId/');
    final response = await http.put(
    url,
    body: jsonEncode({"response": action, "message": message}),
    headers: {"Content-Type": "application/json"},
    );
    return response.statusCode == 200;
    }




}




