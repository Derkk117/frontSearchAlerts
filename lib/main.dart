import 'MyColor.dart';
import 'domain/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Search_Alerts/pages/login.dart';
import 'package:Search_Alerts/providers/auth.dart';
import 'package:Search_Alerts/pages/register.dart';
import 'package:Search_Alerts/pages/dashboard.dart';
import 'package:Search_Alerts/util/shared_preference.dart';
import 'package:Search_Alerts/providers/user_provider.dart';
import 'package:Search_Alerts/providers/alert_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AlertProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Search Alerts',
          theme: ThemeData(
            primarySwatch: createMaterialColor(Colors.black),
            scaffoldBackgroundColor: Colors.white,
          ),
          home: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else if (snapshot.data.token == null)
                      return Login();
                    else
                      UserPreferences().removeUser();
                    return DashBoard();
                }
              }),
          routes: {
            '/dashboard': (context) => DashBoard(),
            '/login': (context) => Login(),
            '/register': (context) => Register(),
          }),
    );
  }
}
