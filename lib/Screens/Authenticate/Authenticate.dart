import 'package:Search_Alerts/Screens/Authenticate/LogIn.dart';
import 'package:Search_Alerts/Screens/Authenticate/SignUp.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignUp = false;
  void toggleView() {
    setState(() => showSignUp = !showSignUp);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignUp) {
      return Container(
        child: SignUp(toggleView: toggleView),
      );
    } else {
      return Container(
        child: LogIn(toggleView: toggleView),
      );
    }
  }
}
