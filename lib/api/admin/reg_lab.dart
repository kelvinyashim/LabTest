import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_ease/main.dart';
import 'package:test_ease/models/lab/labs.dart';

class AdminLabApi {
  final String baseUrl = 'https://labconnect-e569.onrender.com/api/admin';

  Future<Lab> createLab(Lab lab) async {
    final token = await tokenRole.getToken();
    if (token == null) {
      throw Exception("No token provided");
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add-lab'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
        body: jsonEncode(lab.toJson()),
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = response.headers['x-auth-token'];
        if (token != null) {
          tokenRole.saveTokenRole(token);
        } else {
          throw Exception("Failed to save authentication token.");
        }

        return Lab.fromJson(data);
      } else {
        throw Exception('Failed to create lab');
      }
    } on http.ClientException {
      throw Exception("Network error. Please check your internet connection.");
    } on FormatException {
      throw Exception("Unexpected response format. Please try again later.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Lab>> getAllLabs() async {
    final token = await tokenRole.getToken();
    if (token == null) {
      throw Exception("No token provided");
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/labs'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Lab.fromJson(e)).toList();
      } else {
        throw Exception('Failed to get all labs');
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
