import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/U%20S%20E%20R/flutterprojects/wallet/lib/screens/login_screen.dart';
import 'file:///C:/Users/U%20S%20E%20R/flutterprojects/wallet/lib/screens/mywebveiw.dart';
import 'package:flutter_webview/providers/input_provider.dart';
import 'package:flutter_webview/providers/login_provider.dart';
import 'package:flutter_webview/screens/information_screen.dart';
import 'package:flutter_webview/screens/transaction_screen.dart';
import 'package:flutter_webview/screens/validator_main.dart';
import 'package:flutter_webview/static_value.dart';
import 'package:flutter_webview/validator/payment_card.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';

import 'screens/splash_screen.dart';

void main(){


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => InputProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginProvider(),
        )
      ],
      child: MaterialApp(
        title: 'OrderE Wallet',
        theme: ThemeData().copyWith(
            primaryColor: Colors.deepOrange, accentColor: Colors.deepOrange),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {ValidatorPage.VALIDATOR_PAGE: (context) => ValidatorPage()},
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  int finish = 0;

  String s;
  String m='';


  MyHomePage(this.finish);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState

    SharedPreferences.getInstance().then((value) => navigate(value));
    super.initState();
  }
  void navigate(SharedPreferences value) {
    print(value);

      StaticValue.ownersName = value.getString("ownersname");
      StaticValue.address = value.getString("address");
      StaticValue.postCode = value.getString("postcode");
      StaticValue.emailAddress = value.getString("emailaddress");
      StaticValue.phoneNumber = value.getString("phonenumber");
      StaticValue.signature = value.getString("signature");
      StaticValue.merchantId = value.getString("merchantId");



    print('s----------------${widget.s}');
    print('m----------------${widget.m}');
    // print(StaticValue.merchantId);


  }

  @override
  Widget build(BuildContext context) {
    final inputProvider = Provider.of<InputProvider>(context);
    String colorCustom = '0xff' + '18202e';
    String colorCardView = '0xff' + 'ffffff';
    String colorCardView1 = '0xff' + 'eef1f6';

    if (widget.finish == 2) {
      inputProvider.allDelete();

    }
    widget.finish = 0;

    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 50,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Merchant Wallet',
                    style: TextStyle(fontSize: 24, color: Colors.deepOrange),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
            ),
            ListTile(
              title: Text('Transactions'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => TransactionPage()));

                // Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: Text('About us'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                _launchURL('https://ordervox.co.uk/index.php/privacy-policy');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Privacy policy'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                _launchURL('https://ordervox.co.uk/index.php/privacy-policy');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Color(int.parse(colorCardView1)),
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Merchant Wallet',
        ),
        backgroundColor: Colors.deepOrange,
        elevation: 8,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  color: Colors.deepOrange,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ENTER AMOUNT',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 2),
                            child: Text(
                              ' £ ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 26),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                inputProvider.getAmount,
                                style: TextStyle(
                                    fontSize: 46.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 1.2 / 5,
                                child: Card(
                                    elevation: 4,
                                    color: Color(int.parse(colorCardView)),
                                    child: InkWell(
                                      onTap: () {
                                        inputProvider.addAmount('1');
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text('1',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    )),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 1.2 / 5,
                                child: Card(
                                    elevation: 4,
                                    color: Color(int.parse(colorCardView)),
                                    child: InkWell(
                                      onTap: () {
                                        inputProvider.addAmount('2');
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text('2',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    )),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 1.2 / 5,
                                child: Card(
                                    elevation: 4,
                                    color: Color(int.parse(colorCardView)),
                                    child: InkWell(
                                      onTap: () {
                                        inputProvider.addAmount('3');
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text('3',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    )),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 1.2 / 5,
                                child: Card(
                                    elevation: 4,
                                    color: Color(int.parse(colorCardView)),
                                    child: InkWell(
                                      onTap: () {
                                        inputProvider.allDelete();
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.cancel,
                                            size: 32,
                                          )),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 1.2 / 5,
                                child: Card(
                                    elevation: 4,
                                    color: Color(int.parse(colorCardView)),
                                    child: InkWell(
                                      onTap: () {
                                        inputProvider.addAmount('4');
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text('4',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    )),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 1.2 / 5,
                                child: Card(
                                    elevation: 4,
                                    color: Color(int.parse(colorCardView)),
                                    child: InkWell(
                                      onTap: () {
                                        inputProvider.addAmount('5');
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text('5',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    )),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 1.2 / 5,
                                child: Card(
                                    elevation: 4,
                                    color: Color(int.parse(colorCardView)),
                                    child: InkWell(
                                      onTap: () {
                                        inputProvider.addAmount('6');
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text('6',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    )),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 1.2 / 5,
                                child: Card(
                                    elevation: 4,
                                    color: Color(int.parse(colorCardView)),
                                    child: InkWell(
                                      onTap: () {
                                        inputProvider.deleteAmount();
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.backspace,
                                            size: 32,
                                          )),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 1.2 / 5,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Card(
                                        elevation: 4,
                                        color: Color(int.parse(colorCardView)),
                                        child: InkWell(
                                          onTap: () {
                                            inputProvider.addAmount('7');
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              child: Text('7',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        )),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 1.2 / 5,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Card(
                                        elevation: 4,
                                        color: Color(int.parse(colorCardView)),
                                        child: InkWell(
                                          onTap: () {
                                            inputProvider.addAmount('8');
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              child: Text('8',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        )),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Card(
                                        elevation: 4,
                                        color: Color(int.parse(colorCardView)),
                                        child: InkWell(
                                          onTap: () {
                                            inputProvider.addAmount('0');
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              child: Text('0',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 1.2 / 5,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Card(
                                        elevation: 4,
                                        color: Color(int.parse(colorCardView)),
                                        child: InkWell(
                                          onTap: () {
                                            inputProvider.addAmount('9');
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              child: Text('9',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        )),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                        // onTap: (){
                                        //
                                        //   inputProvider.addAmount('.');
                                        //
                                        // },
                                        // child: Card(child: Container(
                                        //     alignment: Alignment.center,
                                        //     child: Text('.',style: TextStyle(fontWeight:  FontWeight.bold),))),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 1.2 / 5,
                              child: Card(
                                  elevation: 4,
                                  color: Color(int.parse(colorCardView)),
                                  child: InkWell(
                                    onTap: () {
                                      double val =
                                          inputProvider.getAmountInDouble;
                                      print('valuesssss  ${val.toString()}');

                                      if (val > 0.00) {
                                        Navigator.pushNamed(context,
                                            ValidatorPage.VALIDATOR_PAGE);
                                      } else {
                                        _showInSnackBar('Amount is required!');
                                      }
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.assignment_turned_in_outlined,
                                          size: 42,
                                          color: (inputProvider
                                                      .getAmountInDouble) >
                                                  0.00
                                              ? Colors.green[600]
                                              : Colors.black,
                                        )),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 3),
    ));
  }
}
