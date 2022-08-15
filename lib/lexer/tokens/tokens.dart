import '../../utils/exports.dart';

enum OutreTokens {
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

  trueKw, // true
  falseKw, // false
  ifKw, // if
  elseKw, // else
  whileKw, // while
  nullKw, // null
  fnKw, // fn
  returnKw, // return
  breakKw, // break
  continueKw, // continue
  objKw, // obj
  tryKw, // try
  catchKw, // catch
  throwKw, // throw
  importKw, // import
  asKw, // as
}

const Map<OutreTokens, String> _tokensCodeMap = <OutreTokens, String>{
  OutreTokens.eof: 'eof',
  OutreTokens.illegal: 'illegal',
  OutreTokens.identifier: 'identifier',
  OutreTokens.string: 'string',
  OutreTokens.number: 'number',
  OutreTokens.hash: '#',
  OutreTokens.parenLeft: '(',
  OutreTokens.parenRight: ')',
  OutreTokens.bracketLeft: '[',
  OutreTokens.bracketRight: ']',
  OutreTokens.braceLeft: '{',
  OutreTokens.braceRight: '}',
  OutreTokens.dot: '.',
  OutreTokens.comma: ',',
  OutreTokens.semi: ';',
  OutreTokens.question: '?',
  OutreTokens.nullOr: '??',
  OutreTokens.nullAccess: '?.',
  OutreTokens.colon: ':',
  OutreTokens.declare: ':=',
  OutreTokens.assign: '=',
  OutreTokens.plus: '+',
  OutreTokens.minus: '-',
  OutreTokens.asterisk: '*',
  OutreTokens.exponent: '**',
  OutreTokens.slash: '/',
  OutreTokens.floor: '//',
  OutreTokens.modulo: '%',
  OutreTokens.ampersand: '&',
  OutreTokens.logicalAnd: '&&',
  OutreTokens.pipe: '|',
  OutreTokens.logicalOr: '||',
  OutreTokens.caret: '^',
  OutreTokens.tilde: '~',
  OutreTokens.equal: '==',
  OutreTokens.bang: '!',
  OutreTokens.notEqual: '!=',
  OutreTokens.lesserThan: '<',
  OutreTokens.greaterThan: '>',
  OutreTokens.lesserThanEqual: '<=',
  OutreTokens.greaterThanEqual: '>=',
  OutreTokens.trueKw: 'true',
  OutreTokens.falseKw: 'false',
  OutreTokens.ifKw: 'if',
  OutreTokens.elseKw: 'else',
  OutreTokens.whileKw: 'while',
  OutreTokens.nullKw: 'null',
  OutreTokens.fnKw: 'fn',
  OutreTokens.returnKw: 'return',
  OutreTokens.breakKw: 'break',
  OutreTokens.continueKw: 'continue',
  OutreTokens.objKw: 'obj',
  OutreTokens.tryKw: 'try',
  OutreTokens.catchKw: 'catch',
  OutreTokens.throwKw: 'throw',
  OutreTokens.importKw: 'import',
  OutreTokens.asKw: 'as',
};

extension OutreTokensUtils on OutreTokens {
  String get stringify => OutreUtils.pascalToKebabCase(name);
  String get code => _tokensCodeMap[this]!;
}

OutreTokens parseOutreTokens(final String value) => OutreUtils.findEnum(
      OutreTokens.values,
      OutreUtils.kebabToPascalCase(value),
    );
