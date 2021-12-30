import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputProvider extends ChangeNotifier {
  String inputFieldAmount = '0.00';
  bool tapped = false;

  final firstPart = ['0'];
  final secondPart = ['0', '0'];

  var inputAmountDouble = 0.00;

  void changeColor() {
    tapped = !tapped;
    notifyListeners();
  }

  bool get isTrue {
    return tapped;
  }

  String get getAmount {
    return inputFieldAmount;
  }

  void addAmount(String amount) {
    if (secondPart.length == 2) {
      if (firstPart.length < 8) {
        //9 because of initial 000 in both list
        firstPart.add(secondPart[0]);
      }
      secondPart[0] = secondPart[1];
      secondPart[1] = amount;
    }
    String firstString = '';

    for (int i = 0; i < firstPart.length; i++) {
      firstString += firstPart[i];
    }

    int firstInt = int.parse(firstString);
    if (firstPart.length > 4 && firstInt < 1) {
      firstPart.clear();
    }

    // print(firstInt);
    inputFieldAmount = '$firstInt.${secondPart[0]}${secondPart[1]}';
    inputAmountDouble = double.parse(inputFieldAmount);

    print(' double value $inputAmountDouble');

    notifyListeners();
  }

  double get getAmountInDouble {
    return inputAmountDouble;
  }

  void deleteAmount() {
    print(firstPart.toString());
    print(secondPart.toString());

    if (secondPart.length > 1 && firstPart.length > 1) {
      secondPart[1] = secondPart[0];
      secondPart[0] = firstPart[firstPart.length - 1];
      firstPart.removeLast();
    }
    print(firstPart.toString());
    print(secondPart.toString());

    String firstString = '';
    for (int i = 0; i < firstPart.length; i++) {
      firstString += firstPart[i];
    }
    int firstInt = int.parse(firstString);
    // print(firstInt);
    inputFieldAmount = '$firstInt.${secondPart[0]}${secondPart[1]}';
    inputAmountDouble = double.parse(inputFieldAmount);
    notifyListeners();
  }

  void allDelete() {
    inputFieldAmount = '0.00';
    firstPart.clear();
    secondPart.clear();
    firstPart.add('0');
    secondPart.add('0');
    secondPart.add('0');
    inputAmountDouble = 0.00;
    notifyListeners();
  }

// static String replaceLastFour(String s) {
//   int length = s.length;
//
//   if (length < 4)
//     return "Error: The provided string is not greater than four characters long.";
//   return s.substring(0, length - 1) + "*";
// }
}
