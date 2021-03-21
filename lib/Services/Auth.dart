import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String searchAlertsApi = 'http://192.168.1.76:80/api/';
  String token = '';

  //login
  Future<http.Response> logIn(String username, String password) async {
    final b = jsonEncode({'username': username, 'password': password});
    final http.Response response = await http.post(
      this.searchAlertsApi + 'login',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: b,
    );
    dynamic result = jsonDecode(response.body);
    if (result != '"Credentials are wrong."') {
      this.token = result['access_token'];
      await getLoggedUser(this.token);
    }
    return response;
  }

  //get current logged user.
  Future<http.Response> getLoggedUser(String token) async {
    final http.Response response = await http.get(
      this.searchAlertsApi + 'loggedUser',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      },
    );
    return response;
  }

  //log out.
  Future<http.Response> logOut() async {
    final http.Response response = await http
        .post(this.searchAlertsApi + 'logout', headers: <String, String>{
      'Content-Type': 'application/json',
    });
    return response;
  }
}
