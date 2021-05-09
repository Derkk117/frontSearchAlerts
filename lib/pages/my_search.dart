import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:search_alerts/domain/user.dart';
import 'package:search_alerts/util/widgets.dart';
import 'package:search_alerts/providers/alert_provider.dart';
import 'package:search_alerts/providers/user_provider.dart';
import 'package:search_alerts/providers/search_instance_provider.dart';

class MySearch extends StatefulWidget {
  final int searchId;
  final String searchName;

  MySearch({Key key, @required this.searchId, @required this.searchName})
      : super(key: key);

  @override
  _MySearchState createState() => _MySearchState();
}

class _MySearchState extends State<MySearch> {
  bool exist = false;
  bool activate = false;
  int hours = 0;
  int minutes = 1;
  int alertId = -1;
  bool load = true; //just for read one time snapshot data in futureBuilder.

  Map<String, bool> list = {
    'alert': false,
    'google': false,
    'youtube': false,
    'bing': false,
  };

  List<dynamic> currentPages =
      []; //just for differentiate between updates and storages.

  var loading = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CircularProgressIndicator(),
      Text(" Updating Configuration ... Please wait")
    ],
  );

  Future getAlert(BuildContext context, String token, bool update) async {
    AlertProvider alertP = Provider.of<AlertProvider>(context, listen: false);
    SearchInstanceProvider searchInstance =
        Provider.of<SearchInstanceProvider>(context, listen: false);
    var result = await alertP.getAlertId(widget.searchId, token);
    setState(() {
      alertId = result;
    });

    if (update == false) {
      list.forEach((key, value) {
        if (list[key] == true && key != 'alert') {
          searchInstance.storeSearchInstance(result, token, 1, key);
        }
      });
    } else if (update == true) {
      list.forEach((key, value) {
        if (currentPages
                .indexWhere((element) => element['page_name'].contains(key)) !=
            -1) {
          searchInstance.updateSearchInstance(
              int.parse(currentPages[currentPages.indexWhere(
                  (element) => element['page_name'].contains(key))]['id']),
              token,
              (list[key] == true) ? 1 : 0);
        } else if (key != 'alert' &&
            currentPages.indexWhere(
                    (element) => element['page_name'].contains(key)) ==
                -1) {
          int act = (list[key] == true) ? 1 : 0;
          searchInstance.storeSearchInstance(result, token, act, key);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AlertProvider alertP = Provider.of<AlertProvider>(context);
    // SearchInstanceProvider searchInstance =
    //     Provider.of<SearchInstanceProvider>(context);
    User user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: SideDrawer(),
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(widget.searchName),
      ),
      body: FutureBuilder(
        future: alertP.getAlert(user.token, widget.searchId),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            this.exist = true;
            //draw current data
            if (load == true) {
              if (snapshot.data['activate'] == 1) {
                list['alert'] = true;
              } else if (snapshot.data['activate'] == 1) {
                list['alert'] = false;
              }
              if (snapshot.data['search_instances'].length > 0) {
                this.currentPages = snapshot.data['search_instances'];
                for (int i = 0;
                    i < snapshot.data['search_instances'].length;
                    i++) {
                  list[snapshot.data['search_instances'][i]['page_name']] =
                      (snapshot.data['search_instances'][i]['activate'] == 1)
                          ? true
                          : false;
                }
              }
              if (snapshot.data['schedule'] != null) {
                hours = int.parse(snapshot.data['schedule'].substring(0, 2));
                minutes = int.parse(snapshot.data['schedule'].substring(3, 5));
              }
              this.load = false;
            }
            children = <Widget>[
              Container(
                child: SwitchListTile(
                  title: const Text(
                    'Activate alert',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: list['alert'],
                  activeColor: Colors.lightGreen,
                  inactiveTrackColor: Colors.red,
                  onChanged: (bool value) {
                    setState(() {
                      list['alert'] = value;
                    });
                  },
                  secondary: const Icon(
                    Icons.alarm,
                    color: Colors.white,
                  ),
                ),
                color: Color(0xff063057),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: Center(
                  child: Text(
                    "select which sites you want to enable this recurring search:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/google.png',
                        height: 60,
                        width: 180,
                      ),
                      Checkbox(
                          value: list['google'],
                          activeColor: Colors.green,
                          onChanged: (bool value) {
                            setState(() {
                              list['google'] = value;
                              if (list['alert'] == false && value == true)
                                list['alert'] = true;
                            });
                          })
                    ],
                  ),
                  color: Colors.transparent,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/bing.jpg',
                        height: 60,
                        width: 180,
                      ),
                      Checkbox(
                          value: list['bing'],
                          activeColor: Colors.green,
                          onChanged: (bool value) {
                            setState(() {
                              list['bing'] = value;
                              if (list['alert'] == false && value == true)
                                list['alert'] = true;
                            });
                          })
                    ],
                  ),
                  color: Colors.transparent,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/youtube.png',
                        height: 60,
                        width: 180,
                      ),
                      Checkbox(
                          value: list['youtube'],
                          activeColor: Colors.green,
                          onChanged: (bool value) {
                            setState(() {
                              list['youtube'] = value;
                              if (list['alert'] == false && value == true)
                                list['alert'] = true;
                            });
                          })
                    ],
                  ),
                  color: Colors.transparent,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Slide to set time between updates:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hours:",
                      style: TextStyle(fontSize: 20),
                    ),
                    new NumberPicker(
                      axis: Axis.horizontal,
                      infiniteLoop: true,
                      value: hours,
                      itemWidth: 80,
                      minValue: 0,
                      maxValue: 23,
                      onChanged: (value) => setState(() => hours = value),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Minutes:",
                      style: TextStyle(fontSize: 20),
                    ),
                    new NumberPicker(
                      axis: Axis.horizontal,
                      infiniteLoop: true,
                      value: minutes,
                      itemWidth: 80,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (value) => setState(() => minutes = value),
                    ),
                  ],
                ),
              ),
              Center(
                  child: Container(
                color: Colors.white,
                child: Padding(
                  child: Text(
                    "Current time: " +
                        hours.toString() +
                        ":" +
                        minutes.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  padding: EdgeInsets.all(15),
                ),
              )),
              Center(
                child: Padding(
                    padding: EdgeInsets.all(40),
                    child: alertP.sendingData == Status.SendingData
                        ? loading
                        : longButtons("Save configuration", () {
                            int activate = 0;
                            if (list['alert'] == true &&
                                (list['google'] == true ||
                                    list['bing'] == true ||
                                    list['youtube'] == true)) {
                              setState(() {
                                list['alert'] = true;
                              });
                              activate = 1;
                            } else {
                              setState(() {
                                list['alert'] = false;
                              });
                              activate = 0;
                            }
                            alertP.updateAlert(widget.searchId, user.token,
                                activate, hours, minutes);
                            getAlert(context, user.token, true);
                            Flushbar(
                              title: "Data stored Succesfully",
                              message: "Done!",
                              duration: Duration(seconds: 5),
                            ).show(context);
                          })),
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              Container(
                child: SwitchListTile(
                  title: const Text(
                    'Activate alert',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: list['alert'],
                  activeColor: Colors.lightGreen,
                  inactiveTrackColor: Colors.red,
                  onChanged: (bool value) {
                    setState(() {
                      list['alert'] = value;
                    });
                  },
                  secondary: const Icon(
                    Icons.alarm,
                    color: Colors.white,
                  ),
                ),
                color: Color(0xff063057),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: Center(
                  child: Text(
                    "select which sites you want to enable this recurring search:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/google.png',
                        height: 60,
                        width: 180,
                      ),
                      Checkbox(
                          value: list['google'],
                          activeColor: Colors.green,
                          onChanged: (bool value) {
                            setState(() {
                              list['google'] = value;
                              if (list['alert'] == false) list['alert'] = true;
                            });
                          })
                    ],
                  ),
                  color: Colors.transparent,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/bing.jpg',
                        height: 60,
                        width: 180,
                      ),
                      Checkbox(
                          value: list['bing'],
                          activeColor: Colors.green,
                          onChanged: (bool value) {
                            setState(() {
                              list['bing'] = value;
                              if (list['alert'] == false) list['alert'] = true;
                            });
                          })
                    ],
                  ),
                  color: Colors.transparent,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/youtube.png',
                        height: 60,
                        width: 180,
                      ),
                      Checkbox(
                          value: list['youtube'],
                          activeColor: Colors.green,
                          onChanged: (bool value) {
                            setState(() {
                              list['youtube'] = value;
                              if (list['alert'] == false) list['alert'] = true;
                            });
                          })
                    ],
                  ),
                  color: Colors.transparent,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Slide to set time between updates:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hours:",
                      style: TextStyle(fontSize: 20),
                    ),
                    new NumberPicker(
                      axis: Axis.horizontal,
                      infiniteLoop: true,
                      value: hours,
                      itemWidth: 80,
                      minValue: 0,
                      maxValue: 23,
                      onChanged: (value) => setState(() => hours = value),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Minutes:",
                      style: TextStyle(fontSize: 20),
                    ),
                    new NumberPicker(
                      axis: Axis.horizontal,
                      infiniteLoop: true,
                      value: minutes,
                      itemWidth: 80,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (value) => setState(() => minutes = value),
                    ),
                  ],
                ),
              ),
              Center(
                  child: Container(
                color: Colors.white,
                child: Padding(
                  child: Text(
                    "Current time: " +
                        hours.toString() +
                        ":" +
                        minutes.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  padding: EdgeInsets.all(15),
                ),
              )),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: alertP.sendingData == Status.SendingData
                      ? loading
                      : longButtons("Save configuration", () {
                          if ((list['google'] == true ||
                                  list['bing'] == true ||
                                  list['youtube'] == true) &&
                              list['alert'] == true) {
                            alertP.storeAlert(
                                widget.searchId, user.token, 1, hours, minutes);
                            getAlert(context, user.token,
                                false); //also send search instances
                            Flushbar(
                              title: "Data stored Succesfully",
                              message: "Done!",
                              duration: Duration(seconds: 5),
                            ).show(context);
                          } else {
                            Flushbar(
                              title: "Failed",
                              message:
                                  "Te alert must be activated and at least one site marked",
                              duration: Duration(seconds: 5),
                            ).show(context);
                          }
                        }),
                ),
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
    );
  }
}
