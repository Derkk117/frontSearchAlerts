import 'package:Search_Alerts/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('user_id', user.userId);
    prefs.setString("name", user.name);
    prefs.setString("email", user.email);
    prefs.setString("image", user.image);
    prefs.setString("token", user.token);

    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt('user_id');
    String name = prefs.getString("name");
    String email = prefs.getString("email");
    String image = prefs.getString("image");
    String token = prefs.getString("token");

    return User(
        userId: userId, name: name, email: email, image: image, token: token);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("user_id");
    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("image");
    prefs.remove("token");
  }

  Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }
}
