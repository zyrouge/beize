enum BeizeValueKind {
  boolean,
  function,
  nativeFunction,
  nativeAsyncFunction,
  unawaited,
  nullValue,
  number,
  string,
  object,
  list,
  module,
  primitiveObject,
  exception,
}

final Map<BeizeValueKind, String> _kindCodeMap = <BeizeValueKind, String>{
  BeizeValueKind.boolean: 'Boolean',
  BeizeValueKind.function: 'Function',
  BeizeValueKind.nativeFunction: 'NativeFunction',
  BeizeValueKind.nativeAsyncFunction: 'NativeAsyncFunction',
  BeizeValueKind.nullValue: 'Null',
  BeizeValueKind.number: 'Number',
  BeizeValueKind.string: 'String',
  BeizeValueKind.object: 'Object',
  BeizeValueKind.list: 'List',
  BeizeValueKind.module: 'Module',
  BeizeValueKind.primitiveObject: 'PrimitiveObject',
  BeizeValueKind.exception: 'Exception',
};

extension BeizeValueKindUtils on BeizeValueKind {
  String get code => _kindCodeMap[this]!;
}
