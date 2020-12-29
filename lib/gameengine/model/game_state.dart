import 'package:flutter/material.dart';
import 'package:ludo/gameengine/path.dart';

import './position.dart';
import './token.dart';

class GameState with ChangeNotifier {
  List<Token> gameTokens = List<Token>(16);
  List<Position> starPositions;
  List<Position> greenInitital;
  List<Position> yellowInitital;
  List<Position> blueInitital;
  List<Position> redInitital;
  GameState() {
    this.gameTokens = [
      //Green Tokens home
      Token(TokenType.green, Position(2, 2), TokenState.initial, 0),
      Token(TokenType.green, Position(2, 3), TokenState.initial, 1),
      Token(TokenType.green, Position(3, 2), TokenState.initial, 2),
      Token(TokenType.green, Position(3, 3), TokenState.initial, 3),
      //Yellow Token
      Token(TokenType.yellow, Position(2, 11), TokenState.initial, 4),
      Token(TokenType.yellow, Position(2, 12), TokenState.initial, 5),
      Token(TokenType.yellow, Position(3, 11), TokenState.initial, 6),
      Token(TokenType.yellow, Position(3, 12), TokenState.initial, 7),
      // Blue Token
      Token(TokenType.blue, Position(11, 11), TokenState.initial, 8),
      Token(TokenType.blue, Position(11, 12), TokenState.initial, 9),
      Token(TokenType.blue, Position(12, 11), TokenState.initial, 10),
      Token(TokenType.blue, Position(12, 12), TokenState.initial, 11),
      // Red Token
      Token(TokenType.red, Position(11, 2), TokenState.initial, 12),
      Token(TokenType.red, Position(11, 3), TokenState.initial, 13),
      Token(TokenType.red, Position(12, 2), TokenState.initial, 14),
      Token(TokenType.red, Position(12, 3), TokenState.initial, 15),
    ];
    this.starPositions = [
      Position(6, 1),
      Position(2, 6),
      Position(1, 8),
      Position(6, 12),
      Position(8, 13),
      Position(12, 8),
      Position(13, 6),
      Position(8, 2)
    ];
    this.greenInitital = [];
    this.yellowInitital = [];
    this.blueInitital = [];
    this.redInitital = [];
  }
  moveToken(Token token, int steps) {
    Position destination;
    int pathPosition;
    if (token.tokenState == TokenState.home) return;
    if (token.tokenState == TokenState.initial && steps != 6) return;
    if (token.tokenState == TokenState.initial && steps == 6) {
      destination = _getPosition(token.type, 0);
      pathPosition = 0;
      _updateInitalPositions(token);
      _updateBoardState(token, destination, pathPosition);
      this.gameTokens[token.id].tokenPosition = destination;
      this.gameTokens[token.id].positionInPath = pathPosition;
      notifyListeners();
    } else if (token.tokenState != TokenState.initial) {
      int step = token.positionInPath + steps;
      if (step > 56) return;
      destination = _getPosition(token.type, step);
      pathPosition = step;
      var cutToken = _updateBoardState(token, destination, pathPosition);
      int duration = 0;
      for (int i = 1; i <= steps; i++) {
        duration = duration + 500;
        var future = new Future.delayed(Duration(milliseconds: duration), () {
          int stepLoc = token.positionInPath + 1;
          this.gameTokens[token.id].tokenPosition =
              _getPosition(token.type, stepLoc);
          this.gameTokens[token.id].positionInPath = stepLoc;
          token.positionInPath = stepLoc;
          notifyListeners();
        });
      }
      if (cutToken != null) {
      int cutSteps = cutToken.positionInPath;
      for (int i = 1; i <= cutSteps; i++) {
        duration = duration + 100;
        var future2 = new Future.delayed(Duration(milliseconds: duration), () {
            int stepLoc = cutToken.positionInPath - 1;
            this.gameTokens[cutToken.id].tokenPosition =
                _getPosition(cutToken.type, stepLoc);
            this.gameTokens[cutToken.id].positionInPath = stepLoc;
            cutToken.positionInPath = stepLoc;
          notifyListeners();
        });
      }
      var future2 = new Future.delayed(Duration(milliseconds: duration), () {
        _cutToken(cutToken);
        notifyListeners();
      });
      }
    }
  }
  Token _updateBoardState(Token token, Position destination, int pathPosition) {
    Token cutToken;
    //when the destination is on any star
    if (this.starPositions.contains(destination)) {
      this.gameTokens[token.id].tokenState = TokenState.safe;
      //this.gameTokens[token.id].tokenPosition = destination;
      //this.gameTokens[token.id].positionInPath = pathPosition;
      return null;
    }
    List<Token> tokenAtDestination = this.gameTokens.where((tkn) {
      if (tkn.tokenPosition == destination) {
        return true;
      }
      return false;
    }).toList();
    //if no one at the destination
    if (tokenAtDestination.length == 0) {
      this.gameTokens[token.id].tokenState = TokenState.normal;
      //this.gameTokens[token.id].tokenPosition = destination;
      //this.gameTokens[token.id].positionInPath = pathPosition;
      return null;
    }
    //check for same color at destination
    List<Token> tokenAtDestinationSameType = tokenAtDestination.where((tkn) {
      if (tkn.type == token.type) {
        return true;
      }
      return false;
    }).toList();
    if (tokenAtDestinationSameType.length == tokenAtDestination.length) {
      for (Token tkn in tokenAtDestinationSameType) {
        this.gameTokens[tkn.id].tokenState = TokenState.safeinpair;
      }
      this.gameTokens[token.id].tokenState = TokenState.safeinpair;
      //this.gameTokens[token.id].tokenPosition = destination;
      //this.gameTokens[token.id].positionInPath = pathPosition;
      return null;
    }
    if (tokenAtDestinationSameType.length < tokenAtDestination.length) {
      for (Token tkn in tokenAtDestination) {
        if (tkn.type != token.type && tkn.tokenState != TokenState.safeinpair) {
          //cut an unsafe token
          //_cutToken(tkn);
          cutToken = tkn;
        } else if (tkn.type == token.type) {
          this.gameTokens[tkn.id].tokenState = TokenState.safeinpair;
        }
      }
      //place token
      this.gameTokens[token.id].tokenState =
          tokenAtDestinationSameType.length > 0
              ? TokenState.safeinpair
              : TokenState.normal;
      // this.gameTokens[token.id].tokenPosition = destination;
      // this.gameTokens[token.id].positionInPath = pathPosition;
      return cutToken;
    }
  }

  _updateInitalPositions(Token token) {
    switch (token.type) {
      case TokenType.green:
        {
          this.greenInitital.add(token.tokenPosition);
        }
        break;
      case TokenType.yellow:
        {
          this.yellowInitital.add(token.tokenPosition);
        }
        break;
      case TokenType.blue:
        {
          this.blueInitital.add(token.tokenPosition);
        }
        break;
      case TokenType.red:
        {
          this.redInitital.add(token.tokenPosition);
        }
        break;
    }
  }

  _cutToken(Token token) {
    switch (token.type) {
      case TokenType.green:
        {
          this.gameTokens[token.id].tokenState = TokenState.initial;
          this.gameTokens[token.id].tokenPosition = this.greenInitital.first;
          this.greenInitital.removeAt(0);
        }
        break;
      case TokenType.yellow:
        {
          this.gameTokens[token.id].tokenState = TokenState.initial;
          this.gameTokens[token.id].tokenPosition = this.yellowInitital.first;
          this.yellowInitital.removeAt(0);
        }
        break;
      case TokenType.blue:
        {
          this.gameTokens[token.id].tokenState = TokenState.initial;
          this.gameTokens[token.id].tokenPosition = this.blueInitital.first;
          this.blueInitital.removeAt(0);
        }
        break;
      case TokenType.red:
        {
          this.gameTokens[token.id].tokenState = TokenState.initial;
          this.gameTokens[token.id].tokenPosition = this.redInitital.first;
          this.redInitital.removeAt(0);
        }
        break;
    }
  }

  Position _getPosition(TokenType type, step) {
    Position destination;
    switch (type) {
      case TokenType.green:
        {
          List<int> node = Path.greenPath[step];
          destination = Position(node[0], node[1]);
        }
        break;
      case TokenType.yellow:
        {
          List<int> node = Path.yellowPath[step];
          destination = Position(node[0], node[1]);
        }
        break;
      case TokenType.blue:
        {
          List<int> node = Path.bluePath[step];
          destination = Position(node[0], node[1]);
        }
        break;
      case TokenType.red:
        {
          List<int> node = Path.redPath[step];
          destination = Position(node[0], node[1]);
        }
        break;
    }
    return destination;
  }
}
