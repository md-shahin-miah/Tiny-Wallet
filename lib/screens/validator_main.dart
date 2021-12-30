import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'file:///C:/Users/U%20S%20E%20R/flutterprojects/wallet/lib/screens/mywebveiw.dart';
import 'package:flutter_webview/providers/input_provider.dart';
import 'package:flutter_webview/validator/input_formatters.dart';
import 'package:flutter_webview/validator/my_strings.dart';
import 'package:flutter_webview/validator/payment_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../static_value.dart';

class ValidatorPage extends StatefulWidget {
  // ValidatorPage({Key key, this.title}) : super(key: key);
  final String title='Information';
  static const VALIDATOR_PAGE = '/validator';
  @override
  _ValidatorPageState createState() =>   _ValidatorPageState();
}

class _ValidatorPageState extends State<ValidatorPage> {
  var _scaffoldKey =   GlobalKey<ScaffoldState>();
  var _formKey =   GlobalKey<FormState>();
  var numberController =   TextEditingController();
  var _paymentCard = PaymentCard();
  var _autoValidate = false;


  final _card = PaymentCard();

  @override
  void initState() {
    super.initState();
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
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

  }
  @override
  Widget build(BuildContext context) {
    String colorCustom = '0xff' + '18202e';
    final providerData = Provider.of<InputProvider>(context);

    final heightOfClipper = MediaQuery.of(context).size.height * 1.5 / 4;
    final heightOfClipper1 = MediaQuery.of(context).size.height * 1.5 / 4;



    return   Scaffold(

      backgroundColor: Colors.grey[200],
        key: _scaffoldKey,
        appBar:   AppBar(
          title:   Text(widget.title),
          backgroundColor: Colors.deepOrange,
        ),
        body:   Container(

          child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child:   ListView(
                children: <Widget>[
                  Stack(
                    children: [
                      ClipPath(
                        clipper: WaveClipper3(),
                        child: Container(
                          child: Column(),
                          width: double.infinity,
                          height: heightOfClipper1,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0x44ff3a5a), Color(0x44fe494d)])),
                        ),
                      ),
                      ClipPath(
                        clipper: WaveClipper2(),
                        child: Container(
                          child: Column(),
                          width: double.infinity,
                          height: heightOfClipper1,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0x44ff3a5a), Color(0x44fe494d)])),
                        ),
                      ),
                     ClipPath(
                        clipper: WaveClipper1(),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Column(
                              children: <Widget>[

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '£ ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 26),
                                    ),
                                    Text(
                                      providerData.getAmount,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 40),
                                    ),

                                  ],
                                ),
                                Text(
                                  "TOTAL AMOUNT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          width: double.infinity,
                          height: heightOfClipper,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.deepOrange,
                                Colors.deepOrange
                              ])),
                        ),
                      ),
                    ],

                  ),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(19),
                                CardNumberInputFormatter()
                              ],
                              controller: numberController,
                              decoration:   InputDecoration(
                                border: InputBorder.none,
                                icon: CardUtils.getCardIcon(_paymentCard.type),
                                hintText: 'What number is written on card?',
                                labelText: 'Number',
                              ),
                              onSaved: (String value) {

                                _paymentCard.number = CardUtils.getCleanedNumber(value);
                              },
                              validator: CardUtils.validateCardNum,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: TextFormField(
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    decoration:  InputDecoration(
                                      border: InputBorder.none,
                                      icon:   Image.asset(
                                        'assets/images/card_cvv.png',
                                        width: 24.0,
                                        color: Colors.grey[600],
                                      ),
                                      hintText: 'Number behind the card',
                                      labelText: 'CVV',
                                    ),
                                    validator: CardUtils.validateCVV,
                                    keyboardType: TextInputType.number,
                                    onSaved: (value) {
                                      _paymentCard.cvv = int.parse(value);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: TextFormField(
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                      CardMonthInputFormatter()
                                    ],
                                    decoration:   InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(Icons.calendar_today_outlined),
                                      // Image.asset(
                                      //   'assets/images/calender.png',
                                      //   width: 26.0,
                                      //   color: Colors.grey[600],
                                      // ),
                                      hintText: 'MM/YY',
                                      labelText: 'Expiry Date',
                                    ),
                                    validator: CardUtils.validateDate,
                                    keyboardType: TextInputType.number,
                                    onSaved: (value) {
                                      List<int> expiryDate = CardUtils.getExpiryDate(value);
                                      _paymentCard.month = expiryDate[0];
                                      _paymentCard.year = expiryDate[1];
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 10.0,
                        // ),

                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: _getPayButton(),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  )

                ],
              )),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();

      Navigator.push(context, MaterialPageRoute(builder: (_)=>MyWebView(_paymentCard,Provider.of<InputProvider>(context).getAmount)));


    }
  }

  Widget _getPayButton() {
    if (Platform.isIOS) {
      return   CupertinoButton(
        onPressed: _validateInputs,
        color: CupertinoColors.systemOrange,
        child: const Text(
          Strings.pay,
          style: const TextStyle(fontSize: 17.0),
        ),
      );
    } else {
      return   RaisedButton(
        onPressed: _validateInputs,
        color: Colors.deepOrange,
        splashColor: Colors.deepOrange,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(const Radius.circular(100.0)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
        textColor: Colors.white,
        child:   Text(
          Strings.pay.toUpperCase(),
          style: const TextStyle(fontSize: 17.0),
        ),
      );
    }
  }

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(  SnackBar(
      content:   Text(value),
      duration:   Duration(seconds: 3),
    ));
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
class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 60);

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