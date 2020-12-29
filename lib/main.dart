import 'package:flutter/material.dart';
import './gameengine/model/game_state.dart';
import './widgets/gameplay.dart';
import 'package:provider/provider.dart';
import './widgets/dice.dart';
import './gameengine/model/dice_model.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', 
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=>GameState()),
          ChangeNotifierProvider(create: (context)=>DiceModel()),
        ],
        child: MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey keyBar = GlobalKey();
  void _onPressed() {
  }
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return Scaffold(
      appBar: AppBar(
        key: keyBar,
        title: Text('Ludo'),
      ),
      body: GamePlay(keyBar,gameState),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: Dice(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
