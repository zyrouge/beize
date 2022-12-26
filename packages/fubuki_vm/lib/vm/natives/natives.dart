import '../namespace.dart';
import 'exports.dart';

abstract class FubukiNatives {
  static void bind(final FubukiNamespace namespace) {
    FubukiBooleanNatives.bind(namespace);
    FubukiExceptionNatives.bind(namespace);
    FubukiFunctionNatives.bind(namespace);
    FubukiFutureNatives.bind(namespace);
    FubukiListNatives.bind(namespace);
    FubukiNumberNatives.bind(namespace);
    FubukiObjectNatives.bind(namespace);
    FubukiStringNatives.bind(namespace);
  }
}
