import '../namespace.dart';
import 'exports.dart';

abstract class BeizeNatives {
  static void bind(final BeizeNamespace namespace) {
    BeizeConvertNatives.bind(namespace);
    BeizeDateTimeNatives.bind(namespace);
    BeizeFiberNatives.bind(namespace);
    BeizeMathNatives.bind(namespace);
    BeizeRegExpNatives.bind(namespace);
    BeizeGlobalsNatives.bind(namespace);
  }
}
