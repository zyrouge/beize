import '../utils/exports.dart';
import 'illegal_expression.dart';

class OutreParserException extends Error {
  OutreParserException(this.message);

  factory OutreParserException.withIllegalExpressions(
    final String message,
    final List<OutreIllegalExpressionError> errors,
  ) =>
      OutreParserException(
        <String>[
          message,
          'Found ${errors.length} illegal expressions:',
          ...errors.map(
            (final OutreIllegalExpressionError err) =>
                '${OutreUtils.tab} ${err.text}',
          ),
        ].join('\n'),
      );

  final String message;

  @override
  String toString() => 'OutreParserException: $message';
}
