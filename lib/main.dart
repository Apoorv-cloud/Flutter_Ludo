import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './gameengine/model/dice_model.dart';
import './gameengine/model/game_state.dart';
import './widgets/dice.dart';
import './widgets/gameplay.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(providers: [
        ChangeNotifierProvider(
            create: (context) => GameState()..initFunction()),
        ChangeNotifierProvider(create: (context) => DiceModel()),
      ], child: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey keyBar = GlobalKey();
  void _onPressed() {}
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return Scaffold(
      appBar: AppBar(
        key: keyBar,
        title: const Text('Ludo'),
      ),
      body: GamePlay(keyBar: keyBar, gameState: gameState),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: const Dice(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
