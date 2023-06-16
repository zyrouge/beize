import '../token/exports.dart';

class BeizeCompilationException implements Exception {
  BeizeCompilationException(this.module, this.text);

  factory BeizeCompilationException.illegalToken(
    final String module,
    final BeizeToken token,
  ) =>
      BeizeCompilationException(
        module,
        <String>[
          'Illegal token "${token.type.code}" found at ${token.span}',
          if (token.error != null)
            '(${token.error}${token.errorSpan != null ? ' at ${token.errorSpan}' : ''})',
        ].join(' '),
      );

  factory BeizeCompilationException.expectedXButReceivedX(
    final String module,
    final String expected,
    final String received,
    final String position,
  ) =>
      BeizeCompilationException(
        module,
        'Expected "$expected" but found "$received" at $position',
      );

  factory BeizeCompilationException.expectedXButReceivedToken(
    final String module,
    final String expected,
    final BeizeTokens received,
    final BeizeSpan span,
  ) =>
      BeizeCompilationException.expectedXButReceivedX(
        module,
        expected,
        received.code,
        span.toString(),
      );

  factory BeizeCompilationException.expectedTokenButReceivedToken(
    final String module,
    final BeizeTokens expected,
    final BeizeTokens received,
    final BeizeSpan span,
  ) =>
      BeizeCompilationException.expectedXButReceivedX(
        module,
        expected.code,
        received.code,
        span.toString(),
      );

  factory BeizeCompilationException.cannotReturnInsideScript(
    final String module,
    final BeizeToken token,
  ) =>
      BeizeCompilationException(
        module,
        'Cannot return inside script ("${token.type.code}" found at ${token.span})',
      );

  factory BeizeCompilationException.cannotBreakContinueOutsideLoop(
    final String module,
    final BeizeToken token,
  ) =>
      BeizeCompilationException(
        module,
        'Cannot break or continue outside script ("${token.type.code}" found at ${token.span})',
      );

  factory BeizeCompilationException.topLevelImports(
    final String module,
    final BeizeToken token,
  ) =>
      BeizeCompilationException(
        module,
        'Only top-level imports are allowed ("${token.type.code}" found at ${token.span})',
      );

  factory BeizeCompilationException.duplicateElse(
    final String module,
    final BeizeToken token,
  ) =>
      BeizeCompilationException(
        module,
        'Multiple else classes are not allowed ("${token.type.code}" found at ${token.span})',
      );

  factory BeizeCompilationException.cannotAwaitOutsideAsyncFunction(
    final String module,
    final BeizeToken token,
  ) =>
      BeizeCompilationException(
        module,
        'Cannot "await" outside of "async" function ("${token.type.code}" found at ${token.span})',
      );

  final String module;
  final String text;

  @override
  String toString() =>
      'BeizeCompilationException: Compiling "$module" failed - $text';
}
