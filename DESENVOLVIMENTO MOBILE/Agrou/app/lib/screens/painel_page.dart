import 'package:flutter/material.dart';

import '../models/anuncio.dart';
import '../models/meus_anuncios.dart';
import '../theme/agrou_colors.dart';
import 'anunciar_page.dart';
import 'detalhes_lote_page.dart';

class PainelPage extends StatefulWidget {
  final StatusAnuncio abaInicial;

  const PainelPage({
    super.key,
    this.abaInicial = StatusAnuncio.ativo,
  });

  @override
  State<PainelPage> createState() => _PainelPageState();
}

class _PainelPageState extends State<PainelPage> {
  final _store = MeusAnunciosStore.instancia;
  late StatusAnuncio _aba;
  bool _navegando = false;

  @override
  void initState() {
    super.initState();
    _aba = widget.abaInicial;
    _store.addListener(_atualizar);
  }

  @override
  void dispose() {
    _store.removeListener(_atualizar);
    super.dispose();
  }

  void _atualizar() {
    if (mounted) setState(() {});
  }

  void _aviso(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ));
  }

  Anuncio _converterParaDetalhes(MeuAnuncio a) {
    return Anuncio(
      id: a.id,
      codigo: '#AGR-${a.id.toUpperCase()}',
      setor: a.categoria == 'Máquinas'
          ? 'Tratores & Máquinas'
          : 'Gado & Animais',
      categoriaCard: a.etiquetaCategoria.toUpperCase(),
      tituloCard: a.titulo,
      tituloDetalhe: a.titulo,
      cidadeUf: a.local,
      regiaoFiltro: 'Mato Grosso & SP',
      localDetalhe: '${a.local} • Disponível para vistoria física na fazenda',
      precoLabel: a.precoLabel,
      preco: a.precoFormatado,
      imagemCard: a.imagem,
      badgeFotoTopo: a.etiquetaCategoria,
      badgeFotoBase: a.rodapeFoto,
      spec1Rotulo: 'Ano / Modelo:',
      spec1Valor: a.ano,
      spec2Rotulo: 'Horímetro:',
      spec2Valor: '${a.horimetro}h',
      modalidades: const ['Compra Direta', 'Barter & Permuta'],
      fotosDetalhe: [
        a.imagem,
        'assets/thumb2.png',
        'assets/thumb3.png',
        'assets/thumb4.png',
        'assets/thumb5.png',
        'assets/foto1.png',
      ],
      etiquetas: [
        a.etiquetaCategoria,
        a.estado.split(' - ').first,
        'Produtor Verificado (CPF/CNPJ)',
      ],
      permutaSub: 'Gado ou Soja Futura',
      vendedorNome: 'Antônio Carlos Novaes',
      vendedorFazenda: 'Fazenda Boa Esperança • ${a.local}',
      vendedorDesde: 'Produtor cadastrado desde 2021',
      vendedorNota: '4.9',
      vendedorVendas: '(28 vendas\nconcluídas)',
      ficha: [
        ItemFicha(
            icone: Icons.speed,
            rotulo: 'HORÍMETRO',
            valor: '${a.horimetro} horas',
            sub: 'Informado pelo produtor',
            subVerde: true),
        ItemFicha(
            icone: Icons.calendar_month_outlined,
            rotulo: 'ANO / MODELO',
            valor: a.ano,
            sub: a.marca),
        ItemFicha(
            icone: Icons.bolt,
            rotulo: 'POTÊNCIA NOMINAL',
            valor: '${a.potencia} cv',
            sub: a.tracao),
        ItemFicha(
            icone: Icons.verified_outlined,
            rotulo: 'CONSERVAÇÃO',
            valor: a.estado.split(' - ').first,
            sub: 'Lote auditado',
            subVerde: true),
      ],
      historicoTitulo: 'Lote publicado pelo produtor',
      historicoDescricao: a.subtitulo,
      historicoObs: [
        'Contato direto via WhatsApp: ${a.whatsapp}.',
        'Ponto de inspeção e retirada: ${a.local}.',
      ],
      freteEstimado: 'R\$ 4.800',
      freteSubtitulo: 'Transportadoras credenciadas com seguro total',
    );
  }

  Future<void> _abrirAnunciar({MeuAnuncio? editar}) async {
    if (_navegando) return;
    _navegando = true;
    try {
      final res = await Navigator.push<StatusAnuncio>(
        context,
        MaterialPageRoute(
          builder: (_) => AnunciarPage(
            anuncioInicial: editar,
            abrirPainelAoPublicar: false,
          ),
        ),
      );
      if (res != null && mounted) {
        setState(() => _aba = res);
      }
    } finally {
      _navegando = false;
    }
  }

  Future<void> _abrirDetalhes(MeuAnuncio a) async {
    if (_navegando) return;
    _navegando = true;
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalhesLotePage(anuncio: _converterParaDetalhes(a)),
        ),
      );
    } finally {
      _navegando = false;
    }
  }

  void _irInicio() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      _aviso('Retornando para Início');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ativos = _store.porStatus(StatusAnuncio.ativo);
    final pausados = _store.porStatus(StatusAnuncio.pausado);
    final vendidos = _store.porStatus(StatusAnuncio.vendido);

    final listaExibida = switch (_aba) {
      StatusAnuncio.ativo => ativos,
      StatusAnuncio.pausado => pausados,
      StatusAnuncio.vendido => vendidos,
    };

    return Scaffold(
      appBar: _cabecalho(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: ListView(
            key: const Key('listaPainel'),
            children: [
              _faixaCotacoes(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _cardProdutor(_store.contar(StatusAnuncio.ativo)),
                    const SizedBox(height: 20),
                    _cabecalhoGestao(),
                    const SizedBox(height: 12),
                    _abasStatus(),
                    const SizedBox(height: 14),
                    if (listaExibida.isEmpty)
                      _vazio()
                    else
                      for (final a in listaExibida) ...[
                        _cardAnuncio(a),
                        const SizedBox(height: 16),
                      ],
                    _cardSeguranca(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _barraInferior(_store.contar(StatusAnuncio.ativo)),
    );
  }

  // P1
  PreferredSizeWidget _cabecalho() {
    return AppBar(
      backgroundColor: AgrouColors.fundo,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: 64,
      titleSpacing: 16,
      title: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset('assets/logo_agrou.jpg',
              width: 32, height: 32, fit: BoxFit.cover),
        ),
        const SizedBox(width: 8),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Agrou',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AgrouColors.verdeEscuro,
                    height: 1.05)),
            Text('Meus Anúncios',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AgrouColors.textoSec)),
          ],
        ),
      ]),
      actions: [
        Stack(alignment: Alignment.topRight, children: [
          IconButton(
            key: const Key('btnNotifPainel'),
            icon: const Icon(Icons.notifications_none_outlined,
                color: AgrouColors.azulEscuro),
            onPressed: () => _aviso('26 contatos novos no WhatsApp'),
          ),
          Positioned(
            right: 11,
            top: 11,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                  color: Color(0xFFBA1A1A), shape: BoxShape.circle),
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('assets/avatar_user.png',
                width: 32, height: 32, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }

  // P2
  Widget _faixaCotacoes() {
    return Container(
      color: AgrouColors.azulEscuro,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: const Row(children: [
        Icon(Icons.trending_up, size: 15, color: AgrouColors.verdeClaro),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            'Soja Mar/25: R\$ 138,40/sc (+0.8%)  |  Milho Campinas: R\$ 68,20/sc (-0.3%)',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: AgrouColors.verdeClaro,
                fontSize: 11,
                fontWeight: FontWeight.w600),
          ),
        ),
      ]),
    );
  }

  // P3
  Widget _cardProdutor(int qtdAtivos) {
    Widget kpi(
        Key key, IconData ic, Widget topoDir, String numTxt, String rotulo) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AgrouColors.cinzaCard,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(ic, size: 16, color: AgrouColors.verdeBotao),
                  topoDir,
                ],
              ),
              const SizedBox(height: 8),
              Text(numTxt,
                  key: key,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AgrouColors.texto)),
              const SizedBox(height: 2),
              Text(rotulo,
                  style: const TextStyle(
                      fontSize: 10.5, color: AgrouColors.textoSec)),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 8)],
      ),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(clipBehavior: Clip.none, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/painel_avatar.png',
                  width: 56, height: 56, fit: BoxFit.cover),
            ),
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE1BA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified,
                    size: 14, color: Color(0xFF7A4E00)),
              ),
            ),
          ]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEED9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Produtor Verificado ✓',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B4300))),
                ),
                const SizedBox(height: 5),
                const Text('Antônio Carlos Novaes',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: AgrouColors.texto)),
                const SizedBox(height: 2),
                const Row(children: [
                  Icon(Icons.location_on_outlined,
                      size: 14, color: AgrouColors.verdeBotao),
                  SizedBox(width: 3),
                  Expanded(
                    child: Text('Fazenda Boa Esperança • Mirassol, SP',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, color: AgrouColors.textoSec)),
                  ),
                ]),
              ],
            ),
          ),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          kpi(
            const Key('kpiAtivos'),
            Icons.inventory_2_outlined,
            const CircleAvatar(radius: 4, backgroundColor: AgrouColors.verde),
            '$qtdAtivos',
            'Anúncios Ativos',
          ),
          const SizedBox(width: 8),
          kpi(
            const Key('kpiCliques'),
            Icons.chat_outlined,
            const Text('+14%',
                style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AgrouColors.verde)),
            '48',
            'Cliques WhatsApp',
          ),
          const SizedBox(width: 8),
          kpi(
            const Key('kpiViews'),
            Icons.visibility_outlined,
            const Text('Mês',
                style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7A4E00))),
            '1.420',
            'Visualizações',
          ),
        ]),
      ]),
    );
  }

  // P4
  Widget _cabecalhoGestao() {
    return Row(children: [
      const Expanded(
        child: Text('Gestão de Lotes &\nMáquinas',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                height: 1.15,
                color: AgrouColors.texto)),
      ),
      TextButton.icon(
        key: const Key('btnNovoAnuncio'),
        onPressed: () => _abrirAnunciar(),
        icon: const Icon(Icons.add_circle_outline,
            color: AgrouColors.verdeBotao, size: 18),
        label: const Text('Novo\nanúncio',
            style: TextStyle(
                color: AgrouColors.verdeBotao,
                fontWeight: FontWeight.w700,
                height: 1.1,
                fontSize: 12.5)),
      ),
    ]);
  }

  Widget _abasStatus() {
    Widget aba(StatusAnuncio st, String nome, Key key) {
      final ativo = _aba == st;
      final qtd = _store.contar(st);
      return Expanded(
        child: InkWell(
          key: key,
          borderRadius: BorderRadius.circular(6),
          onTap: () => setState(() => _aba = st),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
            decoration: BoxDecoration(
              color: ativo ? AgrouColors.verdeBotao : const Color(0xFFECEFFE),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(
                child: Text(nome,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: ativo ? Colors.white : AgrouColors.texto)),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: ativo
                      ? const Color(0xFF288B4B)
                      : const Color(0xFFDCE2FA),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('$qtd',
                    key: Key('cnt_${st.name}'),
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: ativo ? Colors.white : AgrouColors.texto)),
              ),
            ]),
          ),
        ),
      );
    }

    return Row(children: [
      aba(StatusAnuncio.ativo, 'Ativos', const Key('abaAtivos')),
      const SizedBox(width: 8),
      aba(StatusAnuncio.pausado, 'Pausados', const Key('abaPausados')),
      const SizedBox(width: 8),
      aba(StatusAnuncio.vendido, 'Vendidos', const Key('abaVendidos')),
    ]);
  }

  Widget _vazio() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        const Icon(Icons.inventory_2_outlined,
            size: 36, color: AgrouColors.textoSec),
        const SizedBox(height: 8),
        Text(
          _aba == StatusAnuncio.vendido
              ? '4 vendas concluídas no histórico anterior'
              : 'Nenhum anúncio nesta aba',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ]),
    );
  }

  // P5 / P6
  Widget _cardAnuncio(MeuAnuncio a) {
    final pausado = a.status == StatusAnuncio.pausado;
    final vendido = a.status == StatusAnuncio.vendido;

    return Container(
      key: Key('painelCard_${a.id}'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 8)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(
          key: Key('abrirDetalhesPainel_${a.id}'),
          onTap: () => _abrirDetalhes(a),
          child: SizedBox(
            height: 156,
            width: double.infinity,
            child: Stack(fit: StackFit.expand, children: [
              Image.asset(a.imagem, fit: BoxFit.cover),
              Positioned(
                left: 10,
                top: 10,
                right: 10,
                child: Wrap(spacing: 6, runSpacing: 4, children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: pausado
                          ? const Color(0xFF9A6800)
                          : (vendido
                              ? AgrouColors.azulEscuro
                              : AgrouColors.verdeBotao),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      pausado
                          ? '⏸ Pausado • ${a.diasLabel}'
                          : (vendido
                              ? '✓ Vendido • ${a.diasLabel}'
                              : '● Ativo • ${a.diasLabel}'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  if (!pausado)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xE6FFFFFF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(a.etiquetaCategoria,
                          style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AgrouColors.texto)),
                    ),
                ]),
              ),
              if (pausado && a.avisoPausa != null)
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xF0FFFFFF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(children: [
                      const Icon(Icons.handshake_outlined,
                          size: 16, color: Color(0xFF8A5900)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(a.avisoPausa!,
                            style: const TextStyle(
                                fontSize: 11, color: AgrouColors.texto)),
                      ),
                    ]),
                  ),
                )
              else
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xCC1E2433),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(a.rodapeFoto,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            InkWell(
              onTap: () => _abrirDetalhes(a),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.titulo,
                            style: const TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w800,
                                color: AgrouColors.texto)),
                        const SizedBox(height: 4),
                        Text(a.subtitulo,
                            style: const TextStyle(
                                fontSize: 12, color: AgrouColors.textoSec)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(a.precoLabel,
                          style: const TextStyle(
                              fontSize: 10.5, color: AgrouColors.textoSec)),
                      Text('R\$ ${a.precoFormatado}',
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AgrouColors.verdeBotao)),
                    ],
                  ),
                ],
              ),
            ),
            if (!pausado && !vendido) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AgrouColors.cinzaCard,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(children: [
                  const Icon(Icons.visibility_outlined,
                      size: 15, color: Color(0xFF7A4E00)),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text('${a.visualizacoes} visualizações',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.chat_outlined,
                      size: 15, color: AgrouColors.verdeBotao),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text('${a.contatos} contatos WhatsApp',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ]),
              ),
              const SizedBox(height: 10),
              if (a.mostrarTurbinar) ...[
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: FilledButton.icon(
                    key: Key('btnTurbinar_${a.id}'),
                    onPressed: () =>
                        _aviso('Destaque regional ativado para ${a.titulo}'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF8C5A00),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    icon: const Icon(Icons.bolt, size: 18),
                    label: const Text('Turbinar Anúncio (Destaque Regional)',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Row(children: [
                Expanded(
                  child: _btnSecundario(
                    Key('btnEditar_${a.id}'),
                    Icons.edit_outlined,
                    'Editar',
                    () => _abrirAnunciar(editar: a),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _btnSecundario(
                    Key('btnPausar_${a.id}'),
                    Icons.pause_circle_outline,
                    'Pausar',
                    () {
                      _store.mudarStatus(a.id, StatusAnuncio.pausado);
                      _aviso('${a.titulo} pausado');
                    },
                  ),
                ),
                if (a.mostrarExcluir) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: _btnSecundario(
                      Key('btnExcluir_${a.id}'),
                      Icons.delete_outline,
                      'Excluir',
                      () {
                        _store.excluir(a.id);
                        _aviso('${a.titulo} excluído');
                      },
                      bg: const Color(0xFFFFDAD6),
                      fg: const Color(0xFFBA1A1A),
                    ),
                  ),
                ],
              ]),
              if (!a.mostrarExcluir) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: _btnSecundario(
                    Key('btnVendido_${a.id}'),
                    Icons.check_circle_outline,
                    'Marcar como Vendido',
                    () {
                      _store.mudarStatus(a.id, StatusAnuncio.vendido);
                      _aviso('${a.titulo} marcado como vendido');
                    },
                  ),
                ),
              ],
            ],
            if (pausado) ...[
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: FilledButton.icon(
                      key: Key('btnReativar_${a.id}'),
                      onPressed: () {
                        _store.mudarStatus(a.id, StatusAnuncio.ativo);
                        _aviso('${a.titulo} reativado');
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AgrouColors.verdeBotao,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      icon: const Icon(Icons.play_circle_outline, size: 16),
                      label: const Text('Reativar Anúncio',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _btnSecundario(
                    Key('btnConfirmarVenda_${a.id}'),
                    Icons.verified_outlined,
                    'Confirmar Venda',
                    () {
                      _store.mudarStatus(a.id, StatusAnuncio.vendido);
                      _aviso('Venda de ${a.titulo} confirmada');
                    },
                  ),
                ),
              ]),
            ],
          ]),
        ),
      ]),
    );
  }

  Widget _btnSecundario(
    Key key,
    IconData ic,
    String rotulo,
    VoidCallback onTap, {
    Color bg = const Color(0xFFECEFFE),
    Color fg = AgrouColors.texto,
  }) {
    return SizedBox(
      height: 40,
      child: FilledButton.tonal(
        key: key,
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(ic, size: 15, color: fg),
          const SizedBox(width: 4),
          Flexible(
            child: Text(rotulo,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: fg)),
          ),
        ]),
      ),
    );
  }

  // P7
  Widget _cardSeguranca() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF1FC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.verified_user,
              color: AgrouColors.verdeBotao, size: 22),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('Segurança da\nPropriedade',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    color: AgrouColors.texto)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AgrouColors.verdeBotao,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('100%\nValidado',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    height: 1.1)),
          ),
        ]),
        const SizedBox(height: 10),
        const Text(
          'Documentação do produtor auditada. Seus anúncios possuem selo de confiabilidade institucional contra fraudes.',
          style: TextStyle(fontSize: 12.5, color: AgrouColors.textoSec),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(children: [
            Row(children: [
              Icon(Icons.check_circle_outline,
                  size: 16, color: AgrouColors.verdeBotao),
              SizedBox(width: 8),
              Expanded(
                child: Text('CPF / CNPJ Titular',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              Text('***.482.908-**',
                  style: TextStyle(fontSize: 12, color: AgrouColors.textoSec)),
            ]),
            SizedBox(height: 8),
            Row(children: [
              Icon(Icons.check_circle_outline,
                  size: 16, color: AgrouColors.verdeBotao),
              SizedBox(width: 8),
              Expanded(
                child: Text('CAR (Cadastro Ambiental Rural)',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              Text('SP-3530300-***',
                  style: TextStyle(fontSize: 12, color: AgrouColors.textoSec)),
            ]),
          ]),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: _btnSecundario(
              const Key('btnCartilha'),
              Icons.gavel_outlined,
              'Cartilha Antifraude',
              () => _aviso('Cartilha antifraude aberta'),
              bg: const Color(0xFFDCE3FA),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 40,
              child: FilledButton.icon(
                key: const Key('btnSuporteWhats'),
                onPressed: () => _aviso('Abrindo suporte Agrou no WhatsApp'),
                style: FilledButton.styleFrom(
                  backgroundColor: AgrouColors.verdeBotao,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                icon: const Icon(Icons.support_agent, size: 15),
                label: const Text('Suporte WhatsApp',
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ]),
      ]),
    );
  }

  // P8
  Widget _barraInferior(int qtdAtivos) {
    Widget navItem(Key key, IconData icone, String rotulo,
        {bool ativo = false, String? badge, VoidCallback? onTap}) {
      final cor = ativo ? AgrouColors.verdeBotao : AgrouColors.textoSec;
      return Expanded(
        child: InkWell(
          key: key,
          onTap: onTap ?? () => _aviso('Tela $rotulo fora do escopo atual'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(clipBehavior: Clip.none, children: [
                Icon(icone, size: 22, color: cor),
                if (badge != null)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: AgrouColors.verdeBotao,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(badge,
                          key: const Key('badgeNavAnuncios'),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
              ]),
              const SizedBox(height: 2),
              Text(rotulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: ativo ? FontWeight.w700 : FontWeight.w500,
                      color: cor)),
            ],
          ),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 68),
      decoration: const BoxDecoration(
        color: AgrouColors.fundo,
        border: Border(top: BorderSide(color: AgrouColors.lavanda)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            navItem(const Key('painelNavInicio'), Icons.home_outlined, 'Início',
                onTap: _irInicio),
            navItem(const Key('painelNavExplorar'), Icons.search, 'Explorar'),
            Expanded(
              child: InkWell(
                key: const Key('painelNavAnunciar'),
                onTap: () => _abrirAnunciar(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AgrouColors.verdeBotao,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                    const SizedBox(height: 2),
                    const Text('Anunciar',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AgrouColors.verdeBotao)),
                  ],
                ),
              ),
            ),
            navItem(const Key('painelNavAnuncios'), Icons.grid_view_outlined,
                'Anúncios',
                ativo: true,
                badge: '$qtdAtivos',
                onTap: () => setState(() => _aba = StatusAnuncio.ativo)),
            navItem(
                const Key('painelNavPerfil'), Icons.person_outline, 'Perfil'),
          ]),
        ),
      ),
    );
  }
}
