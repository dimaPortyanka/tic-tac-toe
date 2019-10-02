const X = 1;
const O = 2;

const SYMBOL_NAME_MAP = {
  X: "Cross",
  O: "Zeros",
};

String key(int i, int j) {
  return '$i-$j';
}

List<int> getPosition(String s) {
  var splitted = s.split('-');

  return [int.parse(splitted[0]), int.parse(splitted[1])];
}
