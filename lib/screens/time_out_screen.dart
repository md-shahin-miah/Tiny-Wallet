
import 'package:flutter/material.dart';
import 'package:flutter_webview/screens/transaction_screen.dart';

import '../main.dart';
import '../static_value.dart';
class TimeOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 8,
            ),
            Icon(Icons.error_rounded,
                size: MediaQuery.of(context).size.height / 6,
                color: Color(int.parse(StaticValue.COLOR_CANCEL))),
            SizedBox(
              height: 20,
            ),
            Text(
              'Timeout',
              style: TextStyle(
                  fontSize: 24,
                  color: Color(
                      int.parse(StaticValue.COLOR_PAYMENT_TITLE))),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Something went wrong, please try again!',
              style: TextStyle(
                  fontSize: 16,
                  color: Color(
                      int.parse(StaticValue.COLOR_PAYMENT_TITLE))),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => MyHomePage(0)));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  side: BorderSide(color: Colors.red)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Text(
                  'Try again',
                  style: TextStyle(color: Colors.red, fontSize: 24),
                ),
              ),
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TransactionPage()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  side: BorderSide(color: Colors.deepOrangeAccent)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Text(
                  'View transactions',
                  style: TextStyle(
                      color: Colors.deepOrangeAccent, fontSize: 24),
                ),
              ),
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
