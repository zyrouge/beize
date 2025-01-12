import 'package:beize_compiler/beize_compiler.dart';
import 'package:beize_vm/beize_vm.dart';
import 'package:flutter/material.dart';

enum PlaygroundStatus {
  none,
  compiling,
  executing,
  success,
  failed;

  String title() => name[0].toUpperCase() + name.substring(1).toLowerCase();
}

class Playground extends StatefulWidget {
  const Playground({super.key});

  @override
  State<Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  late final TextEditingController codeController;
  bool isExecuting = false;
  PlaygroundStatus status = PlaygroundStatus.none;
  String output = '';

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    codeController.text = 'print("Hello World!");';
  }

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
  }

  Future<void> executeCode() async {
    if (isExecuting) {
      return;
    }
    try {
      setState(() {
        status = PlaygroundStatus.compiling;
        output = '';
      });
      final BeizeProgramConstant program = await BeizeCompiler.compileScript(
        script: codeController.text,
        options: BeizeCompilerOptions(),
      );
      setState(() {
        status = PlaygroundStatus.executing;
      });
      final BeizeVM vm = BeizeVM(
        program,
        BeizeVMOptions(
          printPrefix: '',
          onPrint: (final String text) {
            setState(() {
              output += text;
            });
          },
        ),
      );
      await vm.run();
      setState(() {
        status = PlaygroundStatus.success;
      });
    } catch (e) {
      setState(() {
        status = PlaygroundStatus.failed;
        output = e.toString();
      });
    } finally {
      isExecuting = false;
    }
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Beize Playground'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          spacing: 8,
          children: <Widget>[
            const Align(alignment: Alignment.centerLeft, child: Text('Code')),
            Expanded(
              child: TextField(
                controller: codeController,
                keyboardType: TextInputType.multiline,
                expands: true,
                maxLines: null,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.colorScheme.surfaceContainer,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.colorScheme.primaryContainer,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  hoverColor: theme.colorScheme.surfaceContainer,
                ),
              ),
            ),
            const Divider(),
            Row(children: <Widget>[Text('Output (${status.title()})')]),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.primaryContainer),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: SelectableText(output),
                  ),
                ),
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: executeCode,
        tooltip: 'Run',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
