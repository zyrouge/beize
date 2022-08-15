import 'package:path/path.dart' as p;
import '../ast/exports.dart';
import '../errors/runtime_exception.dart';
import '../node/exports.dart';
import '../parser/exports.dart';
import 'context.dart';
import 'environment.dart';
import 'expression.dart';
import 'statement.dart';

abstract class OutreEvaluator {
  static Future<OutreMirroredValue> evaluateFile(
    final String path, {
    final OutreEvaluatorContext? context,
    final OutreEnvironment? environment,
    final String frameName = '<script>',
  }) async {
    final OutreEvaluatorContext nContext =
        context ?? OutreEvaluatorContext(rootDir: p.dirname(path));
    final OutreEnvironment nEnvironment = environment ??
        OutreEnvironment(
          null,
          frameName: frameName,
          file: path,
          withGlobalValues: true,
        );

    final OutreModule module = await OutreParser.parseFile(path);
    if (module.hasErrors) {
      throw Exception('Module had errors');
    }

    return evaluateModule(nContext, nEnvironment, module);
  }

  static Future<OutreValue> evaluateNode(
    final OutreEvaluatorContext context,
    final OutreEnvironment environment,
    final OutreNode node,
  ) async {
    context.pushStackFrame(
      environment.createStackFrameFromOutreNode(node),
    );
    final OutreValue result;
    try {
      if (node is OutreModule) {
        result = await evaluateModule(context, environment, node);
      } else if (node is OutreExpression) {
        result = await OutreExpressionEvaluator.evaluateExpression(
          context,
          environment,
          node,
        );
      } else if (node is OutreStatement) {
        result = await OutreStatementEvaluator.evaluateStatement(
          context,
          environment,
          node,
        );
      } else {
        throw Exception('Unexpected node');
      }
    } catch (err, stackTrace) {
      if (err is OutreRuntimeException) {
        rethrow;
      }

      throw OutreRuntimeException(
        err.toString(),
        context.stackTrace,
        stackTrace,
      );
    }
    context.popStackFrame();
    return result;
  }

  static Future<OutreMirroredValue> evaluateModule(
    final OutreEvaluatorContext context,
    final OutreEnvironment environment,
    final OutreModule program,
  ) async {
    final OutreMirroredValue value = OutreMirroredValue(
      get: (final OutreValuePropertyKey key) {
        if (key is! String) return null;
        return environment.get(key);
      },
      set: (final OutreValuePropertyKey key, final OutreValue value) {
        if (key is! String) return;
        return environment.assign(key, value);
      },
    );
    await OutreStatementEvaluator.evaluateStatements(
      context,
      environment,
      program.statements,
    );
    return value;
  }
}
