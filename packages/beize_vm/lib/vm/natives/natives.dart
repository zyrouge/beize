import '../namespace.dart';
import 'exports.dart';

abstract class BeizeNatives {
  static void bind(final BeizeNamespace namespace) {
    BeizeBooleanNatives.bind(namespace);
    BeizeConvertNatives.bind(namespace);
    BeizeDateTimeNatives.bind(namespace);
    BeizeExceptionNatives.bind(namespace);
    BeizeFiberNatives.bind(namespace);
    BeizeFunctionNatives.bind(namespace);
    BeizeListNatives.bind(namespace);
    BeizeNumberNatives.bind(namespace);
    BeizeObjectNatives.bind(namespace);
    BeizeRegExpNatives.bind(namespace);
    BeizeStringNatives.bind(namespace);
    BeizeGlobalsNatives.bind(namespace);
  }
}
