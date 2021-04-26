import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:Search_Alerts/providers/auth.dart';
import 'package:Search_Alerts/util/validators.dart';
import 'package:Search_Alerts/util/widgets.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();

  String _name, _username, _password, _confirmPassword;

  @override
  Widget build(BuildContext context) {
    final color = Colors.black;
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final nameField = TextFormField(
      autofocus: false,
      validator: (value) =>
          value.isEmpty ? "Please enter your full name" : null,
      onSaved: (value) => _name = value,
      decoration: buildInputDecoration("Confirm password", Icons.person),
    );

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

    final confirmPassword = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? "Your password is required" : null,
      onSaved: (value) => _confirmPassword = value,
      obscureText: true,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    final loginLabel = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.only(left: 0.0),
          child: Text("Login", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );

    var doRegister = () {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        auth
            .register(_name, _username, _password, _confirmPassword)
            .then((response) {
          if (response['status']) {
            Flushbar(
              title: "Registration successfully",
              message: response.toString(),
              duration: Duration(seconds: 10),
            ).show(context);
            Navigator.pushReplacementNamed(context, '/login');
          } else {
            Flushbar(
              title: "Registration Failed",
              message: response.toString(),
              duration: Duration(seconds: 10),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please Complete the form properly",
          duration: Duration(seconds: 10),
        ).show(context);
      }
    };

    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: EdgeInsets.all(40.0),
        child: ListView(
          children: [
            Text(
              "Create an account",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 30.0, color: color),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              "It's quick and easy.",
              style: TextStyle(fontSize: 20.0, color: color),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 15.0),
                  label("Full Name"),
                  SizedBox(height: 5.0),
                  nameField,
                  SizedBox(height: 15.0),
                  label("Email"),
                  SizedBox(height: 5.0),
                  usernameField,
                  SizedBox(height: 15.0),
                  label("Password"),
                  SizedBox(height: 10.0),
                  passwordField,
                  SizedBox(height: 15.0),
                  label("Confirm Password"),
                  SizedBox(height: 10.0),
                  confirmPassword,
                  SizedBox(height: 20.0),
                  auth.loggedInStatus == Status.Authenticating
                      ? loading
                      : longButtons("Sign Up", doRegister),
                  SizedBox(height: 5.0),
                  loginLabel
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
