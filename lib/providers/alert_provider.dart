import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:search_alerts/util/app_url.dart';

enum Status { SendingData, Awaiting }

class AlertProvider with ChangeNotifier {
  Status _sendingData = Status.Awaiting;

  Status get sendingData => _sendingData;

  Future<Map<String, dynamic>> storeAlert(
      int searchId, String token, int activate, int hours, int minutes) async {
    _sendingData = Status.SendingData;
    final Map<String, dynamic> registrationSearchQueryData = {
      'search_id': searchId,
      'activate': activate,
      'schedule': hours.toString() + ":" + minutes.toString()
    };

    _sendingData = Status.Awaiting;
    return await post(AppUrl.addNewAlert,
        body: json.encode(registrationSearchQueryData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token
        }).then(onValue).catchError(onError);
  }

  Future<Map<String, dynamic>> updateAlert(
      int searchId, String token, int activate, int hours, int minutes) async {
    _sendingData = Status.SendingData;
    final Map<String, dynamic> registrationSearchQueryData = {
      'activate': activate,
      'schedule': hours.toString() + ":" + minutes.toString()
    };

    _sendingData = Status.Awaiting;
    return await put(AppUrl.updateAlert + searchId.toString(),
        body: json.encode(registrationSearchQueryData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token
        }).then(onValue).catchError(onError);
  }

  Future<Map<String, dynamic>> getAlert(String token, int searchId) async {
    _sendingData = Status.SendingData;
    Response res = await http.get(AppUrl.getAlert + searchId.toString(),
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (res.statusCode == 200) {
      _sendingData = Status.Awaiting;
      return json.decode(res.body);
    } else {
      _sendingData = Status.Awaiting;
      return null;
    }
  }

  Future<int> getAlertId(int search, String token) async {
    _sendingData = Status.SendingData;
    Response res = await http.get(AppUrl.getAlertId + search.toString(),
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (res.statusCode == 200) {
      _sendingData = Status.Awaiting;
      return json.decode(res.body);
    } else {
      _sendingData = Status.Awaiting;
      return null;
    }
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
