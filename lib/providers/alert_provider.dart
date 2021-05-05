import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';

class AlertProvider with ChangeNotifier {
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
