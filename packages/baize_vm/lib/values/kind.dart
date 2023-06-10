enum BaizeValueKind {
  boolean,
  function,
  nativeFunction,
  asyncNativeFunction,
  nullValue,
  number,
  string,
  object,
  list,
  module,
  primitiveObject,
}

final Map<BaizeValueKind, String> _kindCodeMap = <BaizeValueKind, String>{
  BaizeValueKind.boolean: 'Boolean',
  BaizeValueKind.function: 'Function',
  BaizeValueKind.nativeFunction: 'NativeFunction',
  BaizeValueKind.asyncNativeFunction: 'AsyncNativeFunction',
  BaizeValueKind.nullValue: 'Null',
  BaizeValueKind.number: 'Number',
  BaizeValueKind.string: 'String',
  BaizeValueKind.object: 'Object',
  BaizeValueKind.list: 'List',
  BaizeValueKind.module: 'Module',
  BaizeValueKind.primitiveObject: 'PrimitiveObject',
};

extension BaizeValueKindUtils on BaizeValueKind {
  String get code => _kindCodeMap[this]!;
}
