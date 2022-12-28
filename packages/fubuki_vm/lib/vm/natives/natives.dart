import '../namespace.dart';
import 'exports.dart';

abstract class FubukiNatives {
  static void bind(final FubukiNamespace namespace) {
    FubukiBooleanNatives.bind(namespace);
    FubukiConvertNatives.bind(namespace);
    FubukiDateTimeNatives.bind(namespace);
    FubukiExceptionNatives.bind(namespace);
    FubukiFunctionNatives.bind(namespace);
    FubukiFutureNatives.bind(namespace);
    FubukiListNatives.bind(namespace);
    FubukiNumberNatives.bind(namespace);
    FubukiObjectNatives.bind(namespace);
    FubukiRegExpNatives.bind(namespace);
    FubukiStringNatives.bind(namespace);
  }
}
