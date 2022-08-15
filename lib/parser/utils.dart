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

  static void assertNodeTypeAny(
    final List<OutreNodes> expected,
    final OutreNode node,
  ) {
    if (!expected.any((final OutreNodes x) => node.kind == x)) {
      throw OutreIllegalExpressionError.expectedXButReceivedX(
        expected.map((final OutreNodes x) => x.code).join(' || '),
        node.kind.code,
        node.span.toPositionString(),
      );
    }
  }

  static void assertNodesType(
    final OutreNodes expected,
    final List<OutreNode> nodes,
  ) {
    for (final OutreNode x in nodes) {
      assertNodeType(expected, x);
    }
  }

  static const List<OutreNodes> assignableNodeKinds = <OutreNodes>[
    OutreNodes.identifierExpr,
    OutreNodes.indexAccessExpr,
  ];
  static void assertAssignableNode(final OutreNode node) {
    assertNodeTypeAny(assignableNodeKinds, node);
  }
}
