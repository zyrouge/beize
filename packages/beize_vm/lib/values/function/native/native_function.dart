import '../../../vm/exports.dart';
import '../../exports.dart';

abstract class BeizeNativeFunctionValue extends BeizeNativeObjectValue
    implements BeizeCallableValue {
  factory BeizeNativeFunctionValue(
    final BeizeNativeExecuteFunction function,
  ) =>
      BeizeNativeExecuteFunctionValue(function);

  factory BeizeNativeFunctionValue.sync(
    final BeizeNativeSyncFunction function,
  ) =>
      BeizeNativeSyncFunctionValue(function);

  factory BeizeNativeFunctionValue.async(
    final BeizeNativeAsyncFunction function,
  ) =>
      BeizeNativeAsyncFunctionValue(function);

  BeizeNativeFunctionValue.internal();

  @override
  final BeizeValueKind kind = BeizeValueKind.nativeFunction;

  @override
  String kToString() => '<native function>';

  @override
  BeizeClassValue get kClass => throw UnimplementedError();

  @override
  BeizeClassValue kClassInternal(final BeizeVM vm) => vm.globals.functionClass;
}
