import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_ease/api_constants/token_role.dart';
import 'package:test_ease/models/labs.dart';
import 'package:test_ease/models/labs_test.dart';
import 'package:test_ease/models/patient.dart';

class UserApi {
  TokenRole tokenRole = TokenRole();
  final String baseUrl = 'https://labconnect-e569.onrender.com/api/users';

  Future<Patient> createUser(Patient patient) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sign-up'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(patient.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final patientData = data['message'];
        final token = response.headers['x-auth-token'];

        if (token != null) {
          tokenRole.saveTokenRole(token);
        } else {
          throw Exception("Failed to save authentication token.");
        }

        return Patient.fromJson(patientData);
      } else {
        final Map<String, dynamic> data = jsonDecode(response.body);
        throw Exception(
          data['message'] ?? "An error occurred. Please try again.",
        );
      }
    } on http.ClientException {
      throw Exception("Network error. Please check your internet connection.");
    } on FormatException {
      throw Exception("Unexpected response format. Please try again later.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Patient>> getPatients() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Patient.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }

  Future<Patient> updatePatient(Patient patient) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${patient.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(patient.toJson()),
    );

    if (response.statusCode == 200) {
      return Patient.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update patient');
    }
  }

  Future<Patient> getCurrentPatient() async {
    final token = await tokenRole.getToken();

    if (token == null) {
      throw Exception("Failed to load patient data");
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: <String, String>{
          'x-auth-token': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Patient.fromJson(data['message']);
      } else {
        throw Exception('Failed to load patient');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final token = data['token'] as String;
        tokenRole.saveTokenRole(token);
      } else {
        throw Exception('Failed to login');
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Unexpected response format. Please try again later.');
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<List<LabsTest>> getLabTests(String id) async {
    final token = await tokenRole.getToken();
    if (token == null) {
      throw Exception('Token is null');
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tests/labs/$id'),
        headers: <String, String>{
          'x-auth-token': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => LabsTest.fromJson(e)).toList();
      } else {
        throw Exception("No labs currently offering this test");
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Unexpected response format. Please try again later.');
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<Lab> getLabInfo(String id) async {
    final token = await tokenRole.getToken();
    if (token == null) {
      throw Exception('Token is null');
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/labs/$id'),
        headers: <String, String>{
          'x-auth-token': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Lab.fromJson(data);
      } else {
        throw Exception("Lab not found");
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Unexpected response format. Please try again later.');
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<List<String>> getPatientAddress() async {
    final token = await tokenRole.getToken();
    if (token == null) {
      throw Exception('Token is null');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/my-address'),
        headers: {
          'x-auth-token': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> addresses = data['addresses'];
        return addresses.map((e) => e.toString()).toList();
      } else {
        throw Exception("Failed to get patient address");
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Unexpected response format. Please try again later.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addAddress(String address) async {
    final token = await tokenRole.getToken();
    if (token == null) {
      throw Exception('Token is null');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add-address'),
        headers: {
          'x-auth-token': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'newAddress': address}),
      );


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["addresses"];
      } else {
        throw Exception("Failed to get patient address");
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Unexpected response format. Please try again later.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
