import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:search_alerts/domain/user.dart';
import 'package:search_alerts/util/app_url.dart';
import 'package:search_alerts/util/shared_preference.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut,
  Updating
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  /* Login Function */

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'username': email,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      AppUrl.login,
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      Response res = await get(AppUrl.getUser + '/' + email, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + json.decode(response.body)['access_token']
      });

      if (res.statusCode == 200) {
        Map<String, dynamic> user = {
          'data': jsonDecode(res.body),
          'token': 'Bearer ' + json.decode(response.body)['access_token']
        };
        User authUser = User.fromJson(user);

        UserPreferences().saveUser(authUser);

        _loggedInStatus = Status.LoggedIn;
        notifyListeners();

        result = {'status': true, 'message': 'Successful', 'user': authUser};
      } else {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {'status': false, 'message': 'Login error, please try again!'};
      }
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {'status': false, 'message': 'Login error, please try again!'};
    }
    return result;
  }

  Future<Map<String, dynamic>> register(String name, String email,
      String password, String passwordConfirmation) async {
    final Map<String, dynamic> registrationData = {
      'name': name,
      'email': email,
      'password': password
    };
    if (password == passwordConfirmation) {
      return await post(AppUrl.register,
              body: json.encode(registrationData),
              headers: {'Content-Type': 'application/json'})
          .then(onValue)
          .catchError(onError);
    } else
      return {'Error': 'The password and password confirmation are not equal'};
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      result = {'status': true, 'message': 'Successfully registered'};
    } else {
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
