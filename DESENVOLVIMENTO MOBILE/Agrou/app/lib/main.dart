import 'package:flutter/material.dart';

import 'screens/inicio_page.dart';
import 'theme/agrou_colors.dart';

void main() => runApp(const AgrouApp());

class AgrouApp extends StatelessWidget {
  const AgrouApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agrou – Início',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: AgrouColors.verde,
        scaffoldBackgroundColor: AgrouColors.fundo,
        fontFamily: 'Roboto',
      ),
      home: const InicioPage(),
    );
  }
}
