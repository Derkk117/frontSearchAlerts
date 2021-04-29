import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Search_Alerts/util/Browser.dart';
import 'package:Search_Alerts/domain/user.dart';
import 'package:Search_Alerts/util/shared_preference.dart';
import 'package:Search_Alerts/providers/user_provider.dart';

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
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text("DASHBOARD PAGE"),
    //       elevation: 0.1,
    //     ),
    //     body: Column(
    //       children: [
    //         SizedBox(
    //           height: 100,
    //         ),
    //         Center(child: Text(user.email ?? '')),
    //         SizedBox(height: 100),
    //         RaisedButton(
    //           onPressed: () {
    //             UserPreferences().removeUser();
    //             Navigator.pushReplacementNamed(context, '/login');
    //           },
    //           child: Text("Logout"),
    //           color: Colors.lightBlueAccent,
    //         )
    //       ],
    //     ),
    //   );
    // }
    //
    Size size = MediaQuery.of(context).size;
    User user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                onTap: addDynamic,
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.more_vert),
              )),
        ],
      ),
      body: ListView.builder(
        itemCount: dynamicList.length,
        itemBuilder: (_, index) => dynamicList[index],
      ),
    );
  }

  updateString(String value) {
    searchQuery.value = value;
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
