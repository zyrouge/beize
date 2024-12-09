enum BeizeValueKind {
  boolean,
  clazz,
  nativeClazz,
  exception,
  function,
  nativeFunction,
  nativeAsyncFunction,
  list,
  map,
  module,
  object,
  nativeObject,
  number,
  string,
  unawaited,
  nullValue,
}

final Map<BeizeValueKind, String> _kindCodeMap = <BeizeValueKind, String>{
  BeizeValueKind.boolean: 'Boolean',
  BeizeValueKind.clazz: 'Class',
  BeizeValueKind.nativeClazz: 'NativeClass',
  BeizeValueKind.exception: 'Exception',
  BeizeValueKind.function: 'Function',
  BeizeValueKind.nativeFunction: 'NativeFunction',
  BeizeValueKind.nativeAsyncFunction: 'NativeAsyncFunction',
  BeizeValueKind.list: 'List',
  BeizeValueKind.map: 'Map',
  BeizeValueKind.module: 'Module',
  BeizeValueKind.number: 'Number',
  BeizeValueKind.object: 'Object',
  BeizeValueKind.nativeObject: 'NativeObject',
  BeizeValueKind.string: 'String',
  BeizeValueKind.unawaited: 'Unawaited',
  BeizeValueKind.nullValue: 'Null',
};

extension BeizeValueKindUtils on BeizeValueKind {
  String get code => _kindCodeMap[this]!;
}
