enum BaizeTokens {
  eof,
  illegal,
  identifier,
  string,
  number,

  hash, // #
  parenLeft, // (
  parenRight, // )
  bracketLeft, // [
  bracketRight, // ]
  braceLeft, // {
  braceRight, // }

  dot, // .
  comma, // ,
  semi, // ;
  question, // ?
  nullOr, // ??
  nullAccess, // ?.
  colon, // :
  declare, // :=
  assign, // =
  plus, // +
  minus, // -
  asterisk, // *
  exponent, // **
  slash, // /
  floor, // //
  modulo, // %
  ampersand, // &
  logicalAnd, // &&
  pipe, // |
  logicalOr, // ||
  caret, // ^
  tilde, // ~
  equal, // ==
  bang, // !
  notEqual, // !=
  lesserThan, // <
  greaterThan, // >
  lesserThanEqual, // <=
  greaterThanEqual, // >=
  rightArrow, // ->
  increment, // ++
  decrement, // --
  plusEqual, // +=
  minusEqual, // -=
  asteriskEqual, // *=
  exponentEqual, // **=
  slashEqual, // /=
  floorEqual, // //=
  moduloEqual, // %=
  ampersandEqual, // &=
  logicalAndEqual, // &&=
  pipeEqual, // |=
  logicalOrEqual, // ||=
  caretEqual, // ^=
  nullOrEqual, // ??=

  trueKw, // true
  falseKw, // false
  nullKw, // null
  ifKw, // if
  elseKw, // else
  whileKw, // while
  returnKw, // return
  breakKw, // break
  continueKw, // continue
  tryKw, // try
  catchKw, // catch
  throwKw, // throw
  importKw, // import
  asKw, // as
  whenKw, // when
  matchKw, // match
  printKw, // print
  forKw, // for
}

const Map<BaizeTokens, String> _tokensCodeMap = <BaizeTokens, String>{
  BaizeTokens.eof: 'eof',
  BaizeTokens.illegal: 'illegal',
  BaizeTokens.identifier: 'identifier',
  BaizeTokens.string: 'string',
  BaizeTokens.number: 'number',
  BaizeTokens.hash: '#',
  BaizeTokens.parenLeft: '(',
  BaizeTokens.parenRight: ')',
  BaizeTokens.bracketLeft: '[',
  BaizeTokens.bracketRight: ']',
  BaizeTokens.braceLeft: '{',
  BaizeTokens.braceRight: '}',
  BaizeTokens.dot: '.',
  BaizeTokens.comma: ',',
  BaizeTokens.semi: ';',
  BaizeTokens.question: '?',
  BaizeTokens.nullOr: '??',
  BaizeTokens.nullAccess: '?.',
  BaizeTokens.colon: ':',
  BaizeTokens.declare: ':=',
  BaizeTokens.assign: '=',
  BaizeTokens.plus: '+',
  BaizeTokens.minus: '-',
  BaizeTokens.asterisk: '*',
  BaizeTokens.exponent: '**',
  BaizeTokens.slash: '/',
  BaizeTokens.floor: '//',
  BaizeTokens.modulo: '%',
  BaizeTokens.ampersand: '&',
  BaizeTokens.logicalAnd: '&&',
  BaizeTokens.pipe: '|',
  BaizeTokens.logicalOr: '||',
  BaizeTokens.caret: '^',
  BaizeTokens.tilde: '~',
  BaizeTokens.equal: '==',
  BaizeTokens.bang: '!',
  BaizeTokens.notEqual: '!=',
  BaizeTokens.lesserThan: '<',
  BaizeTokens.greaterThan: '>',
  BaizeTokens.lesserThanEqual: '<=',
  BaizeTokens.greaterThanEqual: '>=',
  BaizeTokens.rightArrow: '->',
  BaizeTokens.increment: '++',
  BaizeTokens.decrement: '--',
  BaizeTokens.plusEqual: '+=',
  BaizeTokens.minusEqual: '-=',
  BaizeTokens.asteriskEqual: '*=',
  BaizeTokens.exponentEqual: '**=',
  BaizeTokens.slashEqual: '/=',
  BaizeTokens.floorEqual: '//=',
  BaizeTokens.moduloEqual: '%=',
  BaizeTokens.ampersandEqual: '&=',
  BaizeTokens.logicalAndEqual: '&&=',
  BaizeTokens.pipeEqual: '|=',
  BaizeTokens.logicalOrEqual: '||=',
  BaizeTokens.caretEqual: '^=',
  BaizeTokens.nullOrEqual: '??=',
  BaizeTokens.trueKw: 'true',
  BaizeTokens.falseKw: 'false',
  BaizeTokens.ifKw: 'if',
  BaizeTokens.elseKw: 'else',
  BaizeTokens.whileKw: 'while',
  BaizeTokens.nullKw: 'null',
  BaizeTokens.returnKw: 'return',
  BaizeTokens.breakKw: 'break',
  BaizeTokens.continueKw: 'continue',
  BaizeTokens.tryKw: 'try',
  BaizeTokens.catchKw: 'catch',
  BaizeTokens.throwKw: 'throw',
  BaizeTokens.importKw: 'import',
  BaizeTokens.asKw: 'as',
  BaizeTokens.whenKw: 'when',
  BaizeTokens.matchKw: 'match',
  BaizeTokens.printKw: 'print',
  BaizeTokens.forKw: 'for',
};

extension OutreTokensUtils on BaizeTokens {
  String get code => _tokensCodeMap[this]!;
}
