import '../errors/exports.dart';
import '../node/exports.dart';

abstract class OutreParserUtils {
  static void assertNodeType(
    final OutreNodes expected,
    final OutreNode node,
  ) {
    if (node.kind != expected) {
      throw OutreIllegalExpressionError.expectedXButReceivedX(
        expected.code,
        node.kind.code,
        node.span.toPositionString(),
      );
    }
  }

  static void assertNodeTypes(
    final OutreNodes expected,
    final List<OutreNode> nodes,
  ) {
    for (final OutreNode x in nodes) {
      assertNodeType(expected, x);
    }
  }
}
