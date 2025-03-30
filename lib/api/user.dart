import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_ease/api_constants/token_role.dart';
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
      final token = response.headers['x-auth-token'];

      if (token != null) {
        tokenRole.saveTokenRole(token);
      } else {
        throw Exception("Failed to save authentication token.");
      }

      return Patient.fromJson(data);
    } else {
      final Map<String, dynamic> data = jsonDecode(response.body);
      throw Exception(data['message'] ?? "An error occurred. Please try again.");
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
    final response = await http.get(Uri.parse('$baseUrl/me'));

    if (response.statusCode == 200) {
      return Patient.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load patient');
    }
  }

  Future<Patient> loginUser(String email, String password) async {
    try{
      final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final token = data['token'] as String;
      tokenRole.saveTokenRole(token);
      return Patient.fromJson(data);
    } else {
      throw Exception('Failed to create user.');
    }
    }
    on http.ClientException{
      throw Exception('Network error. Please check your internet connection.');
    }
    on FormatException{
      throw Exception('Unexpected response format. Please try again later.');
    }
    catch(e){
      throw Exception(e.toString());
    }
    
  }
}
