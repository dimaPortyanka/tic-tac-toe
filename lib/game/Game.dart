import 'package:flutter/material.dart';

import 'package:tic_tac_toe/game/Filed.dart';
import 'package:tic_tac_toe/game/utils.dart';

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameState();
  }
}

class _GameState extends State<Game> {
  var _matrix = new Map<String, int>();
  var _moves = 0;
  var _curSymb = X;
  static const _fieldSize = 3;

  _restartGame() {
    setState(() {
      _matrix = new Map<String, int>();
      _moves = 0;
      _curSymb = X;
    });
  }

  void _onClickCell(int i, int j) {
    if (_matrix[key(i,j)] != null) {
      return null;
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

      if (_curSymb == X) {
        _curSymb = O;
      } else {
        _curSymb = X;
      }
    });
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
                _onClickCell(x,y);
              },
            ),
          )
        ],
      ),
    );
  }
}
