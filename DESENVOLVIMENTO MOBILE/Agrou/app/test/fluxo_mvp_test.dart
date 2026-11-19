import 'package:agrou/main.dart';
import 'package:agrou/models/meus_anuncios.dart';
import 'package:agrou/screens/anunciar_page.dart';
import 'package:agrou/screens/painel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> abrirFluxo(WidgetTester t, {double largura = 390}) async {
  MeusAnunciosStore.instancia.reiniciar();
  t.view.physicalSize = Size(largura * 2, 844 * 2);
  t.view.devicePixelRatio = 2;
  addTearDown(t.view.reset);
  await t.pumpWidget(const AgrouApp());
  await t.pumpAndSettle();
}

Future<void> rolarAteKey(WidgetTester t, Key key, {Key? listaKey}) async {
  final finder = find.byKey(key);
  final scroll = listaKey != null
      ? find.byKey(listaKey)
      : find.byType(Scrollable).first;
  for (var i = 0; i < 18; i++) {
    if (finder.evaluate().isNotEmpty && finder.hitTestable().evaluate().isNotEmpty) {
      return;
    }
    await t.drag(scroll, const Offset(0, -320));
    await t.pumpAndSettle();
  }
  await t.ensureVisible(finder);
  await t.pumpAndSettle();
}

void main() {
  group('Fluxo completo do MVP (ponta a ponta)', () {
    testWidgets(
        'T1 caminho principal: Inicio -> Anunciar -> Publicar -> Painel -> Detalhes -> Inicio',
        (t) async {
      await abrirFluxo(t);

      // Badge inicial = 3 ativos
      expect(find.text('3'), findsWidgets);

      // 1. Vai para Anunciar pelo botao central
      await t.tap(find.byKey(const Key('navAnunciar')));
      await t.pumpAndSettle();
      expect(find.text('Dados Técnicos & Fotos'), findsOneWidget);

      // 2. Altera Modelo e Valor
      await rolarAteKey(t, const Key('campoModelo'),
          listaKey: const Key('listaAnunciar'));
      await t.enterText(find.byKey(const Key('campoModelo')), '8400R');
      await rolarAteKey(t, const Key('campoValor'),
          listaKey: const Key('listaAnunciar'));
      await t.enterText(find.byKey(const Key('campoValor')), '510.000,00');

      // 3. Publica
      await rolarAteKey(t, const Key('btnPublicarAnuncio'),
          listaKey: const Key('listaAnunciar'));
      await t.tap(find.byKey(const Key('btnPublicarAnuncio')));
      await t.pumpAndSettle();

      // 4. Deve abrir o Painel com 4 ativos e o novo anuncio no topo
      expect(find.text('Meus Anúncios'), findsOneWidget);
      expect(
          (t.widget<Text>(find.byKey(const Key('kpiAtivos')))).data, '4');
      expect(
          (t.widget<Text>(find.byKey(const Key('cnt_ativo')))).data, '4');
      expect(find.text('Trator John Deere 8400R'), findsOneWidget);
      expect(find.text('R\$ 510.000'), findsOneWidget);

      // 5. Toca no card publicado para abrir Detalhes Do Lote
      await rolarAteKey(t, const Key('abrirDetalhesPainel_novo_1'),
          listaKey: const Key('listaPainel'));
      await t.tap(find.byKey(const Key('abrirDetalhesPainel_novo_1')));
      await t.pumpAndSettle();
      expect(find.text('Detalhes Do Lote'), findsOneWidget);
      expect(find.text('Trator John Deere 8400R'), findsOneWidget);
      expect(find.textContaining('510.000'), findsWidgets);

      // 6. Volta ao Painel e depois ao Inicio
      await t.tap(find.byKey(const Key('btnVoltar')));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const Key('painelNavInicio')));
      await t.pumpAndSettle();

      // 7. Anuncio recem publicado aparece tambem no Inicio
      await rolarAteKey(t, const Key('card_novo_1'));
      expect(find.text('Trator John Deere 8400R'), findsOneWidget);
    });

    testWidgets(
        'T2 caminho alternativo: voltar no meio do formulario sem publicar',
        (t) async {
      await abrirFluxo(t);

      await t.tap(find.byKey(const Key('navAnunciar')));
      await t.pumpAndSettle();

      await rolarAteKey(t, const Key('campoModelo'),
          listaKey: const Key('listaAnunciar'));
      await t.enterText(find.byKey(const Key('campoModelo')), '9999X');

      // Volta sem publicar
      await t.tap(find.byKey(const Key('btnVoltarAnunciar')));
      await t.pumpAndSettle();

      expect(find.text('Negocie direto no campo sem intermediários'),
          findsOneWidget);
      expect(MeusAnunciosStore.instancia.contar(StatusAnuncio.ativo), 3);
      expect(find.text('Trator John Deere 9999X'), findsNothing);
    });

    testWidgets(
        'T3 caminho alternativo: deixar campos obrigatorios vazios bloqueia publicacao',
        (t) async {
      await abrirFluxo(t);

      await t.tap(find.byKey(const Key('navAnunciar')));
      await t.pumpAndSettle();

      await rolarAteKey(t, const Key('campoModelo'),
          listaKey: const Key('listaAnunciar'));
      await t.enterText(find.byKey(const Key('campoModelo')), '');

      await rolarAteKey(t, const Key('campoValor'),
          listaKey: const Key('listaAnunciar'));
      await t.enterText(find.byKey(const Key('campoValor')), '');

      await rolarAteKey(t, const Key('btnPublicarAnuncio'),
          listaKey: const Key('listaAnunciar'));
      await t.tap(find.byKey(const Key('btnPublicarAnuncio')));
      await t.pumpAndSettle();

      // Permanece na tela Anunciar com mensagens de erro
      expect(find.byType(AnunciarPage), findsOneWidget);
      expect(find.text('Informe um valor válido maior que zero'),
          findsOneWidget);
      expect(MeusAnunciosStore.instancia.contar(StatusAnuncio.ativo), 3);
    });

    testWidgets(
        'T4 caminho alternativo: editar anuncio no Painel e mudar valor',
        (t) async {
      await abrirFluxo(t);

      await t.tap(find.byKey(const Key('navAnuncios')));
      await t.pumpAndSettle();
      expect(find.text('Meus Anúncios'), findsOneWidget);
      expect(find.text('R\$ 430.000'), findsOneWidget);

      await rolarAteKey(t, const Key('btnEditar_jd8335r'),
          listaKey: const Key('listaPainel'));
      await t.tap(find.byKey(const Key('btnEditar_jd8335r')));
      await t.pumpAndSettle();
      expect(find.text('Editar Anúncio'), findsOneWidget);

      await rolarAteKey(t, const Key('campoValor'),
          listaKey: const Key('listaAnunciar'));
      await t.enterText(find.byKey(const Key('campoValor')), '415.000,00');

      await rolarAteKey(t, const Key('btnPublicarAnuncio'),
          listaKey: const Key('listaAnunciar'));
      await t.tap(find.byKey(const Key('btnPublicarAnuncio')));
      await t.pumpAndSettle();

      expect(find.byType(PainelPage), findsOneWidget);
      expect(find.text('R\$ 415.000'), findsOneWidget);
      expect(
          (t.widget<Text>(find.byKey(const Key('kpiAtivos')))).data, '3');
    });

    testWidgets(
        'T5 gestao no Painel: pausar ativo, reativar pausado e excluir anuncio',
        (t) async {
      await abrirFluxo(t);

      await t.tap(find.byKey(const Key('navAnuncios')));
      await t.pumpAndSettle();

      expect((t.widget<Text>(find.byKey(const Key('cnt_ativo')))).data, '3');
      expect(
          (t.widget<Text>(find.byKey(const Key('cnt_pausado')))).data, '1');

      // Pausa Nelore
      await rolarAteKey(t, const Key('btnPausar_nelore60'),
          listaKey: const Key('listaPainel'));
      await t.tap(find.byKey(const Key('btnPausar_nelore60')));
      await t.pumpAndSettle();

      // Volta ao topo para checar abas
      await t.drag(find.byKey(const Key('listaPainel')), const Offset(0, 1500));
      await t.pumpAndSettle();
      expect((t.widget<Text>(find.byKey(const Key('cnt_ativo')))).data, '2');
      expect(
          (t.widget<Text>(find.byKey(const Key('cnt_pausado')))).data, '2');

      // Abre aba Pausados e reativa Grade Aradora
      await t.tap(find.byKey(const Key('abaPausados')));
      await t.pumpAndSettle();
      expect(find.text('Grade Aradora Baldan 28 Discos'), findsOneWidget);

      await rolarAteKey(t, const Key('btnReativar_baldan28'),
          listaKey: const Key('listaPainel'));
      await t.tap(find.byKey(const Key('btnReativar_baldan28')));
      await t.pumpAndSettle();

      await t.drag(find.byKey(const Key('listaPainel')), const Offset(0, 1500));
      await t.pumpAndSettle();
      expect((t.widget<Text>(find.byKey(const Key('cnt_ativo')))).data, '3');
      expect(
          (t.widget<Text>(find.byKey(const Key('cnt_pausado')))).data, '1');

      // Volta para Ativos e exclui Grade Aradora
      await t.tap(find.byKey(const Key('abaAtivos')));
      await t.pumpAndSettle();
      await rolarAteKey(t, const Key('btnExcluir_baldan28'),
          listaKey: const Key('listaPainel'));
      await t.tap(find.byKey(const Key('btnExcluir_baldan28')));
      await t.pumpAndSettle();

      expect(MeusAnunciosStore.instancia.contar(StatusAnuncio.ativo), 2);
      expect(find.text('Grade Aradora Baldan 28 Discos'), findsNothing);
    });

    testWidgets(
        'T6 caminho alternativo: toque duplo rapido em Publicar nao duplica anuncio',
        (t) async {
      await abrirFluxo(t);

      await t.tap(find.byKey(const Key('navAnunciar')));
      await t.pumpAndSettle();

      await rolarAteKey(t, const Key('campoModelo'),
          listaKey: const Key('listaAnunciar'));
      await t.enterText(find.byKey(const Key('campoModelo')), '7230J');

      await rolarAteKey(t, const Key('btnPublicarAnuncio'),
          listaKey: const Key('listaAnunciar'));
      await t.tap(find.byKey(const Key('btnPublicarAnuncio')));
      await t.tap(find.byKey(const Key('btnPublicarAnuncio')));
      await t.pumpAndSettle();

      expect(find.byType(PainelPage), findsOneWidget);
      expect(MeusAnunciosStore.instancia.contar(StatusAnuncio.ativo), 4);
      expect(find.text('Trator John Deere 7230J'), findsOneWidget);
    });

    testWidgets(
        'T7 salvar rascunho no galpao vai para Pausados + sem overflow em 320px',
        (t) async {
      await abrirFluxo(t, largura: 320);

      await t.tap(find.byKey(const Key('navAnunciar')));
      await t.pumpAndSettle();

      await rolarAteKey(t, const Key('campoModelo'),
          listaKey: const Key('listaAnunciar'));
      await t.enterText(find.byKey(const Key('campoModelo')), '6150J');

      await rolarAteKey(t, const Key('btnSalvarRascunho'),
          listaKey: const Key('listaAnunciar'));
      await t.tap(find.byKey(const Key('btnSalvarRascunho')));
      await t.pumpAndSettle();

      expect(find.byType(PainelPage), findsOneWidget);
      expect(
          (t.widget<Text>(find.byKey(const Key('cnt_pausado')))).data, '2');
      expect(find.text('Trator John Deere 6150J'), findsOneWidget);
      expect(t.takeException(), isNull);
    });
  });
}
