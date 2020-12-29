import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../gameengine/model/dice_model.dart';
class Dice extends StatelessWidget {

  void updateDices(DiceModel dice) {
    for (int i = 0; i < 6; i++) {
    var  duration = 100 + i * 100;
    var future  = Future.delayed(Duration(milliseconds: duration),(){
      dice.generateDiceOne();
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> _diceOneImages = [
      "assets/1.png",
      "assets/2.png",
      "assets/3.png",
      "assets/4.png",
      "assets/5.png",
      "assets/6.png",
    ];
    final dice = Provider.of<DiceModel>(context);
    final c = dice.diceOneCount;
    var img = Image.asset(
      _diceOneImages[c - 1],
      gaplessPlayback: true,
      fit: BoxFit.fill,
    );
    return Card(
         elevation: 10,
          child: Container(
            height: 40,
            width: 40,
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () => updateDices(dice),
                    child: img,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
