import '../../node/exports.dart';

class OutreSpanPoint extends OutreNode {
  const OutreSpanPoint({
    this.position = 0,
    this.row = 0,
    this.column = 0,
  }) : super(OutreNodes.spanPoint);

  factory OutreSpanPoint.fromPositionString(final String value) {
    final RegExpMatch match = RegExp(r'(\d+):(\d+)@(\d+)').firstMatch(value)!;
    return OutreSpanPoint(
      position: int.parse(match.group(1)!) - 1,
      row: int.parse(match.group(2)!) - 1,
      column: int.parse(match.group(3)!) - 1,
    );
  }

  factory OutreSpanPoint.fromJson(final Map<dynamic, dynamic> json) =>
      OutreSpanPoint(
        position: json['position'] as int,
        row: json['row'] as int,
        column: json['column'] as int,
      );

  final int position;
  final int row;
  final int column;

  OutreSpanPoint add({
    final int position = 0,
    final int row = 0,
    final int column = 0,
  }) =>
      OutreSpanPoint(
        position: this.position + position,
        row: this.row + row,
        column: this.column + column,
      );

  OutreSpanPoint copyWith({
    final int? position,
    final int? row,
    final int? column,
  }) =>
      OutreSpanPoint(
        position: position ?? this.position,
        row: row ?? this.row,
        column: column ?? this.column,
      );

  OutreSpan toOutreSpan() => OutreSpan(this, this);

  String toPositionString() => '${row + 1}:${column + 1}@${position + 1}';

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'position': position,
        'row': row,
        'column': column,
      };

  @override
  OutreSpan get span => toOutreSpan();
}

class OutreSpan extends OutreNode {
  const OutreSpan(this.start, this.end) : super(OutreNodes.span);

  factory OutreSpan.single(final OutreSpanPoint start) =>
      OutreSpan(start, start);

  factory OutreSpan.fromJson(final Map<dynamic, dynamic> json) => OutreSpan(
        OutreNode.fromJson(json['start']),
        OutreNode.fromJson(json['end']),
      );

  final OutreSpanPoint start;
  final OutreSpanPoint end;

  bool areSameMarker() => start.position == end.position;

  String toPositionString() => areSameMarker()
      ? start.toPositionString()
      : '${start.toPositionString()} - ${end.toPositionString()}';

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'start': start.toJson(),
        'end': end.toJson(),
      };

  @override
  OutreSpan get span => this;
}
