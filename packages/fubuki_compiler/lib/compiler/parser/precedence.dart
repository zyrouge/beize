enum FubukiPrecedence {
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

extension FubukiPrecedenceUtils on FubukiPrecedence {
  int get value => index;
  FubukiPrecedence get nextPrecedence => FubukiPrecedence.values[index + 1];
}
