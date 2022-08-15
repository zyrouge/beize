import '../../lexer/exports.dart';
import '../../node/exports.dart';
import '../expressions/exports.dart';
import 'statement.dart';

class OutreTryCatchStatement extends OutreStatement {
  const OutreTryCatchStatement(
    this.tryKw,
    this.tryBlock,
    this.catchKw,
    this.catchParams,
    this.catchBlock,
  ) : super(OutreNodes.tryCatchStmt);

  factory OutreTryCatchStatement.fromJson(final Map<dynamic, dynamic> json) =>
      OutreTryCatchStatement(
        OutreNode.fromJson(json['tryKw']),
        OutreNode.fromJson(json['tryBlock']),
        OutreNode.fromJson(json['catchKw']),
        OutreNode.fromJsonList(json['catchParams']),
        OutreNode.fromJson(json['catchBlock']),
      );

  final OutreToken tryKw;
  final OutreStatement tryBlock;
  final OutreToken catchKw;
  final List<OutreExpression> catchParams;
  final OutreStatement catchBlock;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'tryKw': tryKw.toJson(),
        'tryBlock': tryBlock.toJson(),
        'catchKw': catchKw.toJson(),
        'catchParams': OutreNode.toJsonList(catchParams),
        'catchBlock': catchBlock.toJson(),
      };

  @override
  OutreSpan get span => OutreSpan(tryKw.span.start, catchBlock.span.end);
}
