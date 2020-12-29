import 'dart:math';
import 'package:flutter/material.dart';
class DiceModel with ChangeNotifier {
  int diceOne = 1;

  int get diceOneCount => diceOne;

  void generateDiceOne() {
    diceOne = Random().nextInt(6) + 1;
    print("diceOne: $diceOne");
    notifyListeners();
  }
}