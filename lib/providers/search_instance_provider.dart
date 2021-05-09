import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:search_alerts/util/app_url.dart';

class SearchInstanceProvider with ChangeNotifier {
  Future<Map<String, dynamic>> storeSearchInstance(
      int alertId, String token, int activate, String pageName) async {
    final Map<String, dynamic> registrationSearchQueryData = {
      'alert_id': alertId,
      'page_name': pageName,
      'activate': activate
    };

    return await post(AppUrl.addNewSearchInstance,
        body: json.encode(registrationSearchQueryData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token
        }).then(onValue).catchError(onError);
  }

  Future<Map<String, dynamic>> updateSearchInstance(
      int sInstanceId, String token, int activate) async {
    final Map<String, dynamic> registrationSearchQueryData = {
      'activate': activate
    };

    return await put(AppUrl.updateSearchInstance + sInstanceId.toString(),
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
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
