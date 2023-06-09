import '../../lexer/exports.dart';
import '../../token/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'identifier.dart';
import 'number.dart';
import 'string.dart';

typedef FubukiScannerRuleMatchFn = bool Function(
  FubukiScanner scanner,
  FubukiInputIteration current,
);

typedef FubukiScannerRuleReadFn = FubukiToken Function(
  FubukiScanner scanner,
  FubukiInputIteration current,
);

class FubukiScannerCustomRule {
  const FubukiScannerCustomRule(this.matches, this.scan);

  final FubukiScannerRuleMatchFn matches;
  final FubukiScannerRuleReadFn scan;
}

class FubukiScannerRules {
  static final Map<String, FubukiScannerRuleReadFn> offset1ScanFns =
      Map<String, FubukiScannerRuleReadFn>.fromEntries(
    <MapEntry<String, FubukiScannerRuleReadFn>>[
      MapEntry<String, FubukiScannerRuleReadFn>(
        FubukiTokens.hash.code,
        scanComment,
      ),
      constructOffset1ScanFn(FubukiTokens.parenLeft),
      constructOffset1ScanFn(FubukiTokens.parenRight),
      constructOffset1ScanFn(FubukiTokens.bracketLeft),
      constructOffset1ScanFn(FubukiTokens.bracketRight),
      constructOffset1ScanFn(FubukiTokens.braceLeft),
      constructOffset1ScanFn(FubukiTokens.braceRight),
      constructOffset1ScanFn(FubukiTokens.dot),
      constructOffset1ScanFn(FubukiTokens.comma),
      constructOffset1ScanFn(FubukiTokens.semi),
      constructOffset1ScanFn(FubukiTokens.question),
      constructOffset1ScanFn(FubukiTokens.colon),
      constructOffset1ScanFn(FubukiTokens.plus),
      constructOffset1ScanFn(FubukiTokens.minus),
      constructOffset1ScanFn(FubukiTokens.asterisk),
      constructOffset1ScanFn(FubukiTokens.slash),
      constructOffset1ScanFn(FubukiTokens.modulo),
      constructOffset1ScanFn(FubukiTokens.ampersand),
      constructOffset1ScanFn(FubukiTokens.pipe),
      constructOffset1ScanFn(FubukiTokens.caret),
      constructOffset1ScanFn(FubukiTokens.tilde),
      constructOffset1ScanFn(FubukiTokens.assign),
      constructOffset1ScanFn(FubukiTokens.bang),
      constructOffset1ScanFn(FubukiTokens.lesserThan),
      constructOffset1ScanFn(FubukiTokens.greaterThan),
    ],
  );

  static final Map<String, FubukiScannerRuleReadFn> offset2ScanFns =
      Map<String, FubukiScannerRuleReadFn>.fromEntries(
    <MapEntry<String, FubukiScannerRuleReadFn>>[
      constructOffset2ScanFn(FubukiTokens.nullAccess),
      constructOffset2ScanFn(FubukiTokens.nullOr),
      constructOffset2ScanFn(FubukiTokens.declare),
      constructOffset2ScanFn(FubukiTokens.exponent),
      constructOffset2ScanFn(FubukiTokens.floor),
      constructOffset2ScanFn(FubukiTokens.logicalAnd),
      constructOffset2ScanFn(FubukiTokens.logicalOr),
      constructOffset2ScanFn(FubukiTokens.equal),
      constructOffset2ScanFn(FubukiTokens.notEqual),
      constructOffset2ScanFn(FubukiTokens.lesserThanEqual),
      constructOffset2ScanFn(FubukiTokens.greaterThanEqual),
      constructOffset2ScanFn(FubukiTokens.rightArrow),
      constructOffset2ScanFn(FubukiTokens.increment),
      constructOffset2ScanFn(FubukiTokens.decrement),
      constructOffset2ScanFn(FubukiTokens.plusEqual),
      constructOffset2ScanFn(FubukiTokens.minusEqual),
      constructOffset2ScanFn(FubukiTokens.asteriskEqual),
      constructOffset2ScanFn(FubukiTokens.slashEqual),
      constructOffset2ScanFn(FubukiTokens.moduloEqual),
      constructOffset2ScanFn(FubukiTokens.ampersandEqual),
      constructOffset2ScanFn(FubukiTokens.pipeEqual),
      constructOffset2ScanFn(FubukiTokens.caretEqual),
    ],
  );

  static final Map<String, FubukiScannerRuleReadFn> offset3ScanFns =
      Map<String, FubukiScannerRuleReadFn>.fromEntries(
    <MapEntry<String, FubukiScannerRuleReadFn>>[
      constructOffset3ScanFn(FubukiTokens.exponentEqual),
      constructOffset3ScanFn(FubukiTokens.floorEqual),
      constructOffset3ScanFn(FubukiTokens.logicalAndEqual),
      constructOffset3ScanFn(FubukiTokens.logicalOrEqual),
      constructOffset3ScanFn(FubukiTokens.nullOrEqual),
    ],
  );

  static List<FubukiScannerCustomRule> customScanFns =
      <FubukiScannerCustomRule>[
    FubukiStringScanner.rule,
    FubukiNumberScanner.rule,
    FubukiIdentifierScanner.rule,
  ];

  static FubukiToken scan(
    final FubukiScanner scanner,
    final FubukiInputIteration current,
  ) {
    if (current.char.isEmpty) {
      return scanEndOfFile(scanner, current);
    }

    final FubukiScannerRuleReadFn scanFn = getOffset3ScanFn(scanner, current) ??
        getOffset2ScanFn(scanner, current) ??
        getOffset1ScanFn(scanner, current) ??
        getCustomScanFn(scanner, current) ??
        scanInvalidToken;

    return scanFn(scanner, current);
  }

  static FubukiScannerRuleReadFn? getCustomScanFn(
    final FubukiScanner scanner,
    final FubukiInputIteration current,
  ) {
    FubukiScannerRuleReadFn? fn;
    for (final FubukiScannerCustomRule x in customScanFns) {
      if (x.matches(scanner, current)) {
        fn = x.scan;
        break;
      }
    }
    return fn;
  }

  static FubukiScannerRuleReadFn? getOffset1ScanFn(
    final FubukiScanner scanner,
    final FubukiInputIteration current,
  ) =>
      offset1ScanFns[scanner.input.getCharactersAt(current.point.position, 1)];

  static FubukiScannerRuleReadFn? getOffset2ScanFn(
    final FubukiScanner scanner,
    final FubukiInputIteration current,
  ) =>
      offset2ScanFns[scanner.input.getCharactersAt(current.point.position, 2)];

  static FubukiScannerRuleReadFn? getOffset3ScanFn(
    final FubukiScanner scanner,
    final FubukiInputIteration current,
  ) =>
      offset3ScanFns[scanner.input.getCharactersAt(current.point.position, 3)];

  static MapEntry<String, FubukiScannerRuleReadFn> constructOffset1ScanFn(
    final FubukiTokens type,
  ) =>
      constructOffsetScanFn(type, 1);

  static MapEntry<String, FubukiScannerRuleReadFn> constructOffset2ScanFn(
    final FubukiTokens type,
  ) =>
      constructOffsetScanFn(type, 2);

  static MapEntry<String, FubukiScannerRuleReadFn> constructOffset3ScanFn(
    final FubukiTokens type,
  ) =>
      constructOffsetScanFn(type, 3);

  static MapEntry<String, FubukiScannerRuleReadFn> constructOffsetScanFn(
    final FubukiTokens type,
    final int offset,
  ) =>
      MapEntry<String, FubukiScannerRuleReadFn>(
        type.code,
        (final FubukiScanner scanner, final FubukiInputIteration current) {
          final FubukiStringBuffer buffer = FubukiStringBuffer(current.char);

          FubukiInputIteration end = current;
          for (int i = 0; i < offset - 1; i++) {
            end = scanner.input.advance();
            buffer.write(end.char);
          }

          return FubukiToken(
            type,
            buffer.toString(),
            FubukiSpan(current.point, end.point),
          );
        },
      );

  static FubukiToken scanComment(
    final FubukiScanner scanner,
    final FubukiInputIteration current,
  ) {
    while (!scanner.input.isEndOfLine()) {
      scanner.input.advance();
    }
    scanner.input.advance();
    return scanner.readToken();
  }

  static FubukiToken scanInvalidToken(
    final FubukiScanner scanner,
    final FubukiInputIteration current,
  ) =>
      FubukiToken(
        FubukiTokens.illegal,
        current.char,
        FubukiSpan.fromSingleCursor(current.point),
      );

  static FubukiToken scanEndOfFile(
    final FubukiScanner scanner,
    final FubukiInputIteration current,
  ) =>
      FubukiToken(
        FubukiTokens.eof,
        current.char,
        FubukiSpan.fromSingleCursor(current.point),
      );
}
