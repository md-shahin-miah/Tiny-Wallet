import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class LoginProvider extends ChangeNotifier {



  loginDataSave(String email,String password) async{
    try{
      var response = await http.post(
          'https://superadmin.ordere.co.uk/api/check_wallet',
          body: {
            'email':email,
            'password':password
          });

      print('response login-------------------------${response.body}');

      return response.body;



    }
    catch(e){
      return 'failed';
    }
  }






}