import './position.dart';

enum TokenType { green, yellow, blue, red }

enum TokenState { initial, home, normal, safe, safeinpair }

class Token {
  final int id;
  final TokenType type;
  Position? tokenPosition;
  TokenState? tokenState;
  int? positionInPath;
  Token(
      {required this.type,
      required this.tokenPosition,
      required this.tokenState,
      required this.id});
}
