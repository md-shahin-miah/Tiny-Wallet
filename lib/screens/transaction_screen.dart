import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview/model/card_model.dart';
import 'package:flutter_webview/transaction_info_podo.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<TransactionInfo> items = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState

    print('init state transaction');
    CardModel.getTransaction().then((value) => getCardData(value));

    super.initState();
  }

  getCardData(String val) {
    try {
      final response = jsonDecode(val);

      print('response -------------------------------  $response');

      for (int i = 0; i < response.length; i++) {
        final object = response[i];

        items.add(TransactionInfo(
            object['amount'],
            object['id'],
            object['card_no'],
            object['cvv'],
            object['exp_month_year'],
            object['created'],
            object['reference'],
            object['merchant_id'],
            object['status']));
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      print(' catch e ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Transactions'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : items.length > 0
                ? ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          '£ ${items[index].amount}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          '${items[index].cardNumber}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black54),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          '${items[index].created}',
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   flex: 1,
                                //   child:
                                //
                                //   ),
                                items[index].status == 'success'
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green[100],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          child: Text(
                                            'success',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.green[900],
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red[100],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          child: Text(
                                            'failed',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red[700],
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    alignment: Alignment.center,
                    child: Text('No transaction Available'),
                  ));
  }
}
