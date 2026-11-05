import 'package:agrou/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> abrir(WidgetTester t) async {
  t.view.physicalSize = const Size(390 * 3, 844 * 3);
  t.view.devicePixelRatio = 3;
  addTearDown(t.view.reset);
  await t.pumpWidget(const AgrouApp());
  await t.pump();
}

void main() {
  testWidgets('C1 voltar sem tela anterior mostra aviso', (t) async {
    await abrir(t);
    await t.tap(find.byKey(const Key('btnVoltar')));
    await t.pump();
    expect(find.text('Voltando para o Início'), findsOneWidget);
  });

  testWidgets('C2 favoritar alterna e avisa', (t) async {
    await abrir(t);
    await t.tap(find.byKey(const Key('btnFavoritar')));
    await t.pump();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('Adicionado aos favoritos'), findsOneWidget);
    await t.tap(find.byKey(const Key('btnFavoritar')));
    await t.pump();
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.text('Removido dos favoritos'), findsOneWidget);
  });

  testWidgets('C3 compartilhar avisa', (t) async {
    await abrir(t);
    await t.tap(find.byKey(const Key('btnCompartilhar')));
    await t.pump();
    expect(find.text('Link do anúncio copiado'), findsOneWidget);
  });

  testWidgets('C4/C5 setas mudam contador e fazem a volta', (t) async {
    await abrir(t);
    expect(find.text('1/6'), findsOneWidget);
    await t.tap(find.byKey(const Key('btnProxima')));
    await t.pump();
    expect(find.text('2/6'), findsOneWidget);
    await t.tap(find.byKey(const Key('btnAnterior')));
    await t.tap(find.byKey(const Key('btnAnterior')));
    await t.pump();
    expect(find.text('6/6'), findsOneWidget);
  });

  testWidgets('C6 miniatura troca foto', (t) async {
    await abrir(t);
    await t.tap(find.byKey(const Key('miniatura3')));
    await t.pump();
    expect(find.text('4/6'), findsOneWidget);
  });

  testWidgets('C7 calcular CEP mostra frete', (t) async {
    await abrir(t);
    await t.scrollUntilVisible(find.byKey(const Key('btnCalcularCep')), 300,
        scrollable: find.byType(Scrollable).first);
    await t.tap(find.byKey(const Key('btnCalcularCep')));
    await t.pumpAndSettle();
    await t.enterText(find.byKey(const Key('campoCep')), '13560000');
    await t.tap(find.text('Calcular'));
    await t.pump();
    expect(find.text('Frete estimado: R\$ 4.800'), findsOneWidget);
  });

  testWidgets('C9/C10 telefone e proposta avisam', (t) async {
    await abrir(t);
    await t.tap(find.byKey(const Key('btnTelefone')));
    await t.pump();
    expect(find.text('Ligando para Antônio Novaes…'), findsOneWidget);
    await t.tap(find.byKey(const Key('btnProposta')));
    await t.pump();
    expect(find.text('Proposta formal em breve'), findsOneWidget);
  });

  testWidgets('C11 rodapé continua visível após rolar', (t) async {
    await abrir(t);
    await t.drag(find.byType(ListView).first, const Offset(0, -2000));
    await t.pump();
    expect(find.byKey(const Key('btnWhatsApp')).hitTestable(), findsOneWidget);
    expect(find.byKey(const Key('btnVoltar')).hitTestable(), findsOneWidget);
  });
}

