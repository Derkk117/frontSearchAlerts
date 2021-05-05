import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:provider/provider.dart';
import 'package:search_alerts/domain/user.dart';
import 'package:search_alerts/util/widgets.dart';
import 'package:search_alerts/providers/auth.dart';
import 'package:search_alerts/util/validators.dart';
import 'package:search_alerts/providers/user_provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();
  String _username, _password;

  @override
  Widget build(BuildContext context) {
    final color = Colors.black;
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final usernameField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      onSaved: (value) => _username = value,
      decoration: buildInputDecoration("Confirm password", Icons.email),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextButton(
          child: Text("Forgot password?",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
//            Navigator.pushReplacementNamed(context, '/reset-password');
          },
        ),
        TextButton(
          child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register');
          },
        ),
      ],
    );

    var doLogin = () {
      FocusScope.of(context).requestFocus(FocusNode());
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        final Future<Map<String, dynamic>> successfulMessage =
            auth.login(_username, _password);
        successfulMessage.then((response) {
          if (response['message'] == "Successful") {
            User user = response['user'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            Flushbar(
              title: "Failed Login",
              message: response['message'].toString(),
              duration: Duration(seconds: 5),
            ).show(context);
          }
        });
      } else {
        print("form is invalid");
      }
    };

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[300],
          body: Padding(
            padding: EdgeInsets.all(40.0),
            child: ListView(
              children: [
                Text(
                  "Welcome to Search Alerts",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      color: color),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Everything you are looking for in one place",
                  style: TextStyle(fontSize: 20.0, color: color),
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 15.0),
                        label("Email"),
                        SizedBox(height: 5.0),
                        usernameField,
                        SizedBox(height: 20.0),
                        label("Password"),
                        SizedBox(height: 5.0),
                        passwordField,
                        SizedBox(height: 20.0),
                        auth.loggedInStatus == Status.Authenticating
                            ? loading
                            : longButtons("Login", doLogin),
                        SizedBox(height: 5.0),
                        forgotLabel
                      ],
                    )),
              ],
            ),
          )),
    );
  }
}
