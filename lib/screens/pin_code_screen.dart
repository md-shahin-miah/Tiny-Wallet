import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview/main.dart';
import 'package:flutter_webview/model/card_model.dart';
import 'package:flutter_webview/static_value.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final bool isForReset;

  PinCodeVerificationScreen(this.isForReset);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();

  // ..text = "123456";

  // StreamController<ErrorAnimationType> errorController;

  bool isAlreadyHave = false;

  bool hasError = false;
  bool isLoading = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer().onTap = () {
      Navigator.pop(context);
    };

    if (!widget.isForReset) {
      SharedPreferences.getInstance().then((value) => getValue(value));
    }

    // errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  void getValue(SharedPreferences value) {
    print(value);
    String passCode = value.getString("passcode") ?? null;

    print('passCode dshdg --------------------------------$passCode');

    if (passCode != null) {
      isAlreadyHave = true;
      StaticValue.PIN = passCode;
      print('isAlreadyHave-------------------------------$isAlreadyHave');
    }

    setState(() {});
  }

  @override
  void dispose() {
    // errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      key: scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                !widget.isForReset
                    ? isAlreadyHave
                        ? 'Enter your pass code'
                        : 'Set your pass code'
                    : 'Set your new pass code',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
            //   child: RichText(
            //     text: TextSpan(
            //         text: "",
            //         children: [
            //           TextSpan(
            //               text: '',
            //               style: TextStyle(
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: 15)),
            //         ],
            //         style: TextStyle(color: Colors.white, fontSize: 15)),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            Form(
              key: formKey,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Container(
                    alignment: Alignment.center,
                    child: PinCodeTextField(
                      pinBoxHeight: 50,
                      pinBoxWidth: MediaQuery.of(context).size.width * .15,
                      highlight: true,
                      highlightColor: Colors.blue,
                      defaultBorderColor: Colors.white,
                      hasTextBorderColor: Colors.green,
                      highlightPinBoxColor: Colors.white,
                      maskCharacter: '*',
                      hideCharacter: true,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      onTextChanged: (value) {
                        currentText = value;

                        if (currentText.length == 4) {
                          setState(() {
                            isLoading = true;
                          });
                          if (widget.isForReset) {
                            setNewPassCode();
                          } else {
                            checkAllValidation();
                          }
                        }
                      },
                      maxLength: 4,
                    ),
                  )),
            ),
            isAlreadyHave
                ? TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LoginScreen(true)));
                    },
                    child: Text(
                      'Forget passcode',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        // decorationStyle: TextDecorationStyle.double,
                      ),
                    ))
                : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                hasError ? "*Please fill up all the cells properly" : "",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[],
            )
          ],
        ),
      ),
    );
  }

  Future<void> checkAllValidation() async {
    if (isAlreadyHave) {
      print('isAlreadyHave called------------------------');
      if (StaticValue.PIN != '') {
        if (StaticValue.PIN == currentText) {
          // setState(() {
          //   isLoading = true;
          // });
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => MyHomePage(0)));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      print('    !isAlreadyHave called------------------------');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('passcode', currentText);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MyHomePage(0)));
      setState(() {
        isLoading = false;
      });
    }

    if (mounted) {
      setState(() {
        hasError = false;
      });
    }
  }

  Future<void> setNewPassCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('passcode', currentText);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => MyHomePage(0)));
    setState(() {
      isLoading = false;
    });

    if (mounted) {
      setState(() {
        hasError = false;
      });
    }
  }
}
