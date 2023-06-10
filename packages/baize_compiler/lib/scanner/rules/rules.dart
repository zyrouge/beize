import '../../lexer/exports.dart';
import '../../token/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'identifier.dart';
import 'number.dart';
import 'string.dart';

typedef BaizeScannerRuleMatchFn = bool Function(
  BaizeScanner scanner,
  BaizeInputIteration current,
);

typedef BaizeScannerRuleReadFn = BaizeToken Function(
  BaizeScanner scanner,
  BaizeInputIteration current,
);

class BaizeScannerCustomRule {
  const BaizeScannerCustomRule(this.matches, this.scan);

  final BaizeScannerRuleMatchFn matches;
  final BaizeScannerRuleReadFn scan;
}

class BaizeScannerRules {
  static final Map<String, BaizeScannerRuleReadFn> offset1ScanFns =
      Map<String, BaizeScannerRuleReadFn>.fromEntries(
    <MapEntry<String, BaizeScannerRuleReadFn>>[
      MapEntry<String, BaizeScannerRuleReadFn>(
        BaizeTokens.hash.code,
        scanComment,
      ),
      constructOffset1ScanFn(BaizeTokens.parenLeft),
      constructOffset1ScanFn(BaizeTokens.parenRight),
      constructOffset1ScanFn(BaizeTokens.bracketLeft),
      constructOffset1ScanFn(BaizeTokens.bracketRight),
      constructOffset1ScanFn(BaizeTokens.braceLeft),
      constructOffset1ScanFn(BaizeTokens.braceRight),
      constructOffset1ScanFn(BaizeTokens.dot),
      constructOffset1ScanFn(BaizeTokens.comma),
      constructOffset1ScanFn(BaizeTokens.semi),
      constructOffset1ScanFn(BaizeTokens.question),
      constructOffset1ScanFn(BaizeTokens.colon),
      constructOffset1ScanFn(BaizeTokens.plus),
      constructOffset1ScanFn(BaizeTokens.minus),
      constructOffset1ScanFn(BaizeTokens.asterisk),
      constructOffset1ScanFn(BaizeTokens.slash),
      constructOffset1ScanFn(BaizeTokens.modulo),
      constructOffset1ScanFn(BaizeTokens.ampersand),
      constructOffset1ScanFn(BaizeTokens.pipe),
      constructOffset1ScanFn(BaizeTokens.caret),
      constructOffset1ScanFn(BaizeTokens.tilde),
      constructOffset1ScanFn(BaizeTokens.assign),
      constructOffset1ScanFn(BaizeTokens.bang),
      constructOffset1ScanFn(BaizeTokens.lesserThan),
      constructOffset1ScanFn(BaizeTokens.greaterThan),
    ],
  );

  static final Map<String, BaizeScannerRuleReadFn> offset2ScanFns =
      Map<String, BaizeScannerRuleReadFn>.fromEntries(
    <MapEntry<String, BaizeScannerRuleReadFn>>[
      constructOffset2ScanFn(BaizeTokens.nullAccess),
      constructOffset2ScanFn(BaizeTokens.nullOr),
      constructOffset2ScanFn(BaizeTokens.declare),
      constructOffset2ScanFn(BaizeTokens.exponent),
      constructOffset2ScanFn(BaizeTokens.floor),
      constructOffset2ScanFn(BaizeTokens.logicalAnd),
      constructOffset2ScanFn(BaizeTokens.logicalOr),
      constructOffset2ScanFn(BaizeTokens.equal),
      constructOffset2ScanFn(BaizeTokens.notEqual),
      constructOffset2ScanFn(BaizeTokens.lesserThanEqual),
      constructOffset2ScanFn(BaizeTokens.greaterThanEqual),
      constructOffset2ScanFn(BaizeTokens.rightArrow),
      constructOffset2ScanFn(BaizeTokens.increment),
      constructOffset2ScanFn(BaizeTokens.decrement),
      constructOffset2ScanFn(BaizeTokens.plusEqual),
      constructOffset2ScanFn(BaizeTokens.minusEqual),
      constructOffset2ScanFn(BaizeTokens.asteriskEqual),
      constructOffset2ScanFn(BaizeTokens.slashEqual),
      constructOffset2ScanFn(BaizeTokens.moduloEqual),
      constructOffset2ScanFn(BaizeTokens.ampersandEqual),
      constructOffset2ScanFn(BaizeTokens.pipeEqual),
      constructOffset2ScanFn(BaizeTokens.caretEqual),
    ],
  );

  static final Map<String, BaizeScannerRuleReadFn> offset3ScanFns =
      Map<String, BaizeScannerRuleReadFn>.fromEntries(
    <MapEntry<String, BaizeScannerRuleReadFn>>[
      constructOffset3ScanFn(BaizeTokens.exponentEqual),
      constructOffset3ScanFn(BaizeTokens.floorEqual),
      constructOffset3ScanFn(BaizeTokens.logicalAndEqual),
      constructOffset3ScanFn(BaizeTokens.logicalOrEqual),
      constructOffset3ScanFn(BaizeTokens.nullOrEqual),
    ],
  );

  static List<BaizeScannerCustomRule> customScanFns =
      <BaizeScannerCustomRule>[
    BaizeStringScanner.rule,
    BaizeNumberScanner.rule,
    BaizeIdentifierScanner.rule,
  ];

  static BaizeToken scan(
    final BaizeScanner scanner,
    final BaizeInputIteration current,
  ) {
    if (current.char.isEmpty) {
      return scanEndOfFile(scanner, current);
    }

    final BaizeScannerRuleReadFn scanFn = getOffset3ScanFn(scanner, current) ??
        getOffset2ScanFn(scanner, current) ??
        getOffset1ScanFn(scanner, current) ??
        getCustomScanFn(scanner, current) ??
        scanInvalidToken;

    return scanFn(scanner, current);
  }

  static BaizeScannerRuleReadFn? getCustomScanFn(
    final BaizeScanner scanner,
    final BaizeInputIteration current,
  ) {
    BaizeScannerRuleReadFn? fn;
    for (final BaizeScannerCustomRule x in customScanFns) {
      if (x.matches(scanner, current)) {
        fn = x.scan;
        break;
      }
    }
    return fn;
  }

  static BaizeScannerRuleReadFn? getOffset1ScanFn(
    final BaizeScanner scanner,
    final BaizeInputIteration current,
  ) =>
      offset1ScanFns[scanner.input.getCharactersAt(current.point.position, 1)];

  static BaizeScannerRuleReadFn? getOffset2ScanFn(
    final BaizeScanner scanner,
    final BaizeInputIteration current,
  ) =>
      offset2ScanFns[scanner.input.getCharactersAt(current.point.position, 2)];

  static BaizeScannerRuleReadFn? getOffset3ScanFn(
    final BaizeScanner scanner,
    final BaizeInputIteration current,
  ) =>
      offset3ScanFns[scanner.input.getCharactersAt(current.point.position, 3)];

  static MapEntry<String, BaizeScannerRuleReadFn> constructOffset1ScanFn(
    final BaizeTokens type,
  ) =>
      constructOffsetScanFn(type, 1);

  static MapEntry<String, BaizeScannerRuleReadFn> constructOffset2ScanFn(
    final BaizeTokens type,
  ) =>
      constructOffsetScanFn(type, 2);

  static MapEntry<String, BaizeScannerRuleReadFn> constructOffset3ScanFn(
    final BaizeTokens type,
  ) =>
      constructOffsetScanFn(type, 3);

  static MapEntry<String, BaizeScannerRuleReadFn> constructOffsetScanFn(
    final BaizeTokens type,
    final int offset,
  ) =>
      MapEntry<String, BaizeScannerRuleReadFn>(
        type.code,
        (final BaizeScanner scanner, final BaizeInputIteration current) {
          final BaizeStringBuffer buffer = BaizeStringBuffer(current.char);

          BaizeInputIteration end = current;
          for (int i = 0; i < offset - 1; i++) {
            end = scanner.input.advance();
            buffer.write(end.char);
          }

          return BaizeToken(
            type,
            buffer.toString(),
            BaizeSpan(current.point, end.point),
          );
        },
      );

  static BaizeToken scanComment(
    final BaizeScanner scanner,
    final BaizeInputIteration current,
  ) {
    while (!scanner.input.isEndOfLine()) {
      scanner.input.advance();
    }
    scanner.input.advance();
    return scanner.readToken();
  }

  static BaizeToken scanInvalidToken(
    final BaizeScanner scanner,
    final BaizeInputIteration current,
  ) =>
      BaizeToken(
        BaizeTokens.illegal,
        current.char,
        BaizeSpan.fromSingleCursor(current.point),
      );

  static BaizeToken scanEndOfFile(
    final BaizeScanner scanner,
    final BaizeInputIteration current,
  ) =>
      BaizeToken(
        BaizeTokens.eof,
        current.char,
        BaizeSpan.fromSingleCursor(current.point),
      );
}
