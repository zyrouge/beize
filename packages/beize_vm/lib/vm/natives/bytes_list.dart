import '../../values/exports.dart';
import '../exports.dart';

class BeizeBytesListValue extends BeizePrimitiveObjectValue {
  BeizeBytesListValue(this.bytes);

  final List<int> bytes;

  @override
  final String kName = 'BytesList';

  @override
  BeizeBytesListClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.natives.globals.bytesListClass;

  @override
  BeizeBytesListValue kClone() => BeizeBytesListValue(bytes);

  @override
  String kToString() => '<bytes list>';

  @override
  bool get isTruthy => bytes.isEmpty;

  @override
  int get kHashCode => bytes.hashCode;
}
