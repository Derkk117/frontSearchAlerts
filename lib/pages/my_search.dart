import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:provider/provider.dart';
import 'package:search_alerts/domain/user.dart';
import 'package:search_alerts/util/widgets.dart';
import 'package:search_alerts/providers/user_provider.dart';
import 'package:search_alerts/providers/search_provider.dart';

class MySearch extends StatefulWidget {
  final int searchId;
  final String searchName;

  MySearch({Key key, @required this.searchId, @required this.searchName})
      : super(key: key);

  @override
  _MySearchState createState() => _MySearchState();
}

class _MySearchState extends State<MySearch> {
  final formKey = new GlobalKey<FormState>();
  final _searchC = TextEditingController();
  String _search;

  @override
  Widget build(BuildContext context) {
    SearchProvider searchP = Provider.of<SearchProvider>(context);
    User user = Provider.of<UserProvider>(context).user;
    bool init = false;
    if (init == false) {
      this._searchC.text = widget.searchName;
      init = true;
    }

    final searchField = TextFormField(
      autofocus: false,
      controller: _searchC,
      validator: (value) =>
          value.isEmpty ? "Please enter your full name" : null,
      onSaved: (value) => _search = value,
      decoration: buildInputDecoration("Confirm password", Icons.search),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Updating ... Please wait")
      ],
    );

    var doUpdate = () {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        setState(() {
          _search = _searchC.text;
        });
        searchP.updateSearch(_searchC.text, user.token, widget.searchId);

        Navigator.pushReplacementNamed(context, '/searches');

        Flushbar(
          title: "Search Updated",
          message: ":)",
          duration: Duration(seconds: 5),
        ).show(context);
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please Complete the form properly",
          duration: Duration(seconds: 5),
        ).show(context);
      }
    };

    var doDelete = () {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        setState(() {
          _search = _searchC.text;
        });
        searchP.deleteSearch(user.token, widget.searchId);

        Flushbar(
          title: "Search deleted",
          message: ":)",
          duration: Duration(seconds: 5),
        ).show(context);
        Navigator.pushReplacementNamed(context, '/searches');
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please Complete the form properly",
          duration: Duration(seconds: 5),
        ).show(context);
      }
    };

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            drawer: SideDrawer(),
            backgroundColor: Colors.grey[300],
            appBar: AppBar(title: Text(widget.searchName)),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: ListView(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Text(
                            "Search Actions",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15.0),
                          label(
                            "Full Concept",
                          ),
                          SizedBox(height: 5.0),
                          searchField,
                          SizedBox(height: 15.0),
                          searchP.actionStatus == SearchStatus.Updating
                              ? loading
                              : longButtons("Update Search", doUpdate),
                          SizedBox(height: 20),
                          Text(
                            " Or ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          deleteButtons("Delete Search", doDelete),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
