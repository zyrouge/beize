import '../../lexer/exports.dart';
import '../../node/exports.dart';
import '../expressions/exports.dart';
import 'statement.dart';

class OutreTryCatchStatement extends OutreStatement {
  const OutreTryCatchStatement(
    this.tryKeyword,
    this.tryBlock,
    this.catchKeyword,
    this.catchParameters,
    this.catchBlock,
  ) : super(OutreNodes.tryCatchStmt);

  factory OutreTryCatchStatement.fromJson(final Map<dynamic, dynamic> json) =>
      OutreTryCatchStatement(
        OutreNode.fromJson(json['tryKeyword']),
        OutreNode.fromJson(json['tryBlock']),
        OutreNode.fromJson(json['catchKeyword']),
        OutreNode.fromJsonList(json['catchParameters']),
        OutreNode.fromJson(json['catchBlock']),
      );

  final OutreToken tryKeyword;
  final OutreStatement tryBlock;
  final OutreToken catchKeyword;
  final List<OutreExpression> catchParameters;
  final OutreStatement catchBlock;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'tryKeyword': tryKeyword.toJson(),
        'tryBlock': tryBlock.toJson(),
        'catchKeyword': catchKeyword.toJson(),
        'catchParameters': OutreNode.toJsonList(catchParameters),
        'catchBlock': catchBlock.toJson(),
      };

  @override
  OutreSpan get span => OutreSpan(tryKeyword.span.start, catchBlock.span.end);
}
