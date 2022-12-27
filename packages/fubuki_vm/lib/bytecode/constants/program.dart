import 'function.dart';

class FubukiProgramConstant {
  FubukiProgramConstant({
    required this.modules,
    required this.entrypoint,
  });

  final Map<String, FubukiFunctionConstant> modules;
  final String entrypoint;
}
