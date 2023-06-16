enum BeizePrecedence {
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

extension BeizePrecedenceUtils on BeizePrecedence {
  int get value => index;
  BeizePrecedence get nextPrecedence => BeizePrecedence.values[index + 1];
}
