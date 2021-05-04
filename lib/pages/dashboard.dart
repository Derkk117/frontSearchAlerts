import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_alerts/domain/user.dart';
import 'package:search_alerts/providers/search_provider.dart';
import 'package:search_alerts/util/widgets.dart';
import 'package:search_alerts/util/Browser.dart';
import 'package:search_alerts/providers/user_provider.dart';
import 'package:search_alerts/providers/alert_provider.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  ValueNotifier<String> searchQuery = ValueNotifier<String>("");
  // String searchQuery = "";
  String myurl = "";
  TextEditingController _txController = new TextEditingController();

  List<Browser> dynamicList = [];

  @override
  void initState() {
    dynamicList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    AlertProvider alerts = Provider.of<AlertProvider>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: SideDrawer(),
        appBar: AppBar(
          title: Container(
            child: TextField(
              controller: _txController,
              autofocus: false,
              style: TextStyle(fontSize: 20.0, color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                hintText: 'Something to search?',
                hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
            height: 40,
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    addDynamic();
                    alerts.storeSearch(
                        _txController.text, user.token, user.email);
                  },
                  child: Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                ))
          ],
        ),
        body: getContent(context));
  }

  updateString(String value) {
    searchQuery.value = value;
  }

  Widget getContent(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    SearchProvider s = Provider.of<SearchProvider>(context);

    if (dynamicList.length == 0) {
      return ListView(
        children: [
          Container(
            color: Color(0xff063057),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "You recent searches:",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Column(
            children: [
              FutureBuilder(
                future: s.recentSearches(user.token, user.userId),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            children: snapshot.data.map((search) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 40, right: 40, top: 40),
                                child: longButtons(
                                    search['concept'],
                                    () => {
                                          _txController.text =
                                              search['concept'],
                                          addDynamic()
                                        }),
                              );
                            }).toList(),
                          )),
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 60,
                      ),
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children,
                    ),
                  );
                },
              )
            ],
          )
        ],
      );
    } else {
      return ListView.builder(
        itemCount: dynamicList.length,
        itemBuilder: (_, index) => dynamicList[index],
      );
    }
  }

  void addDynamic() {
    updateString(_txController.text);
    if (searchQuery.value.length > 0 && dynamicList.length == 0) {
      setState(() {
        dynamicList = [];
      });
      dynamicList.add(Browser(
          firstUrl:
              "https://www.google.com.mx/search?sxsrf=ALeKk03zTLWKxs8rq70CbOENqaoWWsMmSA%3A1584863771703&source=hp&ei=Gxp3XtzsKMSMtAb7xJaIDQ&q=",
          lasttUrl:
              "&btnK=Google+Search&oq=cambiar+motor+de+busqueda+edge+&gs_l=psy-ab.3.0.0i203l2j0i22i30l8.1351.5047..6282...0.0..0.282.2572.0j14j3......0....1..gws-wiz.......35i39j0i273j0j0i67j0i20i263.I-gqQr5JB1g",
          searchQuery: this.searchQuery,
          source:
              "window.document.getElementsByClassName('WE0UJf')[0].innerText;",
          domainName: "Google"));
      dynamicList.add(Browser(
          firstUrl: "https://www.youtube.com/results?search_query=",
          lasttUrl: "",
          searchQuery: this.searchQuery,
          source:
              "window.document.getElementsById('text-container')[0].innerText;",
          domainName: "YouTube"));
      dynamicList.add(Browser(
          firstUrl: "https://www.bing.com/search?q=",
          lasttUrl: "",
          searchQuery: this.searchQuery,
          source:
              "window.document.getElementsByClassName('sb_count')[0].innerText;",
          domainName: "Bing"));
    } else if (searchQuery.value.length > 0 && dynamicList.length > 0) {
      updateString(_txController.text);
    }
  }
}
