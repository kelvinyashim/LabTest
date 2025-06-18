import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_ease/main.dart';
import 'package:test_ease/models/phleb/phleb_orders.dart';

class PhlebApi {
  final String baseUrl = 'https://labconnect-e569.onrender.com/api/phlebs';

  Future<void> loginPhleb(String email, String psw) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contactInfo': {'email': email},
          'password': psw,
        }),
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final token = jsonData['token'];

        if (token != null) {
          await tokenRole.saveTokenRole(token);
        } else {
          print('No token found in login response');
        }

        print(jsonData);
      }
    } on http.ClientException {
      throw Exception("Network error. Please check your internet connection.");
    } on FormatException {
      throw Exception("Unexpected response format. Please try again later.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<PhlebOrders>> getOrdersPhleb() async {
    final token = await tokenRole.getToken();

    if (token == null) {
      throw Exception("No token provided");
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> fetchedOrders = data['orders'];
        return fetchedOrders
            .map((order) => PhlebOrders.fromJson(order))
            .toList();
      } else {
        throw ('Failed to fetch orders');
      }
    } on http.ClientException {
      throw Exception("Network error. Please check your internet connection.");
    } on FormatException {
      throw Exception("Unexpected response format. Please try again later.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> acceptOrder(String id) async {
    final token = await tokenRole.getToken();

    if (token == null) {
      throw Exception("No token provided");
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accept-orders/$id'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Accepted');
      } else {
        throw ('Failed to accept order');
      }
    } on http.ClientException {
      throw Exception("Network error. Please check your internet connection.");
    } on FormatException {
      throw Exception("Unexpected response format. Please try again later.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> markComplete(String id) async {
    final token = await tokenRole.getToken();

    if (token == null) {
      throw Exception("No token provided");
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders-complete/$id'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        print('Completed');
      } else {
        throw ('Failed to accept order');
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
