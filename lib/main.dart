import 'MyColor.dart';
import 'domain/user.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_alerts/pages/login.dart';
import 'package:search_alerts/pages/profile.dart';
import 'package:search_alerts/providers/auth.dart';
import 'package:search_alerts/pages/register.dart';
import 'package:search_alerts/pages/dashboard.dart';
import 'package:search_alerts/pages/my_alerts.dart';
import 'package:search_alerts/pages/my_searches.dart';
import 'package:search_alerts/util/shared_preference.dart';
import 'package:search_alerts/providers/user_provider.dart';
import 'package:search_alerts/providers/alert_provider.dart';
import 'package:search_alerts/providers/search_provider.dart';
import 'package:search_alerts/providers/search_instance_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  runApp(MyApp());
  // await Future.delayed(Duration(seconds: 20));
  // await cron.close();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin not;

  @override
  void initState() {
    super.initState();
    var androidInitialize =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosIntialize = IOSInitializationSettings();
    var initialzationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosIntialize);

    not = new FlutterLocalNotificationsPlugin();
    not.initialize(initialzationSettings);
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "channelId", "Local Notification", "Description of local notifications",
        importance: Importance.high);
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await not.show(1, "New Updates for Rammstein",
        "Click here to see new results in google", generalNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    final cron = Cron()
      ..schedule(Schedule.parse('*/4 * * * *'), () async {
        _showNotification();
      });
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AlertProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => SearchInstanceProvider()),
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
            '/searches': (context) => MySearches(),
            '/alerts': (context) => MyAlerts(),
          }),
    );
  }
}
