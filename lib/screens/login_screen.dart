import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview/providers/login_provider.dart';
import 'package:flutter_webview/screens/information_screen.dart';
import 'package:flutter_webview/screens/pin_code_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  static final String path = "lib/src/pages/login/login7.dart";
  final bool isFromForget;

  LoginScreen(this.isFromForget);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String email = '';
  String password = '';
  bool isLoading = false;


  bool _obscureText = true;


  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  @override
  Widget build(BuildContext context) {
    final providerLogin = Provider.of<LoginProvider>(context);

    final heightClipper=MediaQuery.of(context).size.height*0.45;



    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipper2(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: heightClipper,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0x22ff3a5a), Color(0x22fe494d)])),
                ),
              ),
              ClipPath(
                clipper: WaveClipper3(),
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: heightClipper,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0x44ff3a5a), Color(0x44fe494d)])),
                ),
              ),
              ClipPath(
                clipper: WaveClipper1(),
                child: Container(

                  child: Center(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.wallet_membership,
                          color: Colors.white,
                          size: 50,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Wallet Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 30),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  width: double.infinity,
                  height: heightClipper,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.deepOrange,
                    Colors.deepOrangeAccent
                  ])),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                onChanged: (String value) {
                  email = value;
                },
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.email,
                        color: Colors.deepOrange,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                obscureText: _obscureText,
                onChanged: (String value) {
                  password = value;
                },
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.lock,
                        color: Colors.deepOrange,
                      ),
                    ),
                    suffixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: InkWell(
                          onTap: (){
                            _toggle();
                          },
                          child: _obscureText? Icon(
                            Icons.remove_red_eye,
                            color: Colors.deepOrange,
                          ):Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.deepOrange,
                          )
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.deepOrange),
                    child: FlatButton(
                      child: Text(
                        widget.isFromForget ? 'Submit' : "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      onPressed: () async {
                        if (widget.isFromForget) {
                          if (email.isEmpty || password.isEmpty) {
                            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                content: new Text(
                                    "Please provide your email and password")));
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          final response = await providerLogin.loginDataSave(
                              email, password);

                          if (response != "failed") {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        PinCodeVerificationScreen(true)));
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                content: new Text(
                                    "Something went wrong. Please try again.")));
                          }
                        } else {
                          if (email.isEmpty || password.isEmpty) {
                            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                content: new Text(
                                    "Please provide your email and password")));
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          final response = await providerLogin.loginDataSave(
                              email, password);

                          print(
                              'response login---------------------------------${response}');
                          if (response != '\"failed\"') {
                            Map<String, dynamic> jsonData =
                                jsonDecode(response);

                            String merchantId = jsonData['merchant_id'];
                            String signature = jsonData['signature'];
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString('merchantId', merchantId);
                            await prefs.setString('signature', signature);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => InformationScreen()));
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                content: new Text(
                                    "Something went wrong. Please try again.")));
                          }
                        }
                      },
                    ),
                  )),
        ],
      ),
    );
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
