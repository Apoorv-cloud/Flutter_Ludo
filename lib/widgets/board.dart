import 'package:flutter/material.dart';
import './ludo_row.dart';

class Board extends StatelessWidget {
  List<List<GlobalKey>> keyRefrences;
  Board(this.keyRefrences);
  List<Container> _getRows() {
    List<Container> rows = [];
    for (var i = 0; i < 15; i++) {
      rows.add(
        Container(
          child: LudoRow(i,keyRefrences[i]),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey),
              bottom:
                  i == 14 ? BorderSide(color: Colors.grey) : BorderSide.none,
            ),
            color: Colors.transparent,
          ),
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Ludo_board.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[..._getRows()],
          ),
        ),
      ),
    );
  }
}
