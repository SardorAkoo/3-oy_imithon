

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthHttpServices {
  final String _apiKey = "AIzaSyAedohVKdLar-uCLlKCjeQJdWu6EVAPFjI";

  Future<void> _authenticate(
    String email,
    String password,
    String query,
  ) async {
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$query?key=$_apiKey");

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (data['error']['message']);
      }

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString("token", data['idToken']);
      await sharedPreferences.setString("userId", data['localId']);
      DateTime expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(data['expiresIn'])),
      );
      await sharedPreferences.setString("expiryDate", expiryDate.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    await _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    await _authenticate(email, password, "signInWithPassword");
  }

  Future<bool> checkAuth() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");

    if (token == null) {
      return false;
    }

    DateTime expiryDate =
        DateTime.parse(sharedPreferences.getString("expiryDate")!);

    //? check token expiration date
    return expiryDate.isAfter(DateTime.now());
  }

  static void logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  Future<void> resetPassword(String email) async {
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$_apiKey");

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "requestType": "PASSWORD_RESET",
            "email": email,
          },
        ),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (data['error']['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmPasswordReset(String oobCode, String newPassword) async {
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?key=$_apiKey");

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "oobCode": oobCode,
            "newPassword": newPassword,
          },
        ),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (data['error']['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}