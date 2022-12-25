import '../namespace.dart';
import 'exports.dart';

abstract class FubukiNatives {
  static void bind(final FubukiNamespace namespace) {
    FubukiBooleanNatives.bind(namespace);
    FubukiFunctionNatives.bind(namespace);
    FubukiListNatives.bind(namespace);
    FubukiNumberNatives.bind(namespace);
    FubukiObjectNatives.bind(namespace);
    FubukiStringNatives.bind(namespace);
  }
}
