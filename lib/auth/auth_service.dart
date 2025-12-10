import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServise {
  final String baseUrl = "https://d5dsstfjsletfcftjn3b.apigw.yandexcloud.net";

  final String _errorMessage = 'Error. Try again.';

  Future<void> requestCode(String email) async {
    try {
      final uri = Uri.parse('$baseUrl/login');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      if (response.statusCode != 200) {
        throw Exception('Bad status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(_errorMessage);
    }
  }

  Future<AuthToken> confirmCode(String email, String code) async {
    try {
      final uri = Uri.parse('$baseUrl/confirm_code');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': int.tryParse(code) ?? code}),
      );
      if (response.statusCode != 200) {
        throw Exception('Bad status code: ${response.statusCode}');
      }
      final json = jsonDecode(response.body);
      final jwt = json['jwt'] as String;
      final refreshToken = json['refresh_token'] as String;

      return AuthToken(jwt: jwt, refreshToken: refreshToken);
    } catch (error) {
      throw Exception(_errorMessage);
    }
  }

  Future<String> getUserId(String jwt) async {
  try {
    final uri = Uri.parse('$baseUrl/auth');

    final response = await http.get(
      uri,
      headers: {'Auth': 'Bearer $jwt'},
    );

    if (response.statusCode != 200) {
      throw Exception('Bad status code: ${response.statusCode}');
    }

    final json = jsonDecode(response.body);
    final userId = json['user_id'].toString();

    return userId;
  } catch (error) {
    throw Exception(_errorMessage);
  }
}


  Future<AuthToken?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');
    final refresh_token = prefs.getString('refresh_token');

    if (jwt == null || refresh_token == null) {
      return null;
    }

    return AuthToken(jwt: jwt, refreshToken: refresh_token);
  }

  Future<void> saveToken(AuthToken token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', token.jwt);
    await prefs.setString('refresh_token', token.refreshToken);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
    await prefs.remove('refresh_token');
  }

  Future<AuthToken> refreshToken(String refresh_token) async {
    try {
      final uri = Uri.parse('$baseUrl/refresh_token');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': refresh_token}),
      );

      if (response.statusCode != 200) {
        throw Exception('Bad status code: ${response.statusCode}');
      }

      final json = jsonDecode(response.body);
      final jwt = json['jwt'] as String;
      final refreshToken = json['refresh_token'] as String;

      return AuthToken(jwt: jwt, refreshToken: refreshToken);
    } catch (error) {
      throw Exception(_errorMessage);
    }
  }
}

class AuthToken {
  final String jwt;
  final String refreshToken;

  AuthToken({required this.jwt, required this.refreshToken});
}
