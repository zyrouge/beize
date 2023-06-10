enum BaizePrecedence {
  none,
  assignment, // := = ? :
  or, // || ??
  and, // &&
  pipe, // |
  caret, // ^
  ampersand, // &
  equality, // == !=
  comparison, // > >= < <=
  sum, // + -
  factor, // * / // %
  exponent, // **
  unary, // ! ~ + -
  call, // () . [] ?.
  grouping, // (...)
  kekw,
}

extension BaizePrecedenceUtils on BaizePrecedence {
  int get value => index;
  BaizePrecedence get nextPrecedence => BaizePrecedence.values[index + 1];
}
