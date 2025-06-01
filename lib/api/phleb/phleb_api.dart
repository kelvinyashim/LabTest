import 'dart:convert';

import 'package:http/http.dart' as http;

class PhlebApi {
  final String baseUrl = 'https://labconnect-e569.onrender.com/api/phlebs';

  Future<void> loginPhleb(String email, String psw) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({ 'contactInfo': {'email': email}, 'password': psw}),
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
      } else {
        print('Error');
      }
    } on http.ClientException {
      throw Exception("Network error. Please check your internet connection.");
    } on FormatException {
      throw Exception("Unexpected response format. Please try again later.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
