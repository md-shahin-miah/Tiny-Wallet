import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview/main.dart';
import 'package:flutter_webview/screens/information_screen.dart';
import 'package:flutter_webview/screens/pin_code_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'login_screen.dart';
import '../main.dart';
import '../main.dart';
import '../static_value.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) => navigate(value));
  }

  void navigate(SharedPreferences value) {
    print(value);
    StaticValue.signature = value.getString("signature")??'';
    StaticValue.merchantId = value.getString("merchantId")??'';

    StaticValue.ownersName = value.getString("ownersname")??'';
    StaticValue.address = value.getString("address")??'';
    StaticValue.postCode = value.getString("postcode")??'';
    StaticValue.emailAddress = value.getString("emailaddress")??'';
    StaticValue.phoneNumber = value.getString("phonenumber")??'';

    print(StaticValue.signature);
    print(StaticValue.merchantId);

    Timer(Duration(seconds: 2), () {
      if (StaticValue.signature.isNotEmpty && StaticValue.merchantId.isNotEmpty) {
      // &&
         if(StaticValue.ownersName.isEmpty&&StaticValue.address.isEmpty&&StaticValue.postCode.isEmpty&&StaticValue.emailAddress.isEmpty&&StaticValue.phoneNumber.isEmpty) {
           Navigator.pushReplacement(context,
               MaterialPageRoute(
                   builder: (_) => InformationScreen()));
         }
        else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => PinCodeVerificationScreen(false)));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen(false)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/logo.png',
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Merchant Wallet',
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            CircularProgressIndicator()
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Powered by OrderVox'),
            SizedBox(
              height: 50,
            )
          ],
        ));
  }
}
