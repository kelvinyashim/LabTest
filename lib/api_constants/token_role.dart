import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TokenRole {
  Future<void> saveTokenRole(String token) async {
    // Save token to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('x-auth-token', token);

    try {
      final decodedToken = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1]))),
      );
      final role = decodedToken['role'];
      await prefs.setString('user_role', role.toString());
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getTokenRole() async {
    final prefs = await SharedPreferences.getInstance();
   return prefs.getString('user_role');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
   return prefs.getString('x-auth-token');
  }


  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('x-auth-token');
    await prefs.remove('user_role');
  }
}
