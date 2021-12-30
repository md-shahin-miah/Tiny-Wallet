import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview/main.dart';
import 'package:flutter_webview/model/card_model.dart';
import 'package:flutter_webview/screens/transaction_screen.dart';
import 'package:flutter_webview/static_value.dart';

import 'package:flutter_webview/validator/payment_card.dart';
import 'package:intl/intl.dart';
import 'package:async/async.dart';

import 'time_out_screen.dart';

class MyWebView extends StatefulWidget {
  final PaymentCard _paymentCard;
  final amount;

  MyWebView(this._paymentCard, this.amount);

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  InAppWebViewController _webViewController;

  String base_url = "https://superadmin.ordere.co.uk/api/wallet";

  double progress = 0;

  String date = DateFormat('ymdhms').format(DateTime.now());

  bool isError = false;
  bool isCancel = false;
  bool isLoading = false;
  bool isSuccess = false;
  int loadCount = 0;
  int countTime = 0;

  int counter = 0;

  String dot = '';
  Timer timer;
  String js =
      "document.querySelector('meta[name=\"viewport\"]').setAttribute('content', 'width=1024px, initial-scale=' + (document.documentElement.clientWidth / 1024));";

  String url = '';

  @override
  void initState() {


    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => starTimer());

    String info =
        '${widget._paymentCard.number}__${widget._paymentCard.cvv}__${widget._paymentCard.month}/${widget._paymentCard.year}__${widget.amount}__${StaticValue.signature}__${StaticValue.merchantId}__$date __${StaticValue.ownersName}__${StaticValue.address}__${StaticValue.postCode}__${StaticValue.phoneNumber}__${StaticValue.emailAddress}';

    print(info);
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    String encoded = stringToBase64Url.encode(info);

    url = '$base_url?fields=$encoded';

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // if(isCancel){
    //   timer.cancel();
    // }
    // if(isSuccess){
    //   timer.cancel();
    // }
    return SafeArea(
      child: Scaffold(
        body: Container(
            child: Stack(children: <Widget>[
          Container(
              child: InAppWebView(
            initialUrl: url,
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
              preferredContentMode: UserPreferredContentMode.DESKTOP,
              javaScriptEnabled: true,
              debuggingEnabled: true,
            )),
            onWebViewCreated: (InAppWebViewController controller) {
              print('webview created');
              _webViewController = controller;

              _webViewController.evaluateJavascript(source: js);
              isLoading = true;
            },
            onLoadStart: (InAppWebViewController controller, String url) {
              print('onloadstart');
              print('url :$url');

              setState(() {
                this.url = url;
                loadCount++;

                String status;

                if (url.endsWith('cancel')) {
                  timer.cancel();
                  isCancel = true;
                  isLoading = false;
                  status = 'failed';
                  String cardNo = widget._paymentCard.number;

                  String cardNoNew = '';

                  for (int i = 0; i < cardNo.length; i++) {
                    print(' card number ${cardNo[i]}');
                    if (i < 4) {
                      cardNoNew += cardNo[i];
                    } else if (i > cardNo.length - 5) {
                      cardNoNew += cardNo[i];
                    } else {
                      cardNoNew += '*';
                    }
                  }

                  print('card new value failed  ---------$cardNoNew');

                  CardModel().storePaymentInfo(
                      '${widget.amount}',
                      cardNoNew,
                      '${widget._paymentCard.cvv}',
                      '${widget._paymentCard.month}/${widget._paymentCard.year}',
                      date,
                      StaticValue.merchantId,
                      status);
                } else if (url.endsWith("notify")) {
                  timer.cancel();
                  isSuccess = true;
                  isLoading = false;
                  status = 'success';

                  String cardNo = widget._paymentCard.number;

                  String cardNoNew = '';

                  for (int i = 0; i < cardNo.length; i++) {
                    print(' card number ${cardNo[i]}');
                    if (i < 4) {
                      cardNoNew += cardNo[i];
                    } else if (i > cardNo.length - 5) {
                      cardNoNew += cardNo[i];
                    } else {
                      cardNoNew += '*';
                    }
                  }

                  print('card new value success ---------$cardNoNew');

                  CardModel().storePaymentInfo(
                      '${widget.amount}',
                      cardNoNew,
                      '${widget._paymentCard.cvv}',
                      '${widget._paymentCard.month}/${widget._paymentCard.year}',
                      date,
                      StaticValue.merchantId,
                      status);
                }
              });
            },
            onLoadStop: (InAppWebViewController controller, String url) async {
              setState(() {
                this.url = url;
              });
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                this.progress = progress / 100;
                if (this.progress < 1) {
                  _webViewController.evaluateJavascript(source: js);
                  _webViewController
                      .evaluateJavascript(source: '''function doClick(){
                  
                  document.getElementById('paybttn').click();
              
              
              }
              doClick();
              
               ''');
                }
              });
            },
          )),
          isCancel
              ? Container(
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
                        'Payment Failed',
                        style: TextStyle(
                            fontSize: 24,
                            color: Color(
                                int.parse(StaticValue.COLOR_PAYMENT_TITLE))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'It seems like we have not received money.',
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
                )
              : Container(),
          isSuccess
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/tik.PNG',
                        width: 120.0,
                        // color: Colors.grey[600],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Payment Success',
                        style: TextStyle(
                            fontSize: 24,
                            color: Color(
                                int.parse(StaticValue.COLOR_PAYMENT_TITLE))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Payment received thanks.',
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
                              MaterialPageRoute(builder: (_) => MyHomePage(2)));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            side: BorderSide(color: Colors.green)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(
                            'New transaction',
                            style: TextStyle(color: Colors.green, fontSize: 24),
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
                )
              : Container(),
          isLoading
              ? Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loadCount == 3
                          ? Container(
                              height: 300,
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 64, horizontal: 32),
                                  child: Image.asset(
                                    'assets/images/wallet/w3.png',
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                  ),
                                ),
                              ),
                            )
                          : loadCount == 2
                              ? Container(
                                  height: 300,
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 32),
                                      child: Image.asset(
                                          'assets/images/wallet/w2.png',
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 300,
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 64, horizontal: 32),
                                      child: Image.asset(
                                          'assets/images/wallet/w1.png',
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4),
                                    ),
                                  ),
                                ),
                      SizedBox(
                        height: 12,
                      ),
                      loadCount == 3
                          ? Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                      // alignment: Alignment.bottomLeft,
                                      // child: Text(
                                      //   '$dot',
                                      //   style: TextStyle(fontSize: 20),
                                      // ),
                                      ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.topRight,
                                    child: FittedBox(
                                      child: Text(
                                        'Finalizing payment',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      '$dot',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : loadCount == 2
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          // alignment: Alignment.bottomLeft,
                                          // child: Text(
                                          //   '$dot',
                                          //   style: TextStyle(fontSize: 20),
                                          // ),
                                          ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        alignment: Alignment.topRight,
                                        child: FittedBox(
                                          child: Text(
                                            'Processing information',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          '$dot',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),

                                    // Text('Processing information',
                                    //     style: TextStyle(fontSize: 20)),
                                    // Text('$dot',
                                    //     style: TextStyle(fontSize: 20)),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          // alignment: Alignment.bottomLeft,
                                          // child: Text(
                                          //   '$dot',
                                          //   style: TextStyle(fontSize: 20),
                                          // ),
                                          ),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        alignment: Alignment.topRight,
                                        child: FittedBox(
                                          child: Text(
                                            'Validating information',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          '$dot',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),

                                    // Text('Validating information',
                                    //     style: TextStyle(fontSize: 20)),
                                    // Text('$dot',
                                    //     style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                      SizedBox(
                        height: 32,
                      ),
                      // CircularProgressIndicator(),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 2,
                              width:
                                  MediaQuery.of(context).size.width * 1.4 / 7,
                              color: Colors.green,
                            ),
                            loadCount == 1
                                ? Container(
                                    height: 21,
                                    width: 21,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 21,
                                          width: 21,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: 21,
                                    width: 21,
                                    decoration: BoxDecoration(
                                      color: loadCount > 0
                                          ? Colors.green
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                            Container(
                              height: 2,
                              width:
                                  MediaQuery.of(context).size.width * 1.4 / 7,
                              color: loadCount > 1 ? Colors.green : Colors.grey,
                            ),
                            loadCount == 2
                                ? Container(
                                    height: 21,
                                    width: 21,
                                    child: Stack(
                                      children: [
                                        Container(
                                          // height: 21,
                                          // width: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: 21,
                                    width: 21,
                                    decoration: BoxDecoration(
                                      color: loadCount > 1
                                          ? Colors.green
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                            Container(
                              height: 2,
                              width:
                                  MediaQuery.of(context).size.width * 1.4 / 7,
                              color: loadCount > 2 ? Colors.green : Colors.grey,
                            ),
                            loadCount == 3
                                ? Container(
                                    height: 21,
                                    width: 21,
                                    child: Stack(
                                      children: [
                                        Container(
                                          // height: 20,
                                          // width: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: 21,
                                    width: 21,
                                    decoration: BoxDecoration(
                                      color: loadCount > 2
                                          ? Colors.green
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                            Container(
                              height: 2,
                              width:
                                  MediaQuery.of(context).size.width * 1.4 / 7,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
        ])),
      ),
    );
  }

  starTimer() {
    counter++;
    countTime++;
    print('countTime fgdg----------------------------$countTime');

    if(countTime==60){
      print('isCancel&&!isSuccess ----------------------------$isCancel----$isSuccess');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>TimeOutScreen()));

    }

    print('counter ----------------------------$counter');

    if (counter > 3) {
      counter = 0;
    }

    if (counter == 1) {
      dot = '.';
    }
    if (counter == 2) {
      dot = '..';
    }
    if (counter == 3) {
      dot = '...';
    }

    setState(() {});
  }
}
