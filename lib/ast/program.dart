import '../node/exports.dart';
import 'statements/exports.dart';

class OutreProgram extends OutreNode {
  const OutreProgram(this.statements) : super(OutreNodes.program);

  factory OutreProgram.fromJson(final Map<dynamic, dynamic> json) =>
      OutreProgram(OutreNode.fromJsonList(json['statements']));

  final List<OutreStatement> statements;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'statements': OutreNode.toJsonList(statements),
      };
}
