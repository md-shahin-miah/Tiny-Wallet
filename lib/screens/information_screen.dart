import 'package:flutter/material.dart';
import 'package:flutter_webview/screens/pin_code_screen.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class InformationScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String businessOwnersName;
  String address;
  String postCode;
  String emailAddress;
  String phoneNumber;

  TextEditingController _controllerBusinessOwnersName =TextEditingController();
  TextEditingController _controllerAddress =TextEditingController();
  TextEditingController _controllerPostCode =TextEditingController();
  TextEditingController _controllerEmailAddress =TextEditingController();
  TextEditingController _controllerPhoneNumber =TextEditingController();



  @override
  Widget build(BuildContext context) {
    print('  ----------------------------$_controllerBusinessOwnersName');

    return  Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[400],
      // appBar: _buildAppBar(context),
      body: Container(

        child: ListView(
          children: [

            const SizedBox(height: 60.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Information",
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _controllerBusinessOwnersName,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 30,left: 10),
                      border: OutlineInputBorder(),
                      labelText: "Business owner's name",
                    ),

                    onChanged: (val){
                      businessOwnersName=val;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _controllerAddress,
                    // obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 50,left: 10),
                      border: OutlineInputBorder(),
                      labelText: "Address",
                    ),

                    onChanged: (val){
                      address=val;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _controllerPostCode,
                    // obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 30,left: 10),
                      border: OutlineInputBorder(),
                      labelText: "Post / Zip Code",
                    ),
                    onChanged: (val){
                      postCode=val;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    // obscureText: true,
                    controller: _controllerEmailAddress,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 30,left: 10),
                      border: OutlineInputBorder(),
                      labelText: "Contact Email Address",
                    ),
                    onChanged: (val){
                      emailAddress=val;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller:_controllerPhoneNumber,
                    // obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 30,left: 10),
                      border: OutlineInputBorder(),
                      labelText: "Phone Number",
                    ),
                    onChanged: (val){
                      phoneNumber=val;
                    },
                  ),

                  const SizedBox(height: 10.0),


                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: RaisedButton(
                padding: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                color: Colors.deepOrange,
                textColor: Colors.white,
                onPressed: ()=>setDataToPreference(context),
                child: Text("Submit"),
              ),
            ),
            const SizedBox(height: 10.0),

          ],
        ),
      ),
    );
  }


  void setDataToPreference(BuildContext context)async{


    if(businessOwnersName!=null&&address!=null&&postCode!=null&&emailAddress!=null&&phoneNumber!=null){
      SharedPreferences prefs =
      await SharedPreferences.getInstance();
      await prefs.setString('ownersname',businessOwnersName );
      await prefs.setString('address', address);
      await prefs.setString('postcode', postCode);
      await prefs.setString('emailaddress', emailAddress);
      await prefs.setString('phonenumber', phoneNumber).then((value) => navigateToNext(context));



    }
    else{
      print('empty dfgdj -----------------------------------------------$businessOwnersName -----$address -----$postCode}');
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text(
              "Information is required")));
    }


  }

  navigateToNext(BuildContext context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(
            builder: (_) => PinCodeVerificationScreen(false)));
  }



}
AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
          ),
          Text(
            "Back",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    paint_0.shader = ui.Gradient.linear(
        Offset(size.width * 0.64, size.height * 0.11),
        Offset(size.width, size.height * 0.11),
        [Color(0x55e17e51), Color(0x99cd5c0b)],
        [0.00, 1.00]);

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.64, 0);
    path_0.quadraticBezierTo(size.width * 0.74, size.height * 0.09,
        size.width * 0.79, size.height * 0.08);
    path_0.cubicTo(size.width * 0.74, size.height * 0.09, size.width * 0.69,
        size.height * 0.14, size.width * 0.71, size.height * 0.17);
    path_0.quadraticBezierTo(size.width * 0.72, size.height * 0.19,
        size.width * 0.79, size.height * 0.21);
    path_0.quadraticBezierTo(
        size.width * 0.93, size.height * 0.24, size.width, size.height * 0.21);
    path_0.quadraticBezierTo(size.width, size.height * 0.16, size.width, 0);
    path_0.lineTo(size.width * 0.64, 0);
    path_0.close();

    canvas.drawPath(path_0, paint_0);

    Paint paint_1 = new Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    paint_1.shader = ui.Gradient.linear(
        Offset(size.width * 0.64, size.height * 0.12),
        Offset(size.width, size.height * 0.12),
        [Color(0x6ade8146), Color(0x87b75b0a)],
        [0.00, 1.00]);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.64, size.height * 0.08);
    path_1.quadraticBezierTo(size.width * 0.68, size.height * 0.15,
        size.width * 0.76, size.height * 0.13);
    path_1.cubicTo(size.width * 0.81, size.height * 0.15, size.width * 0.71,
        size.height * 0.22, size.width * 0.74, size.height * 0.24);
    path_1.quadraticBezierTo(
        size.width * 0.81, size.height * 0.27, size.width, size.height * 0.18);
    path_1.lineTo(size.width, 0);
    path_1.quadraticBezierTo(size.width * 0.83, 0, size.width * 0.77, 0);
    path_1.quadraticBezierTo(size.width * 0.66, size.height * 0.02,
        size.width * 0.64, size.height * 0.08);
    path_1.close();

    canvas.drawPath(path_1, paint_1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}