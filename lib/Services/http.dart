import 'package:http/http.dart' as http;
import 'dart:convert';

class Http {
  static const String _baseUrl = 'http://127.0.0.1:8000/api/'; // replace with your API URL

  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse(_baseUrl + endpoint);
    final response = await http.get(url);
    return response;
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse(_baseUrl + endpoint);
    final response = await http.post(url, body: jsonEncode(data), headers: { // Use jsonEncode from dart:convert
      'Content-Type': 'application/json',
    });
    return response;
  }

  static Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse(_baseUrl + endpoint);
    final response = await http.put(url, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
    });
    return response;
  }

  static Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse(_baseUrl + endpoint);
    final response = await http.delete(url);
    return response;
  }
}