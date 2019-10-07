import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:tic_tac_toe/game/Filed.dart';
import 'package:tic_tac_toe/game/utils.dart';

class Game extends StatefulWidget {
  NextMoveFunction _nextMove = null;

  bool _allowMove = true;

  Game({ bool allowMove, NextMoveFunction nextMove }) {
    if (allowMove != null) {
      _allowMove = allowMove;
    }

    if (nextMove != null) {
      _nextMove = nextMove;
    }
  }

  State<StatefulWidget> createState() {
    return _GameState();
  }
}

Map<String, Symb> generateEmptyField() {
  return new Map<String, Symb>();
}

class _GameState extends State<Game> {
  Map<String, Symb> _matrix = generateEmptyField();
  int _moves = 0;
  Symb _curSymb = Symb.X;
  static const _fieldSize = 3;

  _restartGame() {
    setState(() {
      _matrix = generateEmptyField();
      _moves = 0;
      _curSymb = Symb.X;
    });
  }

  void _makeMove(int i, int j) {
    if (_matrix[key(i,j)] != null) {
      return;
    }

    setState(() {
      _moves++;

      _matrix[key(i,j)] = _curSymb;

      var haveWinner = _winnerExists(i, j);
      var fieldIsFull = _moves >= _fieldSize*_fieldSize;

      if (haveWinner || fieldIsFull) {
        var content = "Draw";
        if (haveWinner) {
          content = '${SYMBOL_NAME_MAP[_curSymb]} won!';
        }

        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Text('Game over'),
            content: Text(content),
          );
        }).then((val){
          _restartGame();
        });
      }

      _curSymb = notSymb(_curSymb);
    });

    if (widget._nextMove == null) {
      return;
    }

    var nextMoveCoordinates = widget._nextMove(_curSymb, _matrix, _moves);

    if (nextMoveCoordinates == null) {
      return;
    }

    _makeMove(nextMoveCoordinates[0], nextMoveCoordinates[1]);
  }

  bool _winnerExists(int row, int col) {
    var horizontal = 0;
    var vertical = 0;
    var diagonal1 = 0;
    var diagonal2 = 0;
    var curSymb = _matrix[key(row, col)];

    for (int i = 0; i < _fieldSize; i++) {
      if (_matrix[key(row, i)] == curSymb) {
        horizontal++;
      }

      if (_matrix[key(i, col)] == curSymb) {
        vertical++;
      }

      if (_matrix[key(i, i)] == curSymb) {
        diagonal1++;
      }

      if (_matrix[key(i, _fieldSize-1-i)] == curSymb) {
        diagonal2++;
      }
    }

    return (
        diagonal1 == _fieldSize ||
        diagonal2 == _fieldSize ||
        horizontal == _fieldSize ||
        vertical == _fieldSize
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: <Widget>[
          Text(
            'Turn of ${SYMBOL_NAME_MAP[_curSymb]}',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 36,
            ),
          ),
          Expanded(
            flex: 1,
            child: Field(
              matrix: _matrix,
              selectCell: (int x, int y) {
                if (!widget._allowMove) {
                  return;
                }

                _makeMove(x,y);
              },
            ),
          )
        ],
      ),
    );
  }
}
