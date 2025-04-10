import 'dart:convert';

import 'package:test_ease/main.dart';
import 'package:test_ease/models/test_catalogue.dart';
import 'package:http/http.dart' as http;

class TestAdminApi {
  final String baseUrl = 'https://labconnect-e569.onrender.com/api/admin';

  Future<TestCatalogue> addTest(TestCatalogue test) async {
    final token = await tokenRole.getToken();

    if (token == null) {
      throw Exception("No token provided");
    }

    final response = await http.post(Uri.parse('$baseUrl/add-test'),
        headers: {'x-auth-token': token, 'Content-Type': 'application/json'},
        body: jsonEncode(test.toJson()));

    try {
      if (response.statusCode == 201) {
        final testCatalogue = TestCatalogue.fromJson(jsonDecode(response.body));
        return testCatalogue;
      } else {
        throw Exception('Failed to add test');
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Unexpected response format. Please try again later.');
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<List<TestCatalogue>> getAllTests() async {
    final token = await tokenRole.getToken();

    if (token == null) {
      throw Exception("No token provided");
    }

    final response = await http.get(Uri.parse('$baseUrl/tests'),
        headers: {'x-auth-token': token, 'Content-Type': 'application/json'});

    

    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => TestCatalogue.fromJson(e)).toList();
      } else {
        throw Exception('Failed to get tests');
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
