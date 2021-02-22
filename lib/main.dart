import 'package:Search_Alerts/Models/User.dart';
import 'package:Search_Alerts/Services/Auth.dart';
import 'package:Search_Alerts/Welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'MyColor.dart';
// Import the firebase_core plugin
import 'dart:async';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, String> newUser = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserSA>.value(
      //value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Search Alerts',
        theme: ThemeData(
          primarySwatch: createMaterialColor(Color(0xFF1F1F3A)),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: Welcome(),
      ),
    );
  }
}
