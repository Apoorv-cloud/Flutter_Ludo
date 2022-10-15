import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../gameengine/model/dice_model.dart';
import '../gameengine/model/game_state.dart';
import '../gameengine/model/token.dart';

// ignore: must_be_immutable
class Boards extends StatelessWidget {
  final Token token;
  final List<double> dimentions;
  Function(Token)? callBack;
  Boards({Key? key, required this.token, required this.dimentions})
      : super(key: key);

  Color _getColor() {
    switch (token.type) {
      case TokenType.green:
        return Colors.green;
      case TokenType.yellow:
        return Colors.yellow[900] ?? Colors.yellow;
      case TokenType.blue:
        return Colors.blue[600] ?? Colors.blue;
      case TokenType.red:
        return Colors.red;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final dice = Provider.of<DiceModel>(context);
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      left: dimentions[0],
      top: dimentions[1],
      width: dimentions[2],
      height: dimentions[3],
      child: GestureDetector(
        onTap: () {
          gameState.moveToken(token, dice.diceOne);
        },
        child: Card(
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getColor(),
                boxShadow: [
                  BoxShadow(
                    color: _getColor(),
                    blurRadius: 5.0, // soften the shadow
                    spreadRadius: 1.0, //extend the shadow
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
