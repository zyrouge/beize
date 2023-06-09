enum FubukiTokens {
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

const Map<FubukiTokens, String> _tokensCodeMap = <FubukiTokens, String>{
  FubukiTokens.eof: 'eof',
  FubukiTokens.illegal: 'illegal',
  FubukiTokens.identifier: 'identifier',
  FubukiTokens.string: 'string',
  FubukiTokens.number: 'number',
  FubukiTokens.hash: '#',
  FubukiTokens.parenLeft: '(',
  FubukiTokens.parenRight: ')',
  FubukiTokens.bracketLeft: '[',
  FubukiTokens.bracketRight: ']',
  FubukiTokens.braceLeft: '{',
  FubukiTokens.braceRight: '}',
  FubukiTokens.dot: '.',
  FubukiTokens.comma: ',',
  FubukiTokens.semi: ';',
  FubukiTokens.question: '?',
  FubukiTokens.nullOr: '??',
  FubukiTokens.nullAccess: '?.',
  FubukiTokens.colon: ':',
  FubukiTokens.declare: ':=',
  FubukiTokens.assign: '=',
  FubukiTokens.plus: '+',
  FubukiTokens.minus: '-',
  FubukiTokens.asterisk: '*',
  FubukiTokens.exponent: '**',
  FubukiTokens.slash: '/',
  FubukiTokens.floor: '//',
  FubukiTokens.modulo: '%',
  FubukiTokens.ampersand: '&',
  FubukiTokens.logicalAnd: '&&',
  FubukiTokens.pipe: '|',
  FubukiTokens.logicalOr: '||',
  FubukiTokens.caret: '^',
  FubukiTokens.tilde: '~',
  FubukiTokens.equal: '==',
  FubukiTokens.bang: '!',
  FubukiTokens.notEqual: '!=',
  FubukiTokens.lesserThan: '<',
  FubukiTokens.greaterThan: '>',
  FubukiTokens.lesserThanEqual: '<=',
  FubukiTokens.greaterThanEqual: '>=',
  FubukiTokens.rightArrow: '->',
  FubukiTokens.increment: '++',
  FubukiTokens.decrement: '--',
  FubukiTokens.plusEqual: '+=',
  FubukiTokens.minusEqual: '-=',
  FubukiTokens.asteriskEqual: '*=',
  FubukiTokens.exponentEqual: '**=',
  FubukiTokens.slashEqual: '/=',
  FubukiTokens.floorEqual: '//=',
  FubukiTokens.moduloEqual: '%=',
  FubukiTokens.ampersandEqual: '&=',
  FubukiTokens.logicalAndEqual: '&&=',
  FubukiTokens.pipeEqual: '|=',
  FubukiTokens.logicalOrEqual: '||=',
  FubukiTokens.caretEqual: '^=',
  FubukiTokens.nullOrEqual: '??=',
  FubukiTokens.trueKw: 'true',
  FubukiTokens.falseKw: 'false',
  FubukiTokens.ifKw: 'if',
  FubukiTokens.elseKw: 'else',
  FubukiTokens.whileKw: 'while',
  FubukiTokens.nullKw: 'null',
  FubukiTokens.returnKw: 'return',
  FubukiTokens.breakKw: 'break',
  FubukiTokens.continueKw: 'continue',
  FubukiTokens.tryKw: 'try',
  FubukiTokens.catchKw: 'catch',
  FubukiTokens.throwKw: 'throw',
  FubukiTokens.importKw: 'import',
  FubukiTokens.asKw: 'as',
  FubukiTokens.whenKw: 'when',
  FubukiTokens.matchKw: 'match',
  FubukiTokens.printKw: 'print',
  FubukiTokens.forKw: 'for',
};

extension OutreTokensUtils on FubukiTokens {
  String get code => _tokensCodeMap[this]!;
}
