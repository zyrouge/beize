enum BeizeTokens {
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
  asyncKw, // async
  awaitKw, // await
  onlyKw, // only
  isKw, // is
}

const Map<BeizeTokens, String> _tokensCodeMap = <BeizeTokens, String>{
  BeizeTokens.eof: 'eof',
  BeizeTokens.illegal: 'illegal',
  BeizeTokens.identifier: 'identifier',
  BeizeTokens.string: 'string',
  BeizeTokens.number: 'number',
  BeizeTokens.hash: '#',
  BeizeTokens.parenLeft: '(',
  BeizeTokens.parenRight: ')',
  BeizeTokens.bracketLeft: '[',
  BeizeTokens.bracketRight: ']',
  BeizeTokens.braceLeft: '{',
  BeizeTokens.braceRight: '}',
  BeizeTokens.dot: '.',
  BeizeTokens.comma: ',',
  BeizeTokens.semi: ';',
  BeizeTokens.question: '?',
  BeizeTokens.nullOr: '??',
  BeizeTokens.nullAccess: '?.',
  BeizeTokens.colon: ':',
  BeizeTokens.declare: ':=',
  BeizeTokens.assign: '=',
  BeizeTokens.plus: '+',
  BeizeTokens.minus: '-',
  BeizeTokens.asterisk: '*',
  BeizeTokens.exponent: '**',
  BeizeTokens.slash: '/',
  BeizeTokens.floor: '//',
  BeizeTokens.modulo: '%',
  BeizeTokens.ampersand: '&',
  BeizeTokens.logicalAnd: '&&',
  BeizeTokens.pipe: '|',
  BeizeTokens.logicalOr: '||',
  BeizeTokens.caret: '^',
  BeizeTokens.tilde: '~',
  BeizeTokens.equal: '==',
  BeizeTokens.bang: '!',
  BeizeTokens.notEqual: '!=',
  BeizeTokens.lesserThan: '<',
  BeizeTokens.greaterThan: '>',
  BeizeTokens.lesserThanEqual: '<=',
  BeizeTokens.greaterThanEqual: '>=',
  BeizeTokens.rightArrow: '->',
  BeizeTokens.increment: '++',
  BeizeTokens.decrement: '--',
  BeizeTokens.plusEqual: '+=',
  BeizeTokens.minusEqual: '-=',
  BeizeTokens.asteriskEqual: '*=',
  BeizeTokens.exponentEqual: '**=',
  BeizeTokens.slashEqual: '/=',
  BeizeTokens.floorEqual: '//=',
  BeizeTokens.moduloEqual: '%=',
  BeizeTokens.ampersandEqual: '&=',
  BeizeTokens.logicalAndEqual: '&&=',
  BeizeTokens.pipeEqual: '|=',
  BeizeTokens.logicalOrEqual: '||=',
  BeizeTokens.caretEqual: '^=',
  BeizeTokens.nullOrEqual: '??=',
  BeizeTokens.trueKw: 'true',
  BeizeTokens.falseKw: 'false',
  BeizeTokens.ifKw: 'if',
  BeizeTokens.elseKw: 'else',
  BeizeTokens.whileKw: 'while',
  BeizeTokens.nullKw: 'null',
  BeizeTokens.returnKw: 'return',
  BeizeTokens.breakKw: 'break',
  BeizeTokens.continueKw: 'continue',
  BeizeTokens.tryKw: 'try',
  BeizeTokens.catchKw: 'catch',
  BeizeTokens.throwKw: 'throw',
  BeizeTokens.importKw: 'import',
  BeizeTokens.asKw: 'as',
  BeizeTokens.whenKw: 'when',
  BeizeTokens.matchKw: 'match',
  BeizeTokens.printKw: 'print',
  BeizeTokens.forKw: 'for',
  BeizeTokens.asyncKw: 'async',
  BeizeTokens.awaitKw: 'await',
  BeizeTokens.onlyKw: 'only',
  BeizeTokens.isKw: 'is',
};

extension OutreTokensUtils on BeizeTokens {
  String get code => _tokensCodeMap[this]!;
}
