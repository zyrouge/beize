import '../token/exports.dart';

class FubukiCompilationException implements Exception {
  FubukiCompilationException(this.module, this.text);

  factory FubukiCompilationException.illegalToken(
    final String module,
    final FubukiToken token,
  ) =>
      FubukiCompilationException(
        module,
        <String>[
          'Illegal token "${token.type.code}" found at ${token.span}',
          if (token.error != null)
            '(${token.error}${token.errorSpan != null ? ' at ${token.errorSpan}' : ''})',
        ].join(' '),
      );

  factory FubukiCompilationException.expectedXButReceivedX(
    final String module,
    final String expected,
    final String received,
    final String position,
  ) =>
      FubukiCompilationException(
        module,
        'Expected "$expected" but found "$received" at $position',
      );

  factory FubukiCompilationException.expectedXButReceivedToken(
    final String module,
    final String expected,
    final FubukiTokens received,
    final FubukiSpan span,
  ) =>
      FubukiCompilationException.expectedXButReceivedX(
        module,
        expected,
        received.code,
        span.toString(),
      );

  factory FubukiCompilationException.expectedTokenButReceivedToken(
    final String module,
    final FubukiTokens expected,
    final FubukiTokens received,
    final FubukiSpan span,
  ) =>
      FubukiCompilationException.expectedXButReceivedX(
        module,
        expected.code,
        received.code,
        span.toString(),
      );

  factory FubukiCompilationException.cannotReturnInsideScript(
    final String module,
    final FubukiToken token,
  ) =>
      FubukiCompilationException(
        module,
        'Cannot return inside script ("${token.type.code}" found at ${token.span})',
      );

  factory FubukiCompilationException.cannotBreakContinueOutsideLoop(
    final String module,
    final FubukiToken token,
  ) =>
      FubukiCompilationException(
        module,
        'Cannot break or continue outside script ("${token.type.code}" found at ${token.span})',
      );

  factory FubukiCompilationException.topLevelImports(
    final String module,
    final FubukiToken token,
  ) =>
      FubukiCompilationException(
        module,
        'Only top-level imports are allowed ("${token.type.code}" found at ${token.span})',
      );

  factory FubukiCompilationException.duplicateElse(
    final String module,
    final FubukiToken token,
  ) =>
      FubukiCompilationException(
        module,
        'Multiple else classes are not allowed ("${token.type.code}" found at ${token.span})',
      );

  factory FubukiCompilationException.cannotAwaitOutsideAsyncFunction(
    final String module,
    final FubukiToken token,
  ) =>
      FubukiCompilationException(
        module,
        'Cannot "await" outside of "async" function ("${token.type.code}" found at ${token.span})',
      );

  final String module;
  final String text;

  @override
  String toString() =>
      'FubukiCompilationException: Compiling "$module" failed - $text';
}
