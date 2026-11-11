import 'package:flutter/material.dart';

import '../models/anuncio.dart';
import '../theme/agrou_colors.dart';
import 'detalhes_lote_page.dart';

class InicioPage extends StatefulWidget {
  final List<Anuncio> anuncios;

  const InicioPage({
    super.key,
    this.anuncios = anunciosIniciais,
  });

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final TextEditingController _buscaCtrl = TextEditingController();
  String _termoBusca = '';
  String? _regiaoSelecionada;
  String? _setorSelecionado;
  String _modalidadeSelecionada = 'Compra Direta';
  final Set<String> _favoritos = {};
  bool _navegando = false;

  static const _regioes = [
    'Todas as regiões',
    'Mato Grosso & SP',
    'Minas Gerais',
    'Goiás',
  ];

  @override
  void dispose() {
    _buscaCtrl.dispose();
    super.dispose();
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

  List<Anuncio> get _anunciosFiltrados {
    return widget.anuncios.where((a) {
      if (_setorSelecionado != null && a.setor != _setorSelecionado) {
        return false;
      }
      if (!a.modalidades.contains(_modalidadeSelecionada)) {
        return false;
      }
      if (_regiaoSelecionada != null &&
          _regiaoSelecionada != 'Todas as regiões' &&
          a.regiaoFiltro != _regiaoSelecionada) {
        return false;
      }
      if (_termoBusca.isNotEmpty) {
        final q = _termoBusca.toLowerCase();
        final texto =
            '${a.tituloCard} ${a.tituloDetalhe} ${a.categoriaCard} ${a.cidadeUf} ${a.setor}'
                .toLowerCase();
        if (!texto.contains(q)) return false;
      }
      return true;
    }).toList();
  }

  void _aplicarBusca() {
    setState(() {
      _termoBusca = _buscaCtrl.text.trim();
    });
  }

  void _limparFiltros() {
    setState(() {
      _buscaCtrl.clear();
      _termoBusca = '';
      _regiaoSelecionada = null;
      _setorSelecionado = null;
      _modalidadeSelecionada = 'Compra Direta';
    });
  }

  Future<void> _escolherRegiao() async {
    final escolhida = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Selecionar região',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            for (final r in _regioes)
              ListTile(
                key: Key('regiao_$r'),
                leading: Icon(
                  Icons.location_on_outlined,
                  color: (_regiaoSelecionada ?? 'Todas as regiões') == r
                      ? AgrouColors.verdeBotao
                      : AgrouColors.textoSec,
                ),
                title: Text(r),
                onTap: () => Navigator.pop(ctx, r),
              ),
          ],
        ),
      ),
    );
    if (escolhida != null) {
      setState(() {
        _regiaoSelecionada =
            escolhida == 'Todas as regiões' ? null : escolhida;
      });
    }
  }

  Future<void> _abrirDetalhes(Anuncio anuncio) async {
    if (_navegando) return;
    _navegando = true;
    try {
      final resultado = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => DetalhesLotePage(
            anuncio: anuncio,
            favoritoInicial: _favoritos.contains(anuncio.id),
          ),
        ),
      );
      if (resultado != null && mounted) {
        setState(() {
          if (resultado) {
            _favoritos.add(anuncio.id);
          } else {
            _favoritos.remove(anuncio.id);
          }
        });
      }
    } finally {
      _navegando = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lista = _anunciosFiltrados;
    return Scaffold(
      appBar: _cabecalho(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: ListView(
            children: [
              _faixaMercado(),
              _heroBusca(),
              _faixaVerificacao(),
              _setoresPrincipais(),
              _modalidadesNegocio(),
              _cabecalhoOportunidades(lista.length),
              if (lista.isEmpty)
                _estadoVazio()
              else
                for (final a in lista) _cardOportunidade(a),
              _bannerCta(),
              _rodapeInstitucional(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _barraInferior(),
    );
  }

  // E1
  PreferredSizeWidget _cabecalho() {
    return AppBar(
      backgroundColor: AgrouColors.fundo,
      surfaceTintColor: Colors.transparent,
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
            Text('Início',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AgrouColors.textoSec)),
          ],
        ),
      ]),
      actions: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              key: const Key('btnNotificacoes'),
              icon: const Icon(Icons.notifications_none_outlined,
                  color: AgrouColors.azulEscuro),
              onPressed: () => _aviso('Nenhuma notificação nova'),
            ),
            Positioned(
              right: 11,
              top: 11,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFBA1A1A),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            key: const Key('btnAvatarUsuario'),
            onTap: () => _aviso('Usuário logado: Antônio Carlos Novaes'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset('assets/avatar_user.png',
                  width: 32, height: 32, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }

  // E2
  Widget _faixaMercado() {
    return Container(
      constraints: const BoxConstraints(minHeight: 36),
      color: AgrouColors.azulEscuro,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: const Row(children: [
        CircleAvatar(radius: 4, backgroundColor: AgrouColors.verdeClaro),
        SizedBox(width: 6),
        Flexible(
          child: Text('MERCADO AGORA',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4)),
        ),
        SizedBox(width: 8),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('Boi Gordo SP: ',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
              Text('R\$ 315,50/@ ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
              Icon(Icons.trending_up, size: 14, color: AgrouColors.verdeClaro),
              SizedBox(width: 2),
              Text('+0.8%',
                  style: TextStyle(
                      color: AgrouColors.verdeClaro,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
        ),
      ]),
    );
  }

  // E3
  Widget _heroBusca() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AgrouColors.verdeBotao, AgrouColors.verde],
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.verified_user_outlined,
                size: 14, color: AgrouColors.verdeClaro),
            SizedBox(width: 6),
            Flexible(
              child: Text('Plataforma Oficial do Agronegócio',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600)),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        const Text(
          'Negocie direto no campo sem intermediários',
          style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
              height: 1.15),
        ),
        const SizedBox(height: 10),
        const Text(
          'A maior rede de pecuaristas, cerealistas e produtores rurais do Brasil. Conecte tratores, gado e insumos em tempo recorde.',
          style: TextStyle(
              color: Color(0xFFE6F4EA), fontSize: 12.5, height: 1.4),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: const [
              BoxShadow(color: Color(0x22000000), blurRadius: 8)
            ],
          ),
          child: Column(children: [
            Row(children: [
              const Icon(Icons.search, size: 20, color: AgrouColors.textoSec),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  key: const Key('campoBusca'),
                  controller: _buscaCtrl,
                  onSubmitted: (_) => _aplicarBusca(),
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(
                    hintText:
                        'Buscar tratores, nelore, soja, colheitadeiras...',
                    hintStyle:
                        TextStyle(fontSize: 12.5, color: AgrouColors.textoSec),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                  ),
                ),
              ),
              InkWell(
                key: const Key('btnFiltrosAvancados'),
                onTap: () => _aviso('Filtros técnicos aplicados'),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEDFF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.tune,
                      size: 17, color: AgrouColors.texto),
                ),
              ),
            ]),
            const Divider(color: Color(0xFFEAEDFF), height: 14, thickness: 1),
            Row(children: [
              Expanded(
                child: InkWell(
                  key: const Key('btnRegiao'),
                  onTap: _escolherRegiao,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.location_on_outlined,
                        size: 17, color: AgrouColors.texto),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        _regiaoSelecionada ?? 'Mato Grosso & SP',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AgrouColors.texto),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down,
                        size: 18, color: AgrouColors.textoSec),
                  ]),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                key: const Key('btnBuscar'),
                onPressed: _aplicarBusca,
                style: FilledButton.styleFrom(
                  backgroundColor: AgrouColors.verdeBotao,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('Buscar',
                      style:
                          TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 15),
                ]),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }

  // E4
  Widget _faixaVerificacao() {
    return GestureDetector(
      key: const Key('faixaVerificacao'),
      onTap: () => _aviso('Produtores validados por CAR, GTA e Sefaz'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AgrouColors.cinzaCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AgrouColors.lavanda),
        ),
        child: Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFB8F7C6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.verified_outlined,
                color: AgrouColors.verdeEscuro, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('100% Produtores Verificados',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AgrouColors.texto)),
              SizedBox(height: 2),
              Text('Zero Golpes • Checagem de CAR, GTA e Nota Fiscal',
                  style: TextStyle(fontSize: 11.5, color: AgrouColors.textoSec)),
            ]),
          ),
          const Icon(Icons.chevron_right,
              size: 18, color: AgrouColors.textoSec),
        ]),
      ),
    );
  }

  // E5
  Widget _setoresPrincipais() {
    Widget cardSetor(SetorInfo s) {
      final selecionado = _setorSelecionado == s.id;
      return Expanded(
        child: GestureDetector(
          key: Key('setor_${s.id}'),
          onTap: () => setState(() {
            _setorSelecionado = selecionado ? null : s.id;
          }),
          child: Container(
            height: 128,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: selecionado
                  ? Border.all(color: AgrouColors.verdeBotao, width: 3)
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(fit: StackFit.expand, children: [
              Image.asset(s.imagem, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.78),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(children: [
                      Icon(s.icone, color: AgrouColors.verdeClaro, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          s.titulo,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              height: 1.15),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 4),
                    Text(
                      s.subtitulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 10.5),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Setores Principais',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
              Text('Explore por cadeia produtiva',
                  style: TextStyle(fontSize: 12, color: AgrouColors.textoSec)),
            ]),
          ),
          TextButton(
            key: const Key('btnVerTodosSetores'),
            onPressed: _limparFiltros,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Ver todos>',
                style: TextStyle(
                    color: AgrouColors.verdeBotao,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          cardSetor(setoresPrincipais[0]),
          const SizedBox(width: 8),
          cardSetor(setoresPrincipais[1]),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          cardSetor(setoresPrincipais[2]),
          const SizedBox(width: 8),
          cardSetor(setoresPrincipais[3]),
        ]),
      ]),
    );
  }

  // E6
  Widget _modalidadesNegocio() {
    Widget botaoMod(String nome, IconData icone, {Color? iconeCor}) {
      final ativo = _modalidadeSelecionada == nome;
      return Expanded(
        child: GestureDetector(
          key: Key('mod_$nome'),
          onTap: () => setState(() => _modalidadeSelecionada = nome),
          child: Container(
            constraints: const BoxConstraints(minHeight: 74),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            decoration: BoxDecoration(
              color: ativo ? AgrouColors.verdeBotao : AgrouColors.cinzaCard,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icone,
                    size: 20,
                    color: ativo ? Colors.white : (iconeCor ?? AgrouColors.texto)),
                const SizedBox(height: 6),
                Text(
                  nome,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: ativo ? Colors.white : AgrouColors.texto,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Modalidades de Negócio',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            botaoMod('Compra Direta', Icons.shopping_cart_outlined),
            const SizedBox(width: 8),
            botaoMod('Leilões Ativos', Icons.gavel_outlined),
            const SizedBox(width: 8),
            botaoMod('Barter & Permuta', Icons.swap_horiz,
                iconeCor: const Color(0xFF9A6A00)),
          ]),
        ),
      ]),
    );
  }

  // E7 cabeçalho
  Widget _cabecalhoOportunidades(int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.local_fire_department_outlined,
              size: 20, color: AgrouColors.verdeBotao),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Oportunidades do Dia',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),
            const Text('Lotes auditados com documentação regular',
                style: TextStyle(fontSize: 12, color: AgrouColors.textoSec)),
          ]),
        ),
        if (_setorSelecionado != null ||
            _regiaoSelecionada != null ||
            _termoBusca.isNotEmpty ||
            _modalidadeSelecionada != 'Compra Direta')
          TextButton(
            key: const Key('btnLimparFiltrosTopo'),
            onPressed: _limparFiltros,
            child: Text('Limpar ($total)',
                style: const TextStyle(
                    fontSize: 12, color: AgrouColors.verdeBotao)),
          ),
      ]),
    );
  }

  Widget _estadoVazio() {
    final ehLeilao = _modalidadeSelecionada == 'Leilões Ativos';
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AgrouColors.lavanda),
      ),
      child: Column(children: [
        Icon(ehLeilao ? Icons.gavel_outlined : Icons.search_off,
            size: 36, color: AgrouColors.textoSec),
        const SizedBox(height: 10),
        Text(
          ehLeilao
              ? 'Nenhum leilão ativo no momento'
              : 'Nenhum anúncio encontrado',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tente ajustar os termos de busca ou limpar os filtros aplicados.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.5, color: AgrouColors.textoSec),
        ),
        const SizedBox(height: 14),
        FilledButton(
          key: const Key('btnVerTodosVazio'),
          onPressed: _limparFiltros,
          style: FilledButton.styleFrom(backgroundColor: AgrouColors.verdeBotao),
          child: Text(ehLeilao ? 'Ver todos os lotes' : 'Limpar filtros'),
        ),
      ]),
    );
  }

  // E7 Card de Oportunidade
  Widget _cardOportunidade(Anuncio a) {
    final favoritado = _favoritos.contains(a.id);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 8)],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('card_${a.id}'),
        onTap: () => _abrirDetalhes(a),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 192,
            width: double.infinity,
            child: Stack(fit: StackFit.expand, children: [
              Image.asset(a.imagemCard, fit: BoxFit.cover),
              Positioned(
                left: 10,
                top: 10,
                right: 54,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: a.badgeFotoTopoCor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(
                        a.badgeTopoEstrela
                            ? Icons.star_border
                            : Icons.verified_outlined,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(a.badgeFotoTopo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ),
                    ]),
                  ),
                ),
              ),
              if (favoritado)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    key: Key('badgeFavorito_${a.id}'),
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite,
                        color: Colors.red, size: 16),
                  ),
                ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(a.badgeFotoBase,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      a.categoriaCard,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AgrouColors.verdeBotao,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: AgrouColors.textoSec),
                  const SizedBox(width: 2),
                  Flexible(
                    flex: 2,
                    child: Text(a.cidadeUf,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 12, color: AgrouColors.textoSec)),
                  ),
                ]),
                const SizedBox(height: 6),
                Text(a.tituloCard,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AgrouColors.texto,
                        height: 1.2)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AgrouColors.cinzaCard,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.spec1Rotulo,
                                style: const TextStyle(
                                    fontSize: 11, color: AgrouColors.textoSec)),
                            const SizedBox(height: 2),
                            Text(a.spec1Valor,
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.spec2Rotulo,
                                style: const TextStyle(
                                    fontSize: 11, color: AgrouColors.textoSec)),
                            const SizedBox(height: 2),
                            Text(a.spec2Valor,
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.precoLabel,
                            style: const TextStyle(
                                fontSize: 11.5, color: AgrouColors.textoSec)),
                        Text('R\$ ${a.preco}',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AgrouColors.verde)),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    key: Key('btnNegociar_${a.id}'),
                    onPressed: () => _abrirDetalhes(a),
                    style: FilledButton.styleFrom(
                      backgroundColor: AgrouColors.verdeBotao,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    icon: const Icon(Icons.chat_outlined, size: 16),
                    label: const Text('Negociar',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ]),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  // E8
  Widget _bannerCta() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AgrouColors.azulEscuro,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('VENDA DIRETA SEM COMISSÃO',
            style: TextStyle(
                color: AgrouColors.verdeClaro,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5)),
        const SizedBox(height: 10),
        const Text('Tem maquinário ou gado para negociar?',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.15)),
        const SizedBox(height: 8),
        const Text(
            'Crie seu anúncio grátis em 2 minutos e receba propostas diretas no WhatsApp de compradores qualificados de todo o Brasil.',
            style: TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.4)),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: FilledButton.icon(
            key: const Key('btnPublicarCta'),
            onPressed: () =>
                _aviso('Criação de anúncio disponível na próxima entrega'),
            style: FilledButton.styleFrom(
              backgroundColor: AgrouColors.verdeBotao,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            icon: const Icon(Icons.add_circle_outline, size: 18),
            label: const Text('Publicar Anúncio Grátis',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 14),
        const SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 18,
            runSpacing: 8,
            children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.check_circle_outline,
                    size: 14, color: AgrouColors.verdeClaro),
                SizedBox(width: 4),
                Text('Sem mensalidade',
                    style: TextStyle(color: Colors.white70, fontSize: 11.5)),
              ]),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.check_circle_outline,
                    size: 14, color: AgrouColors.verdeClaro),
                SizedBox(width: 4),
                Text('Contato Direto',
                    style: TextStyle(color: Colors.white70, fontSize: 11.5)),
              ]),
            ],
          ),
        ),
      ]),
    );
  }

  // E9
  Widget _rodapeInstitucional() {
    Widget link(String texto) => GestureDetector(
          onTap: () => _aviso('$texto em breve'),
          child: Text(texto,
              style: const TextStyle(
                  color: AgrouColors.verdeBotao,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        );

    return Container(
      margin: const EdgeInsets.only(top: 24),
      color: AgrouColors.lavanda,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.agriculture, color: AgrouColors.verdeBotao, size: 22),
          SizedBox(width: 6),
          Text('Agrou',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 8),
        const Text(
          'O ecossistema digital seguro para o produtor rural brasileiro. Conectando compradores, criadores e cooperativas em um só lugar.',
          style: TextStyle(
              fontSize: 12, color: AgrouColors.textoSec, height: 1.4),
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: link('Termos e Condições')),
          Expanded(child: link('Privacidade & LGPD')),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: link('Suporte ao Produtor')),
          Expanded(child: link('Segurança & GTA')),
        ]),
        const Divider(color: Color(0xFFC8D2F5), height: 24),
        const Text(
          '© 2026 Agrou Tecnologia Agrícola Ltda. Todos os direitos reservados.',
          style: TextStyle(fontSize: 11, color: AgrouColors.textoSec),
        ),
      ]),
    );
  }

  // E10
  Widget _barraInferior() {
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
            navItem(const Key('navInicio'), Icons.home_outlined, 'Início',
                ativo: true, onTap: _limparFiltros),
            navItem(const Key('navExplorar'), Icons.search, 'Explorar'),
            Expanded(
              child: InkWell(
                key: const Key('navAnunciar'),
                onTap: () =>
                    _aviso('Criação de anúncio disponível na próxima entrega'),
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
            navItem(
                const Key('navAnuncios'), Icons.grid_view_outlined, 'Anúncios',
                badge: '3'),
            navItem(const Key('navPerfil'), Icons.person_outline, 'Perfil'),
          ]),
        ),
      ),
    );
  }
}
