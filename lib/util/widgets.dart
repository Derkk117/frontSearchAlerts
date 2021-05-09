import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_alerts/domain/user.dart';
import 'package:search_alerts/util/app_url.dart';
import 'package:search_alerts/util/shared_preference.dart';
import 'package:search_alerts/providers/user_provider.dart';

MaterialButton longButtons(String title, Function fun,
    {Color color: const Color(0xff063057), Color textColor: Colors.white}) {
  return MaterialButton(
    onPressed: fun,
    textColor: textColor,
    color: color,
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    ),
    height: 45,
    minWidth: 600,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
  );
}

MaterialButton DeleteButtons(String title, Function fun,
    {Color color: const Color(0xffCC0000), Color textColor: Colors.white}) {
  return MaterialButton(
    onPressed: fun,
    textColor: textColor,
    color: color,
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    ),
    height: 45,
    minWidth: 600,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
  );
}

label(String title) => Text(title);

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: Color.fromRGBO(50, 62, 72, 1.0)),
    // hintText: hintText,
    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 220,
            child: DrawerHeader(
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: (user.image != null)
                          ? Image.network(
                              AppUrl.userImage + user.image,
                              height: 100,
                            )
                          : Image.asset(
                              "assets/images/user.png",
                              height: 100,
                            )),
                  Center(
                    child: Text(
                      user.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(40)),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Something to search?'), //Dashboard page
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text('My Searches'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/searches');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.campaign_rounded),
                  title: Text('My Alerts'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/alerts');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configuration'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () {
                    UserPreferences().removeUser();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
