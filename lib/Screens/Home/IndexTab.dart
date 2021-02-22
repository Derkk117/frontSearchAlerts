import 'package:Search_Alerts/Screens/Home/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../MyColor.dart';

class IndexTab extends StatefulWidget {
  @override
  _IndexTabState createState() => _IndexTabState();
}

class _IndexTabState extends State<IndexTab> {
  //final AuthService _auth = AuthService();

  final titles = [
    Text("My Stickers"),
    Text("Forum"),
    Text("Home"),
    Text("Search Sticker"),
    Text("Account"),
  ];
  int _currentIndex = 2;
  final tabs = [
    Center(
        child: Text(
      "Search Page",
      style: TextStyle(color: Colors.white),
    )),
    Center(
        child: Text(
      "Forum Page",
      style: TextStyle(color: Colors.white),
    )),
    Home(),
    Center(
        child: Text(
      "Search Page",
      style: TextStyle(color: Colors.white),
    )),
    Center(
        child: Text(
      "Search Page",
      style: TextStyle(color: Colors.white),
    )),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Sign Up",
        theme: ThemeData(
          primarySwatch: createMaterialColor(Color(0xFF1F1F3A)),
          scaffoldBackgroundColor: createMaterialColor(Color(0xFF121213)),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: titles[_currentIndex],
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                textColor: Colors.white,
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                label: Text("Log out"),
                onPressed: () async {
                  //await _auth.signOut();
                },
              )
            ],
          ),
          body: tabs[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'Assets/Images/Stick_logo.png',
                    height: 20,
                  ),
                  label: "My Stickers",
                  backgroundColor: createMaterialColor(Color(0xFF1F1F3A))),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: "Forum",
                  backgroundColor: createMaterialColor(Color(0xFF1F1F3A))),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                  backgroundColor: createMaterialColor(Color(0xFF1F1F3A))),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: "Search",
                  backgroundColor: createMaterialColor(Color(0xFF1F1F3A))),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Account",
                  backgroundColor: createMaterialColor(Color(0xFF1F1F3A))),
            ],
            onTap: (index) {
              setState(() => _currentIndex = index);
            },
          ),
        ));
  }
}
