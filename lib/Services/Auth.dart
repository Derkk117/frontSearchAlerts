import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  Future<http.Response> logIn(String username, String password) async {
    final b = jsonEncode({'username': username, 'password': password});
    final http.Response response = await http.post(
      'http://192.168.1.82:80/api/login',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: b,
    );
    return response;
  }

  Future<http.Response> getLoggedUser(String token) async {
    final http.Response response = await http.get(
      'http://192.168.1.82:80/api/loggedUser',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      },
    );

    return response;
  }
}
