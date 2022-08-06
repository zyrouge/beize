import '../../utils.dart';

enum OutreTokens {
  eof,
  illegal,
  identifier,
  string,
  number,

  parenLeft, // (
  parenRight, // )
  bracketLeft, // [
  bracketRight, // ]
  braceLeft, // {
  braceRight, // }

  dot, // .
  comma, // ,
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
  and, // &&
  pipe, // |
  or, // ||
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
}

extension OutreTokensUtils on OutreTokens {
  String get stringify => OutreUtils.pascalToKebabCase(name);
}

OutreTokens parseOutreTokens(final String value) => OutreUtils.findEnum(
      OutreTokens.values,
      OutreUtils.kebabToPascalCase(value),
    );
