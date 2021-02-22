import 'package:Search_Alerts/MyColor.dart';
import 'package:Search_Alerts/Screens/Wrapper.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'delayed_animation.dart';
import 'package:flutter/services.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    _scale = 1 - _controller.value;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('Assets/Images/Bubble_bg.png'),
                  fit: BoxFit.cover)),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  children: <Widget>[
                    AvatarGlow(
                      endRadius: 100,
                      duration: Duration(seconds: 2),
                      glowColor: Colors.blue,
                      repeat: true,
                      repeatPauseDuration: Duration(seconds: 2),
                      startDelay: Duration(seconds: 1),
                      child: Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            child: ClipRRect(
                              child: Image.asset(
                                'Assets/Images/Stick_logo.png',
                              ),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            /*child: Image.asset("assets/Images/background.png"),*/
                            radius: 70.0,
                          )),
                    ),
                    DelayedAnimation(
                      child: Text(
                        "Welcome to",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35.0,
                          shadows: [
                            Shadow(
                              blurRadius: 1.0,
                              color: createMaterialColor(Color(0xFF4079E0)),
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                          color: color,
                        ),
                      ),
                      delay: delayedAmount + 1000,
                    ),
                    DelayedAnimation(
                      child: Text(
                        "StickBox",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                            shadows: [
                              Shadow(
                                blurRadius: 1.0,
                                color: createMaterialColor(Color(0xFF4079E0)),
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                            color: color),
                      ),
                      delay: delayedAmount + 2000,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    DelayedAnimation(
                      child: Text(
                        "All your stickers in a safe place",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: color,
                          shadows: [
                            Shadow(
                              blurRadius: 1.0,
                              color: createMaterialColor(Color(0xFF4079E0)),
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      delay: delayedAmount + 3000,
                    ),
                    DelayedAnimation(
                      child: Text(
                        "no matters if you change your device.",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: color,
                          shadows: [
                            Shadow(
                              blurRadius: 1.0,
                              color: createMaterialColor(Color(0xFF4079E0)),
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      delay: delayedAmount + 3000,
                    ),
                    SizedBox(
                      height: 100.0,
                    ),
                    DelayedAnimation(
                      child: GestureDetector(
                        onTapDown: _goToLogIn,
                        onTapUp: _clear,
                        child: Transform.scale(
                          scale: _scale,
                          child: _animatedButtonUI,
                        ),
                      ),
                      delay: delayedAmount + 4000,
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                  ],
                ),
              )),
        ));
  }

  Widget get _animatedButtonUI => Container(
        height: 60,
        width: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            'Continue',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: createMaterialColor(Color(0xFF4079E0)),
            ),
          ),
        ),
      );

  void _goToLogIn(TapDownDetails details) {
    _controller.forward();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Wrapper()),
    );
  }

  void _clear(TapUpDetails details) {
    _controller.reverse();
  }
}
