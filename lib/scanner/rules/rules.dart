import '../../lexer/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'identifier.dart';
import 'number.dart';
import 'string.dart';

typedef OutreScannerRuleMatchFn = bool Function(
  OutreScanner scanner,
  OutreInputIteration current,
);

typedef OutreScannerRuleReadFn = OutreToken Function(
  OutreScanner scanner,
  OutreInputIteration current,
);

class OutreScannerCustomRule {
  const OutreScannerCustomRule(this.matches, this.scan);

  final OutreScannerRuleMatchFn matches;
  final OutreScannerRuleReadFn scan;
}

class OutreScannerRules {
  static final Map<String, OutreScannerRuleReadFn> offset1ScanFns =
      Map<String, OutreScannerRuleReadFn>.fromEntries(
    <MapEntry<String, OutreScannerRuleReadFn>>[
      MapEntry<String, OutreScannerRuleReadFn>(
        OutreTokens.hash.code,
        scanComment,
      ),
      constructOffset1ScanFn(OutreTokens.parenLeft),
      constructOffset1ScanFn(OutreTokens.parenRight),
      constructOffset1ScanFn(OutreTokens.bracketLeft),
      constructOffset1ScanFn(OutreTokens.bracketRight),
      constructOffset1ScanFn(OutreTokens.braceLeft),
      constructOffset1ScanFn(OutreTokens.braceRight),
      constructOffset1ScanFn(OutreTokens.dot),
      constructOffset1ScanFn(OutreTokens.comma),
      constructOffset1ScanFn(OutreTokens.semi),
      constructOffset1ScanFn(OutreTokens.question),
      constructOffset1ScanFn(OutreTokens.colon),
      constructOffset1ScanFn(OutreTokens.plus),
      constructOffset1ScanFn(OutreTokens.minus),
      constructOffset1ScanFn(OutreTokens.asterisk),
      constructOffset1ScanFn(OutreTokens.slash),
      constructOffset1ScanFn(OutreTokens.modulo),
      constructOffset1ScanFn(OutreTokens.ampersand),
      constructOffset1ScanFn(OutreTokens.pipe),
      constructOffset1ScanFn(OutreTokens.caret),
      constructOffset1ScanFn(OutreTokens.tilde),
      constructOffset1ScanFn(OutreTokens.assign),
      constructOffset1ScanFn(OutreTokens.bang),
      constructOffset1ScanFn(OutreTokens.lesserThan),
      constructOffset1ScanFn(OutreTokens.greaterThan),
    ],
  );

  static final Map<String, OutreScannerRuleReadFn> offset2ScanFns =
      Map<String, OutreScannerRuleReadFn>.fromEntries(
    <MapEntry<String, OutreScannerRuleReadFn>>[
      constructOffset2ScanFn(OutreTokens.nullAccess),
      constructOffset2ScanFn(OutreTokens.nullOr),
      constructOffset2ScanFn(OutreTokens.declare),
      constructOffset2ScanFn(OutreTokens.exponent),
      constructOffset2ScanFn(OutreTokens.floor),
      constructOffset2ScanFn(OutreTokens.logicalAnd),
      constructOffset2ScanFn(OutreTokens.logicalOr),
      constructOffset2ScanFn(OutreTokens.equal),
      constructOffset2ScanFn(OutreTokens.notEqual),
      constructOffset2ScanFn(OutreTokens.lesserThanEqual),
      constructOffset2ScanFn(OutreTokens.greaterThanEqual),
    ],
  );

  static List<OutreScannerCustomRule> customScanFns = <OutreScannerCustomRule>[
    OutreStringScanner.rule,
    OutreNumberScanner.rule,
    OutreIdentifierScanner.rule,
  ];

  static OutreToken scan(
    final OutreScanner scanner,
    final OutreInputIteration current,
  ) {
    if (current.char.isEmpty) {
      return scanEndOfFile(scanner, current);
    }

    final OutreScannerRuleReadFn scanFn = getOffset2ScanFn(scanner, current) ??
        getOffset1ScanFn(scanner, current) ??
        getCustomScanFn(scanner, current) ??
        scanInvalidToken;

    return scanFn(scanner, current);
  }

  static OutreScannerRuleReadFn? getCustomScanFn(
    final OutreScanner scanner,
    final OutreInputIteration current,
  ) {
    OutreScannerRuleReadFn? fn;
    for (final OutreScannerCustomRule x in customScanFns) {
      if (x.matches(scanner, current)) {
        fn = x.scan;
        break;
      }
    }
    return fn;
  }

  static OutreScannerRuleReadFn? getOffset1ScanFn(
    final OutreScanner scanner,
    final OutreInputIteration current,
  ) =>
      offset1ScanFns[scanner.input.getCharactersAt(current.point.position, 1)];

  static OutreScannerRuleReadFn? getOffset2ScanFn(
    final OutreScanner scanner,
    final OutreInputIteration current,
  ) =>
      offset2ScanFns[scanner.input.getCharactersAt(current.point.position, 2)];

  static MapEntry<String, OutreScannerRuleReadFn> constructOffset1ScanFn(
    final OutreTokens type,
  ) =>
      constructOffsetScanFn(type, 1);

  static MapEntry<String, OutreScannerRuleReadFn> constructOffset2ScanFn(
    final OutreTokens type,
  ) =>
      constructOffsetScanFn(type, 2);

  static MapEntry<String, OutreScannerRuleReadFn> constructOffsetScanFn(
    final OutreTokens type,
    final int offset,
  ) =>
      MapEntry<String, OutreScannerRuleReadFn>(
        type.code,
        (final OutreScanner scanner, final OutreInputIteration current) {
          final OutreStrictStringBuffer buffer =
              OutreStrictStringBuffer(current.char);

          OutreInputIteration end = current;
          for (int i = 0; i < offset - 1; i++) {
            end = scanner.input.advance();
            buffer.write(end.char);
          }

          return OutreToken(
            type,
            buffer.toString(),
            OutreSpan(current.point, end.point),
          );
        },
      );

  static OutreToken scanComment(
    final OutreScanner scanner,
    final OutreInputIteration current,
  ) {
    while (!scanner.input.isEndOfLine()) {
      scanner.input.advance();
    }
    scanner.input.advance();
    return scanner.readToken();
  }

  static OutreToken scanInvalidToken(
    final OutreScanner scanner,
    final OutreInputIteration current,
  ) =>
      OutreToken(
        OutreTokens.illegal,
        current.char,
        OutreSpan.single(current.point),
      );

  static OutreToken scanEndOfFile(
    final OutreScanner scanner,
    final OutreInputIteration current,
  ) =>
      OutreToken(
        OutreTokens.eof,
        current.char,
        OutreSpan.single(current.point),
      );
}
