import 'dart:core';

import 'package:flutter/material.dart';
import 'game/Game.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic tac toe'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Game(),
      ),
    );
  }
}
