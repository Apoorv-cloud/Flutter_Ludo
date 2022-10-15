import 'package:flutter/material.dart';

import './ludo_row.dart';

class Board extends StatelessWidget {
  final List<List<GlobalKey>> keyReferences;
  const Board({Key? key, required this.keyReferences}) : super(key: key);

  List<Container> _getRows() {
    List<Container> rows = [];
    for (var i = 0; i < 15; i++) {
      rows.add(
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: const BorderSide(color: Colors.grey),
              bottom: i == 14
                  ? const BorderSide(color: Colors.grey)
                  : BorderSide.none,
            ),
            color: Colors.transparent,
          ),
          child: LudoRow(row: i, keyRow: keyReferences[i]),
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
          decoration: const BoxDecoration(
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
