import 'package:flutter/material.dart';

import 'playground.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
    title: 'Beize Playground',
    theme: ThemeData(
      fontFamily: 'UbuntuMono',
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.dark,
        dynamicSchemeVariant: DynamicSchemeVariant.neutral,
      ),
      useMaterial3: true,
    ),
    home: const Playground(),
  );
}
