import '../namespace.dart';
import 'exports.dart';

class BeizeNatives {
  final BeizeGlobalsNatives globals = BeizeGlobalsNatives();

  void bind(final BeizeNamespace namespace) {
    BeizeConvertNatives.bind(namespace);
    BeizeFiberNatives.bind(namespace);
    BeizeMathNatives.bind(namespace);
    globals.bind(namespace);
  }
}
