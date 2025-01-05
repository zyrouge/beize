import '../../values/exports.dart';
import '../namespace.dart';
import 'exports.dart';

class BeizeGlobalsNatives {
  final BeizeBytesListClassValue bytesListClass = BeizeBytesListClassValue();
  final BeizeRegExpClassValue regExpClass = BeizeRegExpClassValue();
  final BeizeRegExpMatchClassValue regExpMatchClass =
      BeizeRegExpMatchClassValue();
  final BeizeDateTimeClassValue dateTimeClass = BeizeDateTimeClassValue();

  void bind(final BeizeNamespace namespace) {
    namespace.declare('BytesList', bytesListClass);
    namespace.declare('RegExp', regExpClass);
    namespace.declare('RegExpMatch', regExpMatchClass);
    namespace.declare('DateTime', dateTimeClass);
    namespace.declare(
      'typeof',
      BeizeNativeFunctionValue.sync((final BeizeFunctionCall call) {
        final BeizeValue value = call.argumentAt(0);
        return BeizeStringValue(value.kName);
      }),
    );
  }
}
