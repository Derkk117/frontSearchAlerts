import 'package:shared_preferences/shared_preferences.dart';
import 'package:Search_Alerts/Welcome.dart';
import 'package:Search_Alerts/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'MyColor.dart';
import 'dart:async';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  start();
  runApp(new MyApp());
}

Future start() async {
  await App.init();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<String>.value(
      value: (App.localStorage != null)
          ? App.localStorage.getString('token')
          : null,
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
