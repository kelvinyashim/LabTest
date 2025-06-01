import 'dart:convert';

import 'package:test_ease/main.dart';
import 'package:test_ease/models/lab/labs.dart';
import 'package:http/http.dart' as http;
import 'package:test_ease/models/lab/test.dart';
import 'package:test_ease/models/patients/order.dart';
import 'package:test_ease/models/phleb/phleb.dart';

class LabApi {
  final String baseUrl = 'https://labconnect-e569.onrender.com/api/labs';

  Future<Lab> loginLab(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contactInfo': {'email': email},
        'password': password,
      }),
    );

    print(response.body);
    print(response.statusCode);

    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final labJson = data['message'];
        final token = data['token'];

        if (token == null) {
          throw Exception("No token received from backend.");
        }

        await tokenRole.saveTokenRole(token);

        return Lab.fromJson(labJson);
      } else {
        throw Exception("Failed to login: ${response.body}");
      }
    } on http.ClientException {
      throw Exception("Network error. Please check your internet connection.");
    } on FormatException {
      throw Exception("Unexpected response format. Please try again later.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Lab> getCurrentLab() async {
    final token = await tokenRole.getToken();

    if (token == null) {
      throw Exception("No token provided");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {'x-auth-token': token, 'Content-Type': 'application/json'},
    );

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

  Future<Test> addTestToLab(String testId, String labId, int price) async {
    final token = await tokenRole.getToken();

    if (token == null) {
      throw Exception("No token provided");
    }
    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      body: jsonEncode({'labId': labId, 'testId': testId, 'price': price}),
    );

    try {
      if (response.statusCode == 201) {
        return Test.fromJson(jsonDecode(response.body));
      } else {
        return throw Exception("Failed to login");
      }
    } on http.ClientException {
      return throw Exception(
        "Network error. Please check your internet connection.",
      );
    } on FormatException {
      return throw Exception(
        "Unexpected response format. Please try again later.'",
      );
    } catch (e) {
      return throw Exception(e.toString());
    }
  }

  Future<Lab> updateLabProfile(Lab lab) async {
    final token = await tokenRole.getToken();

    if (token == null) {
      throw Exception("No token provided");
    }

    final response = await http.put(
      Uri.parse('$baseUrl/:id/profile'),
      headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      body: jsonEncode(lab.toJson()),
    );

    try {
      if (response.statusCode == 200) {
        return Lab.fromJson(jsonDecode(response.body));
      } else {
        return throw Exception("Failed to update lab profile");
      }
    } on http.ClientException {
      return throw Exception(
        "Network error. Please check your internet connection.",
      );
    } on FormatException {
      return throw Exception(
        "Unexpected response format. Please try again later.'",
      );
    }
  }

  Future<List<Test>> getAllTestsForLab(String id) async {
    final token = await tokenRole.getTokenRole();
    if (token == null) {
      throw Exception('Token is null');
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tests'),
        headers: <String, String>{
          'x-auth-token': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Test.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load lab tests');
      }
    } on http.ClientException {
      throw ('Network error. Please check your internet connection.');
    } on FormatException {
      throw ('Unexpected response format. Please try again later.');
    } catch (error) {
      throw (error.toString());
    }
  }

  Future<bool> switchStatus() async {
    final token = await tokenRole.getToken();
    if (token == null) {
      throw Exception("No token provided");
    }
    final response = await http.put(
      Uri.parse('$baseUrl/:id/status'),
      headers: <String, String>{
        'x-auth-token': token,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'status': true}),
    );
    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to switch status');
      }
    } on http.ClientException {
      throw ('Network error. Please check your internet connection.');
    } on FormatException {
      throw ('Unexpected response format. Please try again later.');
    } catch (error) {
      throw (error.toString());
    }
  }

  Future<List<Order>> getOrders() async {
    final token = await tokenRole.getToken();
    if (token == null) {
      throw Exception('Token is null');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lab-orders'),
        headers: <String, String>{
          'x-auth-token': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> fecthedOrders = data['orders'];
        return fecthedOrders.map((order) => Order.fromJson(order)).toList();
      } else if (response.statusCode == 404) {
        throw ('No orders pending');
      } else {
        throw ('Failed to load orders');
      }
    } on http.ClientException {
      throw ('Network error. Please check your internet connection.');
    } on FormatException {
      throw ('Unexpected response format. Please try again later.');
    } catch (error) {
      throw (error.toString());
    }
  }

  Future<void> acceptOrder(String id) async {
    final token = await tokenRole.getToken();
    if (token == null) {
      throw Exception('Token is null');
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/$id/accept'),
        headers: {
          'x-auth-token': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        print(decode);
      }
    } on http.ClientException {
      throw ('Network error. Please check your internet connection.');
    } on FormatException {
      throw ('Unexpected response format. Please try again later.');
    } catch (error) {
      throw (error.toString());
    }
  }

  Future<Phleb> addPhleb(Phleb phleb) async {
    final token = await tokenRole.getToken();
    if (token == null) {
      throw Exception('Token is null');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add-phleb'),
        headers: <String, String>{
          'x-auth-token': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(phleb.toJson()),
      );

      if (response.statusCode == 201) {
        final token = response.headers['x-auth-token'];
        if (token != null) {
          tokenRole.saveTokenRole(token);
        }
        final Map<String, dynamic> phleb = jsonDecode(response.body);
        final data = phleb['mesage'];

        return Phleb.fromJson(data);
      } else {
        throw ('Something went wrong');
      }
    } on http.ClientException {
      throw ('Network error. Please check your internet connection.');
    } on FormatException {
      throw ('Unexpected response format. Please try again later.');
    } catch (error) {
      throw (error.toString());
    }
  }

  Future<List<Phleb>> getAllPhlebs() async {
    final token = await tokenRole.getToken();
    if (token == null) {
      throw Exception('Token is null');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/phlebs'),
        headers: <String, String>{'x-auth-token': token},
      );

      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((phleb) => Phleb.fromJson(phleb)).toList();
      } else {
        throw (response.statusCode);
      }
    } on http.ClientException {
      throw ('Network error. Please check your internet connection.');
    } on FormatException {
      throw ('Unexpected response format. Please try again later.');
    } catch (error) {
      throw (error.toString());
    }
  }

  Future<void> assignOrder(String id, String orderId) async {
    final token = await tokenRole.getToken();
    if (token == null) {
      throw Exception('Token is null');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/assign-orders/$id/$orderId'),
        headers: {'x-auth-token': token, 'Content-Type': 'application/json;'},
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        throw ('Something went wrong');
      }
    } on http.ClientException {
      throw ('Network error. Please check your internet connection.');
    } on FormatException {
      throw ('Unexpected response format. Please try again later.');
    } catch (error) {
      throw (error.toString());
    }
  }
}
