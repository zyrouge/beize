enum FubukiValueKind {
  boolean,
  function,
  nativeFunction,
  asyncNativeFunction,
  nullValue,
  number,
  string,
  object,
  list,
  future,
  module,
  primitiveObject,
}

final Map<FubukiValueKind, String> _kindCodeMap = <FubukiValueKind, String>{
  FubukiValueKind.boolean: 'Boolean',
  FubukiValueKind.function: 'Function',
  FubukiValueKind.nativeFunction: 'NativeFunction',
  FubukiValueKind.asyncNativeFunction: 'AsyncNativeFunction',
  FubukiValueKind.nullValue: 'Null',
  FubukiValueKind.number: 'Number',
  FubukiValueKind.string: 'String',
  FubukiValueKind.object: 'Object',
  FubukiValueKind.list: 'List',
  FubukiValueKind.future: 'Future',
  FubukiValueKind.module: 'Module',
  FubukiValueKind.primitiveObject: 'PrimitiveObject',
};

extension FubukiValueKindUtils on FubukiValueKind {
  String get code => _kindCodeMap[this]!;
}
