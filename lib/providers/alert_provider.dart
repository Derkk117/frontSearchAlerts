import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:Search_Alerts/util/app_url.dart';

class AlertProvider with ChangeNotifier {
  Future<Map<String, dynamic>> storeSearch(
      String searchQuery, String token, String email) async {
    final Map<String, dynamic> registrationSearchQueryData = {
      'concept': searchQuery,
      'email': email
    };
    return await post(AppUrl.addNewSearch,
        body: json.encode(registrationSearchQueryData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token
        }).then(onValue).catchError(onError);
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
    print(error);
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
