enum BeizeValueKind {
  boolean,
  function,
  unawaited,
  nullValue,
  number,
  string,
  object,
  list,
  module,
  exception,
}

final Map<BeizeValueKind, String> _kindCodeMap = <BeizeValueKind, String>{
  BeizeValueKind.boolean: 'Boolean',
  BeizeValueKind.function: 'Function',
  BeizeValueKind.unawaited: 'Unawaited',
  BeizeValueKind.nullValue: 'Null',
  BeizeValueKind.number: 'Number',
  BeizeValueKind.string: 'String',
  BeizeValueKind.object: 'Object',
  BeizeValueKind.list: 'List',
  BeizeValueKind.module: 'Module',
  BeizeValueKind.exception: 'Exception',
};

extension BeizeValueKindUtils on BeizeValueKind {
  String get code => _kindCodeMap[this]!;
}
