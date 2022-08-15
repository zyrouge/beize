import 'dart:io';
import '../../ast/exports.dart';

abstract class OutreConsoleLibrary {
  static const String name = 'outre:console';

  static OutreMirroredValue get module => OutreMirroredValue.fromOutreValue(
        OutreObjectValue(
          <OutreValuePropertyKey, OutreValue>{
            'print': OutreFunctionValue(
              (final OutreFunctionValueCall call) async {
                final String value =
                    await OutreValueUtils.stringify(call.argAt(0));
                stdout.write(value);
                return OutreNullValue();
              },
            ),
            'println': OutreFunctionValue(
              (final OutreFunctionValueCall call) async {
                final String value =
                    await OutreValueUtils.stringify(call.argAt(0));
                stdout.writeln(value);
                return OutreNullValue();
              },
            ),
          },
        ),
      );
}
