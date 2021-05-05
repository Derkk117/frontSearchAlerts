import 'package:flutter/material.dart';
import 'package:search_alerts/util/widgets.dart';

class MySearch extends StatefulWidget {
  final int searchId;
  final String searchName;

  MySearch({Key key, @required this.searchId, @required this.searchName})
      : super(key: key);

  @override
  _MySearchState createState() => _MySearchState();
}

class _MySearchState extends State<MySearch> {
  bool activate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: SideDrawer(),
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(widget.searchName),
        ),
        body: ListView(
          children: [
            Container(
              child: SwitchListTile(
                title: const Text(
                  'Activate alert',
                  style: TextStyle(color: Colors.white),
                ),
                value: activate,
                activeColor: Colors.lightGreen,
                inactiveTrackColor: Colors.red,
                onChanged: (bool value) {
                  setState(() {
                    activate = value;
                  });
                },
                secondary: const Icon(
                  Icons.alarm,
                  color: Colors.white,
                ),
              ),
              color: Color(0xff063057),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Center(
                child: Text(
                  "select which sites you want to enable this recurring search:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Container(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/google.png',
                      height: 60,
                      width: 180,
                    ),
                    Checkbox(
                        value: activate,
                        onChanged: (bool value) {
                          activate = value;
                        })
                  ],
                ),
                color: Colors.red,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Container(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/google.png',
                      height: 60,
                      width: 180,
                    ),
                    Checkbox(
                        value: activate,
                        onChanged: (bool value) {
                          activate = value;
                        })
                  ],
                ),
                color: Colors.red,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Container(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/google.png',
                      height: 60,
                      width: 180,
                    ),
                    Checkbox(
                        value: activate,
                        onChanged: (bool value) {
                          activate = value;
                        })
                  ],
                ),
                color: Colors.red,
              ),
            )
          ],
        ));
  }
}
