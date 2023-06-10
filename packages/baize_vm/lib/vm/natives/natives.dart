import '../namespace.dart';
import 'exports.dart';

abstract class BaizeNatives {
  static void bind(final BaizeNamespace namespace) {
    BaizeBooleanNatives.bind(namespace);
    BaizeConvertNatives.bind(namespace);
    BaizeDateTimeNatives.bind(namespace);
    BaizeExceptionNatives.bind(namespace);
    BaizeFiberNatives.bind(namespace);
    BaizeFunctionNatives.bind(namespace);
    BaizeListNatives.bind(namespace);
    BaizeNumberNatives.bind(namespace);
    BaizeObjectNatives.bind(namespace);
    BaizeRegExpNatives.bind(namespace);
    BaizeStringNatives.bind(namespace);
    BaizeGlobalsNatives.bind(namespace);
  }
}
