import 'dart:convert';

import 'package:test_ease/main.dart';
import 'package:test_ease/models/labs.dart';
import 'package:http/http.dart' as http;

class LabApi {
  final String baseUrl = 'https://labconnect-e569.onrender.com/api/labs/';

  Future<Lab> loginLab(String email, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/auth'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}));

    try {
      if (response.statusCode == 200) {
        return Lab.fromJson(jsonDecode(response.body));
      } else {
        return throw Exception("Failed to login");
      }
    } on http.ClientException {
      return throw Exception(
          "Network error. Please check your internet connection.");
    } on FormatException {
      return throw Exception(
          "Unexpected response format. Please try again later.'");
    } catch (e) {
      return throw Exception(e.toString());
    }
  }

  Future<Lab> getCurrentLab() async {
    final token = await tokenRole.getToken();

    if (token == null) {
      throw Exception("No token provided");
    }

    final response = await http.get(Uri.parse('$baseUrl/me'),
        headers: {'x-auth-token': token, 'Content-Type': 'application/json'});

    try {
      if (response.statusCode == 200) {
        return Lab.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get lab data');
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Unexpected response format. Please try again later.');
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<Lab> addTestToLab(String testId, String labId, int price) async {
    final token = await tokenRole.getToken();

    if (token == null) {
      throw Exception("No token provided");
    }
    final response = await http.post(Uri.parse('$baseUrl/auth'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'labId': labId,
          'testId': testId,
          'price': price,
        }));

    try {
      if (response.statusCode == 201) {
        return Lab.fromJson(jsonDecode(response.body));
      } else {
        return throw Exception("Failed to login");
      }
    } on http.ClientException {
      return throw Exception(
          "Network error. Please check your internet connection.");
    } on FormatException {
      return throw Exception(
          "Unexpected response format. Please try again later.'");
    } catch (e) {
      return throw Exception(e.toString());
    }
  }

  Future<Lab> updateLabProfile(Lab lab) async {
    final token = await tokenRole.getToken();

    if (token == null) {
      throw Exception("No token provided");
    }

    final response = await http.put(Uri.parse('$baseUrl/:id/profile'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(lab.toJson()));

    try {
      if (response.statusCode == 200) {
        return Lab.fromJson(jsonDecode(response.body));
      } else {
        return throw Exception("Failed to update lab profile");
      }
    } on http.ClientException {
      return throw Exception(
          "Network error. Please check your internet connection.");
    } on FormatException {
      return throw Exception(
          "Unexpected response format. Please try again later.'");
    }
  }

  Future<Lab> getLabTests(String id) async {
    final token = await tokenRole.getTokenRole();
    if (token == null) {
      throw Exception('Token is null');
    }
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/tests/labs/$id'), headers: <String, String>{
        'x-auth-token': token,
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        return Lab.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load lab tests');
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Unexpected response format. Please try again later.');
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<List<Lab>> getAllTestsForLab(String id) async {
    final token = await tokenRole.getTokenRole();
    if (token == null) {
      throw Exception('Token is null');
    }
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/tests/$id'), headers: <String, String>{
        'x-auth-token': token,
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Lab.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load lab tests');
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Unexpected response format. Please try again later.');
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<bool> switchStatus() async {
    final token = await tokenRole.getToken();
    if (token == null) {
      throw Exception("No token provided");
    }
    final response = await http.put(Uri.parse('$baseUrl/:id/status'),
        headers: <String, String>{
          'x-auth-token': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'status': true}));
    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to switch status');
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Unexpected response format. Please try again later.');
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
