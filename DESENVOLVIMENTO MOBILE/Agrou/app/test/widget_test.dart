import 'package:agrou/main.dart';
import 'package:agrou/models/anuncio.dart';
import 'package:agrou/screens/detalhes_lote_page.dart';
import 'package:agrou/screens/inicio_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> abrirApp(WidgetTester t,
    {Size tamanho = const Size(390, 844)}) async {
  t.view.physicalSize = Size(tamanho.width * 3, tamanho.height * 3);
  t.view.devicePixelRatio = 3;
  addTearDown(t.view.reset);
  await t.pumpWidget(const AgrouApp());
  await t.pumpAndSettle();
}

Future<void> abrirDetalhesIsolado(WidgetTester t,
    {Size tamanho = const Size(390, 844)}) async {
  t.view.physicalSize = Size(tamanho.width * 3, tamanho.height * 3);
  t.view.devicePixelRatio = 3;
  addTearDown(t.view.reset);
  await t.pumpWidget(const MaterialApp(home: DetalhesLotePage()));
  await t.pumpAndSettle();
}

Future<void> rolarParaTopo(WidgetTester t) async {
  final scrollable = find.byType(Scrollable).first;
  for (int i = 0; i < 15; i++) {
    await t.drag(scrollable, const Offset(0, 500));
    await t.pump();
  }
}

Future<void> rolarAte(WidgetTester t, Finder finder) async {
  final scrollable = find.byType(Scrollable).first;
  for (int i = 0; i < 30; i++) {
    if (finder.evaluate().isNotEmpty) {
      await Scrollable.ensureVisible(finder.evaluate().first, alignment: 0.5);
      await t.pump();
      return;
    }
    await t.drag(scrollable, const Offset(0, -300));
    await t.pump();
  }
  await rolarParaTopo(t);
  for (int i = 0; i < 30; i++) {
    if (finder.evaluate().isNotEmpty) {
      await Scrollable.ensureVisible(finder.evaluate().first, alignment: 0.5);
      await t.pump();
      return;
    }
    await t.drag(scrollable, const Offset(0, -300));
    await t.pump();
  }
}

void main() {
  group('Tela 1 - Agrou Inicio', () {
    testWidgets('E1-E10 elementos iniciais da tela Inicio batem com Figma',
        (t) async {
      await abrirApp(t);
      expect(find.text('Agrou'), findsWidgets);
      expect(find.text('Início'), findsWidgets);
      expect(find.text('MERCADO AGORA'), findsOneWidget);
      expect(find.text('Boi Gordo SP: '), findsOneWidget);
      expect(find.text('Negocie direto no campo sem intermediários'),
          findsOneWidget);
      expect(find.text('100% Produtores Verificados'), findsOneWidget);
      expect(find.text('Setores Principais'), findsOneWidget);
      expect(find.text('Tratores & Máquinas'), findsOneWidget);
      expect(find.text('Gado & Animais'), findsOneWidget);
      expect(find.text('Insumos & Sementes'), findsOneWidget);
      expect(find.text('Veículos & Carga'), findsOneWidget);
      await rolarAte(t, find.text('Modalidades de Negócio'));
      expect(find.text('Modalidades de Negócio'), findsOneWidget);
      await rolarAte(t, find.text('Oportunidades do Dia'));
      expect(find.text('Oportunidades do Dia'), findsOneWidget);
      await rolarAte(t, find.text('Lote 45 Novilhas Nelore PO Registradas'));
      expect(find.text('Lote 45 Novilhas Nelore PO Registradas'),
          findsOneWidget);
      await rolarAte(t, find.text('Trator John Deere 8335R (335 cv) Cabinado'));
      expect(find.text('Trator John Deere 8335R (335 cv) Cabinado'),
          findsOneWidget);
      await rolarAte(t, find.text('Colheitadeira New Holland CR 9060'));
      expect(find.text('Colheitadeira New Holland CR 9060'), findsOneWidget);
      await rolarAte(t, find.text('Pulverizador Jacto Uniport 3030 Plus'));
      expect(
          find.text('Pulverizador Jacto Uniport 3030 Plus'), findsOneWidget);
      await rolarAte(t, find.byKey(const Key('btnPublicarCta')));
      expect(find.text('Tem maquinário ou gado para negociar?'), findsOneWidget);
      await rolarAte(
          t,
          find.text(
              '© 2026 Agrou Tecnologia Agrícola Ltda. Todos os direitos reservados.'));
      expect(
          find.text(
              '© 2026 Agrou Tecnologia Agrícola Ltda. Todos os direitos reservados.'),
          findsOneWidget);
    });

    testWidgets('I1 notificacoes e avatar mostram avisos', (t) async {
      await abrirApp(t);
      await t.tap(find.byKey(const Key('btnNotificacoes')));
      await t.pump();
      expect(find.text('Nenhuma notificação nova'), findsOneWidget);
      await t.tap(find.byKey(const Key('btnAvatarUsuario')));
      await t.pump();
      expect(find.text('Usuário logado: Antônio Carlos Novaes'), findsOneWidget);
    });

    testWidgets('I2 busca textual filtra oportunidades e encontra lote',
        (t) async {
      await abrirApp(t);
      await t.enterText(find.byKey(const Key('campoBusca')), 'John Deere');
      await t.tap(find.byKey(const Key('btnBuscar')));
      await t.pump();
      await rolarAte(t, find.text('Trator John Deere 8335R (335 cv) Cabinado'));
      expect(find.text('Trator John Deere 8335R (335 cv) Cabinado'),
          findsOneWidget);
      expect(
          find.text('Lote 45 Novilhas Nelore PO Registradas'), findsNothing);
    });

    testWidgets('I3 seletor de regiao filtra por Goias', (t) async {
      await abrirApp(t);
      await t.tap(find.byKey(const Key('btnRegiao')));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const Key('regiao_Goiás')));
      await t.pumpAndSettle();
      expect(find.text('Goiás'), findsOneWidget);
      await rolarAte(t, find.text('Colheitadeira New Holland CR 9060'));
      expect(find.text('Colheitadeira New Holland CR 9060'), findsOneWidget);
      expect(
          find.text('Lote 45 Novilhas Nelore PO Registradas'), findsNothing);
    });

    testWidgets('I5 tocar em setor filtra e Ver todos restaura os 4 cards',
        (t) async {
      await abrirApp(t);
      await rolarAte(t, find.byKey(const Key('setor_Gado & Animais')));
      await t.tap(find.byKey(const Key('setor_Gado & Animais')));
      await t.pump();
      await rolarAte(t, find.text('Lote 45 Novilhas Nelore PO Registradas'));
      expect(find.text('Lote 45 Novilhas Nelore PO Registradas'),
          findsOneWidget);
      expect(find.text('Trator John Deere 8335R (335 cv) Cabinado'),
          findsNothing);
      await rolarAte(t, find.byKey(const Key('btnVerTodosSetores')));
      await t.tap(find.byKey(const Key('btnVerTodosSetores')));
      await t.pump();
      await rolarAte(t, find.text('Lote 45 Novilhas Nelore PO Registradas'));
      expect(find.text('Lote 45 Novilhas Nelore PO Registradas'),
          findsOneWidget);
      await rolarAte(t, find.byKey(const Key('btnNegociar_agr-8335')));
      expect(find.text('Trator John Deere 8335R (335 cv) Cabinado'),
          findsOneWidget);
    });

    testWidgets('I6 modalidades filtram Barter & Permuta e Leiloes Ativos',
        (t) async {
      await abrirApp(t);
      await rolarAte(t, find.byKey(const Key('mod_Leilões Ativos')));
      await t.tap(find.byKey(const Key('mod_Leilões Ativos')));
      await t.pump();
      await rolarAte(t, find.text('Nenhum leilão ativo no momento'));
      expect(find.text('Nenhum leilão ativo no momento'), findsOneWidget);
      await t.tap(find.byKey(const Key('btnVerTodosVazio')));
      await t.pump();
      await rolarAte(t, find.text('Lote 45 Novilhas Nelore PO Registradas'));
      expect(find.text('Lote 45 Novilhas Nelore PO Registradas'),
          findsOneWidget);
      await rolarAte(t, find.byKey(const Key('mod_Barter & Permuta')));
      await t.tap(find.byKey(const Key('mod_Barter & Permuta')));
      await t.pump();
      expect(
          find.text('Lote 45 Novilhas Nelore PO Registradas'), findsNothing);
      await rolarAte(t, find.text('Trator John Deere 8335R (335 cv) Cabinado'));
      expect(find.text('Trator John Deere 8335R (335 cv) Cabinado'),
          findsOneWidget);
    });

    testWidgets('I7/I8 botoes fora do fluxo avisam e barras ficam fixas',
        (t) async {
      await abrirApp(t);
      await t.tap(find.byKey(const Key('navExplorar')));
      await t.pump();
      expect(find.text('Tela Explorar fora do escopo atual'), findsOneWidget);
      await t.drag(find.byType(ListView).first, const Offset(0, -1500));
      await t.pump();
      expect(find.byKey(const Key('btnNotificacoes')).hitTestable(),
          findsOneWidget);
      expect(find.byKey(const Key('navInicio')).hitTestable(), findsOneWidget);
    });
  });

  group('Navegacao Ida e Volta', () {
    testWidgets('N1-N4 tocar em Negociar abre Detalhes Do Lote com os dados',
        (t) async {
      await abrirApp(t);
      // Card 1: Nelore
      await rolarAte(t, find.byKey(const Key('btnNegociar_agr-4501')));
      await t.tap(find.byKey(const Key('btnNegociar_agr-4501')));
      await t.pumpAndSettle();
      expect(find.text('Detalhes Do Lote'), findsOneWidget);
      expect(find.text('Lote 45 Novilhas Nelore PO Registradas'),
          findsOneWidget);
      expect(find.text('1/3'), findsOneWidget);
      await t.tap(find.byKey(const Key('btnVoltar')));
      await t.pumpAndSettle();

      // Card 2: Trator John Deere
      await rolarAte(t, find.byKey(const Key('btnNegociar_agr-8335')));
      await t.tap(find.byKey(const Key('btnNegociar_agr-8335')));
      await t.pumpAndSettle();
      expect(find.text('Trator John Deere 8335R'), findsOneWidget);
      expect(find.text('1/6'), findsOneWidget);
      await t.tap(find.byKey(const Key('btnVoltar')));
      await t.pumpAndSettle();

      // Card 3: Colheitadeira
      await rolarAte(t, find.byKey(const Key('btnNegociar_agr-9060')));
      await t.tap(find.byKey(const Key('btnNegociar_agr-9060')));
      await t.pumpAndSettle();
      expect(find.text('Colheitadeira New Holland CR 9060'), findsOneWidget);
      await t.tap(find.byKey(const Key('btnVoltar')));
      await t.pumpAndSettle();

      // Card 4: Pulverizador
      await rolarAte(t, find.byKey(const Key('btnNegociar_agr-3030')));
      await t.tap(find.byKey(const Key('btnNegociar_agr-3030')));
      await t.pumpAndSettle();
      expect(find.text('Pulverizador Jacto Uniport 3030 Plus'), findsOneWidget);
    });

    testWidgets(
        'Volta preserva filtros na Inicio e atualiza favorito marcado em Detalhes',
        (t) async {
      await abrirApp(t);
      await t.enterText(find.byKey(const Key('campoBusca')), 'John Deere');
      await t.tap(find.byKey(const Key('btnBuscar')));
      await t.pump();

      await rolarAte(t, find.byKey(const Key('btnNegociar_agr-8335')));
      await t.tap(find.byKey(const Key('btnNegociar_agr-8335')));
      await t.pumpAndSettle();

      await t.tap(find.byKey(const Key('btnFavoritar')));
      await t.pump();
      expect(find.text('Adicionado aos favoritos'), findsOneWidget);

      await t.tap(find.byKey(const Key('btnVoltar')));
      await t.pumpAndSettle();

      await rolarAte(t, find.text('Trator John Deere 8335R (335 cv) Cabinado'));
      expect(find.text('Trator John Deere 8335R (335 cv) Cabinado'),
          findsOneWidget);
      expect(
          find.text('Lote 45 Novilhas Nelore PO Registradas'), findsNothing);
      expect(find.byKey(const Key('badgeFavorito_agr-8335')), findsOneWidget);
    });
  });

  group('Tela 2 - Detalhes Do Lote (C1-C11)', () {
    testWidgets('C1 voltar sem tela anterior mostra aviso', (t) async {
      await abrirDetalhesIsolado(t);
      await t.tap(find.byKey(const Key('btnVoltar')));
      await t.pump();
      expect(find.text('Voltando para o Início'), findsOneWidget);
    });

    testWidgets('C2-C6 favoritar, compartilhar, setas e miniaturas', (t) async {
      await abrirDetalhesIsolado(t);
      await t.tap(find.byKey(const Key('btnFavoritar')));
      await t.pump();
      expect(find.text('Adicionado aos favoritos'), findsOneWidget);
      await t.tap(find.byKey(const Key('btnFavoritar')));
      await t.pump();
      expect(find.text('Removido dos favoritos'), findsOneWidget);

      await t.tap(find.byKey(const Key('btnCompartilhar')));
      await t.pump();
      expect(find.text('Link do anúncio copiado'), findsOneWidget);

      expect(find.text('1/6'), findsOneWidget);
      await t.tap(find.byKey(const Key('btnProxima')));
      await t.pump();
      expect(find.text('2/6'), findsOneWidget);
      await t.tap(find.byKey(const Key('btnAnterior')));
      await t.tap(find.byKey(const Key('btnAnterior')));
      await t.pump();
      expect(find.text('6/6'), findsOneWidget);

      await t.tap(find.byKey(const Key('miniatura3')));
      await t.pump();
      expect(find.text('4/6'), findsOneWidget);
    });

    testWidgets('C7 calcular CEP valido mostra frete', (t) async {
      await abrirDetalhesIsolado(t);
      await rolarAte(t, find.byKey(const Key('btnCalcularCep')));
      await t.tap(find.byKey(const Key('btnCalcularCep')));
      await t.pumpAndSettle();
      await t.enterText(find.byKey(const Key('campoCep')), '13560000');
      await t.tap(find.text('Calcular'));
      await t.pump();
      expect(find.text('Frete estimado: R\$ 4.800'), findsOneWidget);
    });

    testWidgets('C9-C11 telefone, proposta e rodape fixo', (t) async {
      await abrirDetalhesIsolado(t);
      await t.tap(find.byKey(const Key('btnTelefone')));
      await t.pump();
      expect(find.text('Ligando para Antônio Novaes…'), findsOneWidget);
      await t.tap(find.byKey(const Key('btnProposta')));
      await t.pump();
      expect(find.text('Proposta formal em breve'), findsOneWidget);

      await t.drag(find.byType(ListView).first, const Offset(0, -2000));
      await t.pump();
      expect(find.byKey(const Key('btnWhatsApp')).hitTestable(), findsOneWidget);
      expect(find.byKey(const Key('btnVoltar')).hitTestable(), findsOneWidget);
    });
  });

  group('Tentativa de quebrar o fluxo', () {
    testWidgets('B1 busca com apenas espacos nao deve zerar oportunidades',
        (t) async {
      await abrirApp(t);
      await t.enterText(find.byKey(const Key('campoBusca')), '   ');
      await t.tap(find.byKey(const Key('btnBuscar')));
      await t.pump();
      await rolarAte(t, find.text('Lote 45 Novilhas Nelore PO Registradas'));
      expect(find.text('Lote 45 Novilhas Nelore PO Registradas'),
          findsOneWidget);
      expect(find.text('Nenhum anúncio encontrado'), findsNothing);
    });

    testWidgets('B2 CEP vazio ou so com espacos nao deve mostrar frete',
        (t) async {
      await abrirDetalhesIsolado(t);
      await rolarAte(t, find.byKey(const Key('btnCalcularCep')));
      await t.tap(find.byKey(const Key('btnCalcularCep')));
      await t.pumpAndSettle();
      await t.enterText(find.byKey(const Key('campoCep')), '   ');
      await t.tap(find.text('Calcular'));
      await t.pump();
      expect(find.text('Frete estimado: R\$ 4.800'), findsNothing);
    });

    testWidgets('B3 toque duplo rapido em Negociar abre apenas 1 Detalhes',
        (t) async {
      await abrirApp(t);
      await rolarAte(t, find.byKey(const Key('btnNegociar_agr-4501')));
      final btn = find.byKey(const Key('btnNegociar_agr-4501'));
      await t.tap(btn);
      await t.pump(const Duration(milliseconds: 20));
      await t.tap(btn, warnIfMissed: false);
      await t.pumpAndSettle();

      expect(find.text('Detalhes Do Lote'), findsOneWidget);
      await t.tap(find.byKey(const Key('btnVoltar')));
      await t.pumpAndSettle();
      expect(find.byKey(const Key('navInicio')), findsOneWidget);
      expect(find.text('Detalhes Do Lote'), findsNothing);
      await rolarParaTopo(t);
      expect(find.byKey(const Key('campoBusca')), findsOneWidget);
    });

    testWidgets('B4 voltar varias vezes nao fecha Inicio nem causa erro',
        (t) async {
      await abrirApp(t);
      await rolarAte(t, find.byKey(const Key('btnNegociar_agr-4501')));
      await t.tap(find.byKey(const Key('btnNegociar_agr-4501')));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const Key('btnVoltar')));
      await t.pump(const Duration(milliseconds: 20));
      await t.tap(find.byKey(const Key('btnVoltar')), warnIfMissed: false);
      await t.pumpAndSettle();
      expect(find.byKey(const Key('navInicio')), findsOneWidget);
      expect(find.text('Detalhes Do Lote'), findsNothing);
      await rolarParaTopo(t);
      expect(find.byKey(const Key('campoBusca')), findsOneWidget);
    });

    testWidgets('B5 texto longo em busca e em card nao causa overflow',
        (t) async {
      final anuncioLongo = Anuncio(
        id: 'agr-long',
        codigo: '#AGR-9999999999',
        setor: 'Tratores & Máquinas',
        categoriaCard: 'CATEGORIA MUITO LONGA PARA TESTE DE QUEBRA DE LINHA',
        tituloCard:
            'Trator Super Especial Agrícola Ultra Longa Descrição Sem Cortes 2026 Completo Cabinado',
        tituloDetalhe:
            'Trator Super Especial Agrícola Ultra Longa Descrição Sem Cortes 2026 Completo Cabinado',
        cidadeUf: 'São José do Rio Preto do Sul, MG',
        regiaoFiltro: 'Minas Gerais',
        localDetalhe:
            'São José do Rio Preto do Sul, MG • Fazenda Muito Distante com Nome Muito Extenso para Vistoria',
        precoLabel: 'Valor Negociável Especialíssimo',
        preco: '1.990.000',
        imagemCard: 'assets/opp_trator.jpg',
        badgeFotoTopo: 'Produtor Super Verificado Certificado Ouro',
        badgeFotoBase: 'Ano 2026 • 500 cv Bi-Turbo',
        spec1Rotulo: 'Horímetro Muito Longo:',
        spec1Valor: '12.500 horas originais certificadas',
        spec2Rotulo: 'Transmissão Muito Longa:',
        spec2Valor: 'Continuamente Variável Dupla Embreagem',
        modalidades: const ['Compra Direta'],
        fotosDetalhe: const ['assets/opp_trator.jpg'],
        etiquetas: const [
          'Tratores & Máquinas Pesadas',
          'Usado Revisado Completo',
          'Produtor Verificado (CPF/CNPJ)'
        ],
        permutaSub: 'Gado Nelore ou Soja Futura',
        vendedorNome: 'Antônio Carlos dos Santos Novaes Filho Sobrinho',
        vendedorFazenda: 'Fazenda Santa Fé do Horizonte • Região Norte/MG',
        vendedorDesde: 'Produtor cadastrado desde 2015',
        vendedorNota: '4.9',
        vendedorVendas: '(120 vendas\nconcluídas)',
        ficha: anuncioPadrao.ficha,
        historicoTitulo: anuncioPadrao.historicoTitulo,
        historicoDescricao: anuncioPadrao.historicoDescricao,
        historicoObs: anuncioPadrao.historicoObs,
        freteEstimado: 'R\$ 4.800',
        freteSubtitulo: 'Cotação p/ Prancha Pesada Especial',
      );
      t.view.physicalSize = const Size(390 * 3, 844 * 3);
      t.view.devicePixelRatio = 3;
      addTearDown(t.view.reset);
      await t.pumpWidget(
          MaterialApp(home: InicioPage(anuncios: [anuncioLongo])));
      await t.pumpAndSettle();
      await t.enterText(find.byKey(const Key('campoBusca')), 'A' * 80);
      await t.tap(find.byKey(const Key('btnBuscar')));
      await t.pump();
      await rolarAte(t, find.text('Nenhum anúncio encontrado'));
      expect(find.text('Nenhum anúncio encontrado'), findsOneWidget);
      await t.tap(find.byKey(const Key('btnVerTodosVazio')));
      await t.pump();
      await rolarAte(t, find.byKey(const Key('btnNegociar_agr-long')));
      await t.tap(find.byKey(const Key('btnNegociar_agr-long')));
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    });

    testWidgets('B6 janela estreita 320px em Inicio e Detalhes sem overflow',
        (t) async {
      await abrirApp(t, tamanho: const Size(320, 700));
      await t.drag(find.byType(ListView).first, const Offset(0, -1500));
      await t.pump();
      await t.drag(find.byType(ListView).first, const Offset(0, -1500));
      await t.pump();
      await rolarAte(t, find.byKey(const Key('btnNegociar_agr-8335')));
      await t.tap(find.byKey(const Key('btnNegociar_agr-8335')));
      await t.pumpAndSettle();
      await t.drag(find.byType(ListView).first, const Offset(0, -1500));
      await t.pump();
      expect(t.takeException(), isNull);
    });
  });
}
