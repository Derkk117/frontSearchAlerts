import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_alerts/domain/user.dart';
import 'package:search_alerts/util/widgets.dart';
import 'package:search_alerts/pages/my_search.dart';
import 'package:search_alerts/providers/search_provider.dart';
import 'package:search_alerts/providers/user_provider.dart';

class MySearches extends StatefulWidget {
  @override
  _MySearchesState createState() => _MySearchesState();
}

class _MySearchesState extends State<MySearches> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[300],
        drawer: SideDrawer(),
        appBar: AppBar(title: Text("My Searches")),
        body: getContent(context));
  }

  Widget getContent(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    SearchProvider s = Provider.of<SearchProvider>(context);

    return Column(children: [
      Padding(
        padding: EdgeInsets.only(top: 8, bottom: 15),
        child: Text(
          "Tap to see alert config :)",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23.0, color: Colors.black),
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: FutureBuilder(
            future: s.getSearches(user.token, user.userId),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  Column(
                    children: snapshot.data.map((search) {
                      return GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff063057),
                              border: Border(
                                  bottom: BorderSide(color: Colors.white))),
                          height: 60,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5, left: 10),
                                child: Text(
                                  search['concept'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MySearch(
                                      searchId: search['sku'],
                                      searchName: search['concept'],
                                    )),
                          );
                        },
                      );
                    }).toList(),
                  ),
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
                  Center(
                      child: SizedBox(
                    child: CircularProgressIndicator(),
                  )),
                  Center(
                    child: SizedBox(
                      child: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      ),
                      width: 60,
                      height: 60,
                    ),
                  )
                ];
              }
              return ListView(
                children: children,
              );
            },
          ),
        ),
      )
    ]);
  }
}
