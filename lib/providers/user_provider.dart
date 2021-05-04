import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:search_alerts/domain/user.dart';
import 'package:search_alerts/util/app_url.dart';
import 'package:search_alerts/util/shared_preference.dart';

enum UserStatus { Updating, Updated }

class UserProvider with ChangeNotifier {
  UserStatus userStatus = UserStatus.Updated;
  User _user = new User();
  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void removeUser() {
    _user = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>> update(String email, String name,
      {String image}) async {
    var result;

    userStatus = UserStatus.Updating;
    notifyListeners();
    var postUri = Uri.parse(AppUrl.updateUser + user.userId.toString());
    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

    if (image != null) {
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('image', image);
      request.files.add(multipartFile);
    }
    request.fields["email"] = email;
    request.fields["name"] = name;
    request.headers.addAll(
        {'Content-Type': 'multipart/form-data', 'Authorization': user.token});

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Response res = await http.get(AppUrl.getUser + '/' + email, headers: {
        'Content-Type': 'application/json',
        'Authorization': user.token
      });

      if (res.statusCode == 200) {
        Map<String, dynamic> user = {'data': jsonDecode(res.body)};
        User authUser = User.fromJson(user);

        UserPreferences().saveUser(authUser);

        userStatus = UserStatus.Updated;

        notifyListeners();
        result = {'status': true, 'message': 'Successful', 'user': authUser};
      } else {
        userStatus = UserStatus.Updated;
        result = {
          'status': false,
          'message': 'Updating error, please try again!'
        };
      }
    } else {
      userStatus = UserStatus.Updated;
      result = {
        'status': false,
        'message': 'Updating error, please try again!'
      };
    }
    return result;
  }
}
