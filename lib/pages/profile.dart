import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:search_alerts/domain/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:search_alerts/util/app_url.dart';
import 'package:search_alerts/util/widgets.dart';
import 'package:search_alerts/util/validators.dart';
import 'package:search_alerts/providers/user_provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = new GlobalKey<FormState>();

  final _nameC = TextEditingController();
  final _emailC = TextEditingController();

  File _imageFile;
  String _email, _name;

  @override
  Widget build(BuildContext context) {
    UserProvider update = Provider.of<UserProvider>(context);
    User user = Provider.of<UserProvider>(context).user;

    this._nameC.text = user.name;
    this._emailC.text = user.email;

    final nameField = TextFormField(
      autofocus: false,
      controller: _nameC,
      validator: (value) =>
          value.isEmpty ? "Please enter your full name" : null,
      onSaved: (value) => _name = value,
      decoration: buildInputDecoration("Confirm password", Icons.person),
    );

    final usernameField = TextFormField(
      autofocus: false,
      controller: _emailC,
      validator: validateEmail,
      onSaved: (value) => _email = value,
      decoration: buildInputDecoration("Confirm password", Icons.email),
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
        if (_imageFile != null) {
          setState(() {
            user.email = _email;
            user.name = _name;
          });
          update.update(_email, _name, image: _imageFile.path).then((response) {
            if (response['status']) {
              Flushbar(
                title: "Registration successfully",
                message: response.toString(),
                duration: Duration(seconds: 10),
              ).show(context);
              Navigator.pushReplacementNamed(context, '/profile');
            } else {
              Flushbar(
                title: "Update Failed",
                message: response.toString(),
                duration: Duration(seconds: 10),
              ).show(context);
            }
          });
        } else {
          setState(() {
            user.email = _email;
            user.name = _name;
          });
          update.update(_email, _name).then((response) {
            if (response['status']) {
              Flushbar(
                title: "Registration successfully",
                message: response.toString(),
                duration: Duration(seconds: 10),
              ).show(context);
              Navigator.pushReplacementNamed(context, '/profile');
            } else {
              Flushbar(
                title: "Update Failed",
                message: response.toString(),
                duration: Duration(seconds: 10),
              ).show(context);
            }
          });
        }
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
            resizeToAvoidBottomInset: true,
            drawer: SideDrawer(),
            backgroundColor: Colors.grey[300],
            appBar: AppBar(title: Text("Profile")),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: ListView(
                  children: [
                    (user.image != null && _imageFile == null)
                        ? Container(
                            height: 150,
                            child: ConstrainedBox(
                                constraints: BoxConstraints.expand(),
                                child: TextButton(
                                    onPressed: () {
                                      _pickImage(ImageSource.gallery);
                                    },
                                    child: Image.network(
                                      AppUrl.userImage + user.image,
                                      height: 150,
                                    ))))
                        : Container(
                            height: 150,
                            child: ConstrainedBox(
                                constraints: BoxConstraints.expand(),
                                child: TextButton(
                                    onPressed: () {
                                      _pickImage(ImageSource.gallery);
                                    },
                                    child: (_imageFile.path != null)
                                        ? Image.file(_imageFile, height: 150)
                                        : Image.asset("assets/images/user.png",
                                            height: 150)))),
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
                          SizedBox(height: 20.0),
                          update.userStatus == UserStatus.Updating
                              ? loading
                              : longButtons("Update", doUpdate),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  Future<void> _pickImage(ImageSource source) async {
    PickedFile selected = await ImagePicker().getImage(source: source);

    setState(() {
      _imageFile = File(selected.path);
    });
  }
}
