import '../token/exports.dart';

class BaizeCompilationException implements Exception {
  BaizeCompilationException(this.module, this.text);

  factory BaizeCompilationException.illegalToken(
    final String module,
    final BaizeToken token,
  ) =>
      BaizeCompilationException(
        module,
        <String>[
          'Illegal token "${token.type.code}" found at ${token.span}',
          if (token.error != null)
            '(${token.error}${token.errorSpan != null ? ' at ${token.errorSpan}' : ''})',
        ].join(' '),
      );

  factory BaizeCompilationException.expectedXButReceivedX(
    final String module,
    final String expected,
    final String received,
    final String position,
  ) =>
      BaizeCompilationException(
        module,
        'Expected "$expected" but found "$received" at $position',
      );

  factory BaizeCompilationException.expectedXButReceivedToken(
    final String module,
    final String expected,
    final BaizeTokens received,
    final BaizeSpan span,
  ) =>
      BaizeCompilationException.expectedXButReceivedX(
        module,
        expected,
        received.code,
        span.toString(),
      );

  factory BaizeCompilationException.expectedTokenButReceivedToken(
    final String module,
    final BaizeTokens expected,
    final BaizeTokens received,
    final BaizeSpan span,
  ) =>
      BaizeCompilationException.expectedXButReceivedX(
        module,
        expected.code,
        received.code,
        span.toString(),
      );

  factory BaizeCompilationException.cannotReturnInsideScript(
    final String module,
    final BaizeToken token,
  ) =>
      BaizeCompilationException(
        module,
        'Cannot return inside script ("${token.type.code}" found at ${token.span})',
      );

  factory BaizeCompilationException.cannotBreakContinueOutsideLoop(
    final String module,
    final BaizeToken token,
  ) =>
      BaizeCompilationException(
        module,
        'Cannot break or continue outside script ("${token.type.code}" found at ${token.span})',
      );

  factory BaizeCompilationException.topLevelImports(
    final String module,
    final BaizeToken token,
  ) =>
      BaizeCompilationException(
        module,
        'Only top-level imports are allowed ("${token.type.code}" found at ${token.span})',
      );

  factory BaizeCompilationException.duplicateElse(
    final String module,
    final BaizeToken token,
  ) =>
      BaizeCompilationException(
        module,
        'Multiple else classes are not allowed ("${token.type.code}" found at ${token.span})',
      );

  factory BaizeCompilationException.cannotAwaitOutsideAsyncFunction(
    final String module,
    final BaizeToken token,
  ) =>
      BaizeCompilationException(
        module,
        'Cannot "await" outside of "async" function ("${token.type.code}" found at ${token.span})',
      );

  final String module;
  final String text;

  @override
  String toString() =>
      'BaizeCompilationException: Compiling "$module" failed - $text';
}
