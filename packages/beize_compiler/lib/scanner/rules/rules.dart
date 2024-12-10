import '../../lexer/exports.dart';
import '../../token/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'identifier.dart';
import 'number.dart';
import 'string.dart';

typedef BeizeScannerRuleMatchFn = bool Function(
  BeizeScanner scanner,
  BeizeInputIteration current,
);

typedef BeizeScannerRuleReadFn = BeizeToken Function(
  BeizeScanner scanner,
  BeizeInputIteration current,
);

class BeizeScannerCustomRule {
  const BeizeScannerCustomRule(this.matches, this.scan);

  final BeizeScannerRuleMatchFn matches;
  final BeizeScannerRuleReadFn scan;
}

class BeizeScannerRules {
  static final Map<String, BeizeScannerRuleReadFn> offset1ScanFns =
      Map<String, BeizeScannerRuleReadFn>.fromEntries(
    <MapEntry<String, BeizeScannerRuleReadFn>>[
      MapEntry<String, BeizeScannerRuleReadFn>(
        BeizeTokens.hash.code,
        scanComment,
      ),
      constructOffset1ScanFn(BeizeTokens.parenLeft),
      constructOffset1ScanFn(BeizeTokens.parenRight),
      constructOffset1ScanFn(BeizeTokens.bracketLeft),
      constructOffset1ScanFn(BeizeTokens.bracketRight),
      constructOffset1ScanFn(BeizeTokens.braceLeft),
      constructOffset1ScanFn(BeizeTokens.braceRight),
      constructOffset1ScanFn(BeizeTokens.dot),
      constructOffset1ScanFn(BeizeTokens.comma),
      constructOffset1ScanFn(BeizeTokens.semi),
      constructOffset1ScanFn(BeizeTokens.question),
      constructOffset1ScanFn(BeizeTokens.colon),
      constructOffset1ScanFn(BeizeTokens.plus),
      constructOffset1ScanFn(BeizeTokens.minus),
      constructOffset1ScanFn(BeizeTokens.asterisk),
      constructOffset1ScanFn(BeizeTokens.slash),
      constructOffset1ScanFn(BeizeTokens.modulo),
      constructOffset1ScanFn(BeizeTokens.ampersand),
      constructOffset1ScanFn(BeizeTokens.pipe),
      constructOffset1ScanFn(BeizeTokens.caret),
      constructOffset1ScanFn(BeizeTokens.tilde),
      constructOffset1ScanFn(BeizeTokens.assign),
      constructOffset1ScanFn(BeizeTokens.bang),
      constructOffset1ScanFn(BeizeTokens.lesserThan),
      constructOffset1ScanFn(BeizeTokens.greaterThan),
      constructOffset1ScanFn(BeizeTokens.dollar),
    ],
  );

  static final Map<String, BeizeScannerRuleReadFn> offset2ScanFns =
      Map<String, BeizeScannerRuleReadFn>.fromEntries(
    <MapEntry<String, BeizeScannerRuleReadFn>>[
      constructOffset2ScanFn(BeizeTokens.nullAccess),
      constructOffset2ScanFn(BeizeTokens.nullOr),
      constructOffset2ScanFn(BeizeTokens.declare),
      constructOffset2ScanFn(BeizeTokens.exponent),
      constructOffset2ScanFn(BeizeTokens.floor),
      constructOffset2ScanFn(BeizeTokens.logicalAnd),
      constructOffset2ScanFn(BeizeTokens.logicalOr),
      constructOffset2ScanFn(BeizeTokens.equal),
      constructOffset2ScanFn(BeizeTokens.notEqual),
      constructOffset2ScanFn(BeizeTokens.lesserThanEqual),
      constructOffset2ScanFn(BeizeTokens.greaterThanEqual),
      constructOffset2ScanFn(BeizeTokens.rightArrow),
      constructOffset2ScanFn(BeizeTokens.increment),
      constructOffset2ScanFn(BeizeTokens.decrement),
      constructOffset2ScanFn(BeizeTokens.plusEqual),
      constructOffset2ScanFn(BeizeTokens.minusEqual),
      constructOffset2ScanFn(BeizeTokens.asteriskEqual),
      constructOffset2ScanFn(BeizeTokens.slashEqual),
      constructOffset2ScanFn(BeizeTokens.moduloEqual),
      constructOffset2ScanFn(BeizeTokens.ampersandEqual),
      constructOffset2ScanFn(BeizeTokens.pipeEqual),
      constructOffset2ScanFn(BeizeTokens.caretEqual),
    ],
  );

  static final Map<String, BeizeScannerRuleReadFn> offset3ScanFns =
      Map<String, BeizeScannerRuleReadFn>.fromEntries(
    <MapEntry<String, BeizeScannerRuleReadFn>>[
      constructOffset3ScanFn(BeizeTokens.exponentEqual),
      constructOffset3ScanFn(BeizeTokens.floorEqual),
      constructOffset3ScanFn(BeizeTokens.logicalAndEqual),
      constructOffset3ScanFn(BeizeTokens.logicalOrEqual),
      constructOffset3ScanFn(BeizeTokens.nullOrEqual),
    ],
  );

  static List<BeizeScannerCustomRule> customScanFns = <BeizeScannerCustomRule>[
    BeizeStringScanner.rule,
    BeizeNumberScanner.rule,
    BeizeIdentifierScanner.rule,
  ];

  static BeizeToken scan(
    final BeizeScanner scanner,
    final BeizeInputIteration current,
  ) {
    if (current.char.isEmpty) {
      return scanEndOfFile(scanner, current);
    }

    final BeizeScannerRuleReadFn scanFn = getOffset3ScanFn(scanner, current) ??
        getOffset2ScanFn(scanner, current) ??
        getOffset1ScanFn(scanner, current) ??
        getCustomScanFn(scanner, current) ??
        scanInvalidToken;

    return scanFn(scanner, current);
  }

  static BeizeScannerRuleReadFn? getCustomScanFn(
    final BeizeScanner scanner,
    final BeizeInputIteration current,
  ) {
    BeizeScannerRuleReadFn? fn;
    for (final BeizeScannerCustomRule x in customScanFns) {
      if (x.matches(scanner, current)) {
        fn = x.scan;
        break;
      }
    }
    return fn;
  }

  static BeizeScannerRuleReadFn? getOffset1ScanFn(
    final BeizeScanner scanner,
    final BeizeInputIteration current,
  ) =>
      offset1ScanFns[scanner.input.getCharactersAt(current.point.position, 1)];

  static BeizeScannerRuleReadFn? getOffset2ScanFn(
    final BeizeScanner scanner,
    final BeizeInputIteration current,
  ) =>
      offset2ScanFns[scanner.input.getCharactersAt(current.point.position, 2)];

  static BeizeScannerRuleReadFn? getOffset3ScanFn(
    final BeizeScanner scanner,
    final BeizeInputIteration current,
  ) =>
      offset3ScanFns[scanner.input.getCharactersAt(current.point.position, 3)];

  static MapEntry<String, BeizeScannerRuleReadFn> constructOffset1ScanFn(
    final BeizeTokens type,
  ) =>
      constructOffsetScanFn(type, 1);

  static MapEntry<String, BeizeScannerRuleReadFn> constructOffset2ScanFn(
    final BeizeTokens type,
  ) =>
      constructOffsetScanFn(type, 2);

  static MapEntry<String, BeizeScannerRuleReadFn> constructOffset3ScanFn(
    final BeizeTokens type,
  ) =>
      constructOffsetScanFn(type, 3);

  static MapEntry<String, BeizeScannerRuleReadFn> constructOffsetScanFn(
    final BeizeTokens type,
    final int offset,
  ) =>
      MapEntry<String, BeizeScannerRuleReadFn>(
        type.code,
        (final BeizeScanner scanner, final BeizeInputIteration current) {
          final BeizeStringBuffer buffer = BeizeStringBuffer(current.char);

          BeizeInputIteration end = current;
          for (int i = 0; i < offset - 1; i++) {
            end = scanner.input.advance();
            buffer.write(end.char);
          }

          return BeizeToken(
            type,
            buffer.toString(),
            BeizeSpan(current.point, end.point),
          );
        },
      );

  static BeizeToken scanComment(
    final BeizeScanner scanner,
    final BeizeInputIteration current,
  ) {
    while (!scanner.input.isEndOfLine()) {
      scanner.input.advance();
    }
    scanner.input.advance();
    return scanner.readToken();
  }

  static BeizeToken scanInvalidToken(
    final BeizeScanner scanner,
    final BeizeInputIteration current,
  ) =>
      BeizeToken(
        BeizeTokens.illegal,
        current.char,
        BeizeSpan.fromSingleCursor(current.point),
      );

  static BeizeToken scanEndOfFile(
    final BeizeScanner scanner,
    final BeizeInputIteration current,
  ) =>
      BeizeToken(
        BeizeTokens.eof,
        current.char,
        BeizeSpan.fromSingleCursor(current.point),
      );
}
