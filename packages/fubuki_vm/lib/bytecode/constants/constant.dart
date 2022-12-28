import '../../errors/exports.dart';
import 'exports.dart';

/// Must be a `double`, `String` or `FubukiFunctionConstant`
typedef FubukiConstant = dynamic;

enum FubukiSerializableConstants {
  function,
}

typedef FubukiSerializedConstant = List<dynamic>;
typedef FubukiDeserializeFn = FubukiConstant Function(FubukiSerializedConstant);

mixin FubukiSerializableConstant {
  FubukiSerializedConstant serialize();

  static final Map<int, FubukiDeserializeFn> deserializers =
      <int, FubukiDeserializeFn>{
    FubukiSerializableConstants.function.index:
        FubukiFunctionConstant.deserialize,
  };

  static FubukiConstant deserialize(final dynamic serialized) {
    if (serialized is double || serialized is String) {
      return serialized;
    }
    if (serialized is FubukiSerializedConstant) {
      return deserializers[serialized[0]]!(serialized);
    }
    throw FubukiUnknownConstantExpection.unknownSerializedConstant(serialized);
  }
}
