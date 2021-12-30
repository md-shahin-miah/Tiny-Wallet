import 'package:flutter_webview/static_value.dart';
import 'package:http/http.dart' as http;

class CardModel {
  storePaymentInfo(String amount, String cardNo, String cvv,
      String expMonthYear, String ref, String merchant, String status) async {
    try {
      print('try call oiche ---');
      var response = await http
          .post('https://superadmin.ordere.co.uk/api/store_information', body: {
        'amount': amount,
        'card_no': cardNo,
        'cvv': cvv,
        'exp_month_year': expMonthYear,
        'reference': ref,
        'merchant_id': merchant,
        'status': status
      });
      print('response call oiche ---${response.body}');

      return response.body;
    } catch (e) {
      print('catch call oiche ---');

      return 'false';
    }
  }

  static Future getTransaction() async {
    try {
      var response = await http
          .post('https://superadmin.ordere.co.uk/api/get_transactions', body: {
        'merchant_id': StaticValue.merchantId,
      });

      return response.body;
    } catch (e) {
      return 'false';
    }
  }

  static Future storePassKey(String merchantId, String pin) async {
    var response = await http.post(
        'https://superadmin.ordere.co.uk/api/store_passkey',
        body: {'merchant_id': merchantId, 'passcode': pin});

    return response.body;
  }

  static Future getVerificationPin(String passCode) async {
    try {
      var response = await http
          .post('https://superadmin.ordere.co.uk/api/validatepasscode', body: {
        'merchant_id': StaticValue.merchantId,
        'passcode': passCode,
      });

      print('response getVerificationPin----------------------------------${response.body}');
      return response.body;
    } catch (e) {
      return 'false';
    }
  }

}
