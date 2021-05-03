import 'MyColor.dart';
import 'domain/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_alerts/pages/login.dart';
import 'package:search_alerts/pages/profile.dart';
import 'package:search_alerts/providers/auth.dart';
import 'package:search_alerts/pages/register.dart';
import 'package:search_alerts/pages/dashboard.dart';
import 'package:search_alerts/util/shared_preference.dart';
import 'package:search_alerts/providers/user_provider.dart';
import 'package:search_alerts/providers/alert_provider.dart';

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
                    return Login();
                }
              }),
          routes: {
            '/dashboard': (context) => DashBoard(),
            '/login': (context) => Login(),
            '/register': (context) => Register(),
            '/profile': (context) => Profile(),
          }),
    );
  }
}
