import 'package:Search_Alerts/Screens/Authenticate/Authenticate.dart';
import 'package:Search_Alerts/Screens/Home/IndexTab.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<String>(context);
    //return either Home or Authenticate widget.
    print(user);
    if (user == null) {
      return Authenticate();
    } else {
      return IndexTab();
    }
  }
}
