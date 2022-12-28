import '../../errors/exports.dart';
import 'exports.dart';

/// Must be a `double`, `String` or `FubukiFunctionConstant`
typedef FubukiConstant = dynamic;

typedef FubukiSerializedConstant = Map<dynamic, dynamic>;
typedef FubukiDeserializeFn = FubukiConstant Function(FubukiSerializedConstant);

mixin FubukiSerializableConstant {
  FubukiSerializedConstant serialize();

  static const String kKind = 'kind';

  static const Map<String, FubukiDeserializeFn> deserializers =
      <String, FubukiDeserializeFn>{
    FubukiFunctionConstant.kKindV: FubukiFunctionConstant.deserialize,
  };

  static FubukiConstant deserialize(final dynamic serialized) {
    if (serialized is double || serialized is String) {
      return serialized;
    }
    if (serialized is FubukiSerializedConstant &&
        serialized.containsKey(serialized[kKind])) {
      return deserializers[kKind]!(serialized);
    }
    throw FubukiUnknownConstantExpection.unknownSerializedConstant(serialized);
  }
}
