import '../../lexer/exports.dart';
import '../../node/exports.dart';
import '../expressions/exports.dart';
import 'statement.dart';

class OutreImportStatement extends OutreStatement {
  const OutreImportStatement(
    this.importKw,
    this.path,
    this.asKw,
    this.name,
  ) : super(OutreNodes.importStmt);

  factory OutreImportStatement.fromJson(final Map<dynamic, dynamic> json) =>
      OutreImportStatement(
        OutreNode.fromJson(json['importKw']),
        OutreNode.fromJson(json['path']),
        OutreNode.fromJson(json['asKw']),
        OutreNode.fromJson(json['name']),
      );

  final OutreToken importKw;
  final OutreExpression path;
  final OutreToken asKw;
  final OutreExpression name;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'importKw': importKw.toJson(),
        'path': path.toJson(),
        'asKw': asKw.toJson(),
        'name': name.toJson(),
      };

  @override
  OutreSpan get span => OutreSpan(importKw.span.start, path.span.end);
}
