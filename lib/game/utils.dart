enum Symb {
  X,
  O,
}

Symb notSymb(Symb s) {
  if (s == Symb.X) {
    return Symb.O;
  }

  return Symb.X;
}

const SYMBOL_NAME_MAP = {
  Symb.X: "X",
  Symb.O: "O",
};

String key(int i, int j) {
  return '$i-$j';
}

List<int> getPosition(String s) {
  var splitted = s.split('-');

  return [int.parse(splitted[0]), int.parse(splitted[1])];
}

typedef NextMoveFunction = List<int> Function(Symb, Map<String, Symb>, int);
