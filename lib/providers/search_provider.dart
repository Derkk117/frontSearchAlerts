import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:search_alerts/util/app_url.dart';

class SearchProvider with ChangeNotifier {
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

  Future<List<dynamic>> recentSearches(String token, int id) async {
    Response res = await http.get(AppUrl.getRecentSearches + id.toString(),
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  Future<List<dynamic>> getSearches(String token, int id) async {
    Response res = await http.get(AppUrl.getSearches + id.toString(),
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  Future<String> getSearch(String token, int search) async {
    Response res = await http.get(AppUrl.getSearch + search.toString(),
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      result = {'status': true, 'data': responseData};
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
