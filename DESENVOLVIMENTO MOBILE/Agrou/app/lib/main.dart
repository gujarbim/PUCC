import 'package:flutter/material.dart';

import 'screens/anunciar_page.dart';
import 'screens/inicio_page.dart';
import 'screens/painel_page.dart';
import 'theme/agrou_colors.dart';

void main() {
  final tela = Uri.base.queryParameters['tela'];
  runApp(AgrouApp(telaInicial: tela));
}

class AgrouApp extends StatelessWidget {
  final String? telaInicial;

  const AgrouApp({super.key, this.telaInicial});

  @override
  Widget build(BuildContext context) {
    final Widget home = switch (telaInicial) {
      'anunciar' => const AnunciarPage(),
      'painel' => const PainelPage(),
      _ => const InicioPage(),
    };

    return MaterialApp(
      title: 'Agrou – MVP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: AgrouColors.verde,
        scaffoldBackgroundColor: AgrouColors.fundo,
        fontFamily: 'Roboto',
      ),
      home: home,
    );
  }
}
