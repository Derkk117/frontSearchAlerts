import 'package:Search_Alerts/Models/User.dart';
import 'package:Search_Alerts/Screens/Authenticate/Authenticate.dart';
import 'package:Search_Alerts/Screens/Home/IndexTab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserSA>(context);

    //return either Home or Authenticate widget.
    if (user == null) {
      return Authenticate();
    } else {
      return IndexTab();
    }
  }
}
