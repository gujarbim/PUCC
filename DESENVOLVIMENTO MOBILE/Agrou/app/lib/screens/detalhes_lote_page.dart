import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/anuncio.dart';
import '../theme/agrou_colors.dart';

class DetalhesLotePage extends StatefulWidget {
  final Anuncio? anuncio;
  final bool favoritoInicial;

  const DetalhesLotePage({
    super.key,
    this.anuncio,
    this.favoritoInicial = false,
  });

  @override
  State<DetalhesLotePage> createState() => _DetalhesLotePageState();
}

class _DetalhesLotePageState extends State<DetalhesLotePage> {
  Anuncio get dados => widget.anuncio ?? anuncioPadrao;

  int fotoAtual = 0;
  late bool favorito;
  bool _voltando = false;

  @override
  void initState() {
    super.initState();
    favorito = widget.favoritoInicial;
  }

  void aviso(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ));
  }

  void irPara(int i) =>
      setState(() => fotoAtual = i % dados.fotosDetalhe.length);

  Future<void> abrirWhatsApp() async {
    final msg = 'Olá! Tenho interesse no ${dados.tituloDetalhe} (${dados.codigo})';
    final uri = Uri.parse(
        'https://wa.me/5517999821234?text=${Uri.encodeComponent(msg)}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> calcularCep() async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Calcular frete'),
        content: TextField(
          key: const Key('campoCep'),
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Digite seu CEP'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Calcular')),
        ],
      ),
    );
    if (ok == true) {
      final cepLimpo = ctrl.text.replaceAll(RegExp(r'\D'), '');
      if (cepLimpo.length != 8) {
        aviso('Informe um CEP válido com 8 dígitos');
        return;
      }
      aviso('Frete estimado: ${dados.freteEstimado}');
    }
  }

  void voltar() {
    if (_voltando) return;
    if (Navigator.canPop(context)) {
      _voltando = true;
      Navigator.pop(context, favorito);
    } else {
      aviso('Voltando para o Início');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_voltando && Navigator.canPop(context)) {
          _voltando = true;
          Navigator.pop(context, favorito);
        }
      },
      child: Scaffold(
        appBar: _cabecalho(),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: ListView(
              children: [
                _galeria(),
                _miniaturas(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _etiquetas(),
                      const SizedBox(height: 20),
                      _tituloLocal(),
                      const SizedBox(height: 20),
                      _cardPreco(),
                      const SizedBox(height: 16),
                      _cardVendedor(),
                      const SizedBox(height: 16),
                      _fichaTecnica(),
                      const SizedBox(height: 16),
                      _historico(),
                      const SizedBox(height: 16),
                      _frete(),
                      const SizedBox(height: 16),
                      _diretrizes(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _rodape(),
      ),
    );
  }

  // E1
  PreferredSizeWidget _cabecalho() {
    return AppBar(
      backgroundColor: AgrouColors.fundo,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 64,
      leading: IconButton(
        key: const Key('btnVoltar'),
        icon: const Icon(Icons.arrow_back),
        onPressed: voltar,
      ),
      titleSpacing: 0,
      title: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          color: const Color(0xFFF1F3EE),
          child: const Text('Agrou',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AgrouColors.verdeEscuro)),
        ),
        const SizedBox(width: 10),
        const Flexible(
          child: Text('Detalhes Do Lote',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        ),
      ]),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/avatar_user.png')),
        ),
      ],
    );
  }

  Widget _botaoFoto(IconData icon, VoidCallback onTap, Key key,
      {Color? cor}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        key: key,
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: SizedBox(
            width: 40, height: 40, child: Icon(icon, size: 20, color: cor)),
      ),
    );
  }

  // E2
  Widget _galeria() {
    final fotos = dados.fotosDetalhe;
    return SizedBox(
      height: 292,
      child: Stack(fit: StackFit.expand, children: [
        Image.asset(fotos[fotoAtual], fit: BoxFit.cover),
        Positioned(
          left: 12,
          top: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              const Icon(Icons.photo_camera_outlined,
                  size: 14, color: Colors.white),
              const SizedBox(width: 4),
              Text('${fotoAtual + 1}/${fotos.length}',
                  key: const Key('contadorFoto'),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
        Positioned(
          right: 12,
          top: 12,
          child: Row(children: [
            _botaoFoto(
              favorito ? Icons.favorite : Icons.favorite_border,
              () {
                setState(() => favorito = !favorito);
                aviso(favorito
                    ? 'Adicionado aos favoritos'
                    : 'Removido dos favoritos');
              },
              const Key('btnFavoritar'),
              cor: favorito ? Colors.red : null,
            ),
            const SizedBox(width: 8),
            _botaoFoto(Icons.share_outlined,
                () => aviso('Link do anúncio copiado'),
                const Key('btnCompartilhar')),
          ]),
        ),
        Positioned(
          left: 8,
          top: 130,
          child: _botaoFoto(Icons.chevron_left,
              () => irPara(fotoAtual - 1 + fotos.length),
              const Key('btnAnterior')),
        ),
        Positioned(
          right: 8,
          top: 130,
          child: _botaoFoto(Icons.chevron_right, () => irPara(fotoAtual + 1),
              const Key('btnProxima')),
        ),
      ]),
    );
  }

  // E3
  Widget _miniaturas() {
    final fotos = dados.fotosDetalhe;
    final count = fotos.length > 5 ? 5 : fotos.length;
    return Transform.translate(
      offset: const Offset(0, -12),
      child: SizedBox(
        height: 48,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: count,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, i) => GestureDetector(
            key: Key('miniatura$i'),
            onTap: () => irPara(i),
            child: Container(
              width: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color: i == fotoAtual
                        ? AgrouColors.verde
                        : Colors.transparent,
                    width: 2),
                image: DecorationImage(
                    image: AssetImage(fotos[i]), fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // E4
  Widget _etiquetas() {
    Widget tag(IconData ic, String t, Color bg, Color fg) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration:
              BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(ic, size: 14, color: fg),
            const SizedBox(width: 4),
            Flexible(
                child: Text(t,
                    style: TextStyle(
                        color: fg, fontSize: 12, fontWeight: FontWeight.w600))),
          ]),
        );
    final tags = dados.etiquetas;
    return Wrap(spacing: 8, runSpacing: 8, children: [
      if (tags.isNotEmpty)
        tag(Icons.agriculture_outlined, tags[0], const Color(0xFFDCE4FF),
            const Color(0xFF2B3550)),
      if (tags.length > 1)
        tag(Icons.verified_outlined, tags[1], const Color(0xFF8AF7A0),
            AgrouColors.verdeEscuro),
      if (tags.length > 2)
        tag(Icons.shield_outlined, tags[2], const Color(0xFFFFDDB3),
            const Color(0xFF3A2400)),
    ]);
  }

  // E5
  Widget _tituloLocal() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(dados.tituloDetalhe,
          key: const Key('tituloDetalhe'),
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.location_on_outlined,
            size: 18, color: AgrouColors.verde),
        const SizedBox(width: 4),
        Expanded(
          child: Text(dados.localDetalhe,
              style:
                  const TextStyle(color: AgrouColors.textoSec, fontSize: 14)),
        ),
      ]),
    ]);
  }

  Widget _card({required Widget child, Color cor = Colors.white}) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: Color(0x0F000000), blurRadius: 6)
          ],
        ),
        child: child,
      );

  // E6
  Widget _cardPreco() {
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('VALOR À VISTA NEGOCIÁVEL',
                  style: TextStyle(
                      fontSize: 11,
                      letterSpacing: .5,
                      color: AgrouColors.textoSec)),
              const SizedBox(height: 4),
              Text.rich(TextSpan(children: [
                const TextSpan(
                    text: 'R\$ ',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AgrouColors.verde)),
                TextSpan(
                    text: dados.preco,
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AgrouColors.verde)),
              ])),
            ]),
          ),
          Flexible(
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: const Color(0xFFE3E8FF),
                    borderRadius: BorderRadius.circular(4)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.swap_horiz, size: 14),
                  SizedBox(width: 4),
                  Text('Permuta',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ]),
              ),
              const SizedBox(height: 4),
              Text(dados.permutaSub,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 11, color: AgrouColors.textoSec)),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: AgrouColors.cinzaCard,
              borderRadius: BorderRadius.circular(6)),
          child: const Row(children: [
            Icon(Icons.lock_outline, color: AgrouColors.verde, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                  'Garantia Agrou Safe: pagamento retido em conta escrow até validação do laudo no embarque.',
                  style: TextStyle(fontSize: 12)),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _miniInfo(IconData ic, String rotulo, String valor) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: AgrouColors.cinzaCard,
              borderRadius: BorderRadius.circular(6)),
          child: Row(children: [
            Icon(ic, size: 16, color: AgrouColors.verde),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rotulo,
                        style: const TextStyle(
                            fontSize: 9, color: AgrouColors.textoSec)),
                    Text(valor, style: const TextStyle(fontSize: 12)),
                  ]),
            ),
          ]),
        ),
      );

  // E7
  Widget _cardVendedor() {
    return _card(
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/avatar_vendedor.png',
                  width: 48, height: 48, fit: BoxFit.cover),
            ),
          ]),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(
                  child: Text(dados.vendedorNome,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.verified_outlined,
                    size: 14, color: AgrouColors.verde),
              ]),
              Text(dados.vendedorFazenda,
                  style: const TextStyle(
                      fontSize: 12, color: AgrouColors.textoSec)),
              Text(dados.vendedorDesde,
                  style: const TextStyle(
                      fontSize: 11, color: AgrouColors.textoSec)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: const Color(0xFFE3E8FF),
                  borderRadius: BorderRadius.circular(6)),
              child: Row(children: [
                const Icon(Icons.star, size: 14, color: Color(0xFF9A6A00)),
                const SizedBox(width: 2),
                Text(dados.vendedorNota,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ]),
            ),
            const SizedBox(height: 4),
            Text(dados.vendedorVendas,
                style:
                    const TextStyle(fontSize: 10, color: AgrouColors.textoSec)),
          ]),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          _miniInfo(Icons.schedule, 'RESPOSTA', '< 15 minutos'),
          const SizedBox(width: 8),
          _miniInfo(Icons.receipt_long_outlined, 'NF ORIGEM',
              'Validada no Sefaz'),
        ]),
      ]),
    );
  }

  Widget _itemFicha(ItemFicha item) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: AgrouColors.cinzaCard,
            borderRadius: BorderRadius.circular(6)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(item.icone, size: 12, color: AgrouColors.textoSec),
            const SizedBox(width: 4),
            Flexible(
              child: Text(item.rotulo,
                  style: const TextStyle(
                      fontSize: 10, color: AgrouColors.textoSec)),
            ),
          ]),
          const SizedBox(height: 6),
          Text(item.valor,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(item.sub,
              style: TextStyle(
                  fontSize: 10,
                  color:
                      item.subVerde ? AgrouColors.verde : AgrouColors.textoSec)),
        ]),
      );

  Widget _titulo(IconData ic, String t, {Widget? trailing}) => Row(children: [
        Icon(ic, color: AgrouColors.verde, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(t,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          Flexible(child: trailing),
        ],
      ]);

  // E8
  Widget _fichaTecnica() {
    Widget par(Widget a, Widget b) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(child: a),
              const SizedBox(width: 10),
              Expanded(child: b),
            ]),
          ),
        );
    final itens = dados.ficha;
    return _card(
      child: Column(children: [
        _titulo(Icons.tune, 'Ficha Técnica Oficial',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: AgrouColors.cinzaCard,
              child: const Text('REVISÃO AUTORIZADA',
                  style: TextStyle(
                      fontSize: 9,
                      color: AgrouColors.verde,
                      fontWeight: FontWeight.w600)),
            )),
        const SizedBox(height: 14),
        for (int i = 0; i + 1 < itens.length; i += 2)
          par(_itemFicha(itens[i]), _itemFicha(itens[i + 1])),
        if (itens.length.isOdd) _itemFicha(itens.last),
      ]),
    );
  }

  // E9
  Widget _historico() {
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _titulo(Icons.description_outlined, 'Histórico de Manutenção'),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: AgrouColors.cinzaCard,
              borderRadius: BorderRadius.circular(6)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.verified_outlined,
                color: AgrouColors.verde, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dados.historicoTitulo,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(dados.historicoDescricao,
                        style: const TextStyle(
                            fontSize: 13, color: AgrouColors.textoSec)),
                  ]),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        const Text('Observações do Proprietário:',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        for (final o in dados.historicoObs)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.only(top: 6, right: 8),
                child: CircleAvatar(radius: 3, backgroundColor: AgrouColors.verde),
              ),
              Expanded(child: Text(o, style: const TextStyle(fontSize: 13))),
            ]),
          ),
      ]),
    );
  }

  // E10
  Widget _frete() {
    return _card(
      child: Column(children: [
        _titulo(Icons.local_shipping_outlined, 'Simulação de Prancha & Frete',
            trailing: Text('Origem:\n${dados.cidadeUf.replaceAll(', ', '/')}',
                style: const TextStyle(
                    fontSize: 11,
                    color: AgrouColors.verde,
                    fontWeight: FontWeight.w600))),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: AgrouColors.cinzaCard,
              borderRadius: BorderRadius.circular(6)),
          child: Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dados.freteSubtitulo,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const Text('Transportadoras credenciadas com seguro total',
                        style: TextStyle(
                            fontSize: 11, color: AgrouColors.textoSec)),
                  ]),
            ),
            FilledButton.tonal(
              key: const Key('btnCalcularCep'),
              onPressed: calcularCep,
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFDCE4FF),
                  foregroundColor: AgrouColors.texto,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
              child: const Text('Calcular\nCEP', textAlign: TextAlign.center),
            ),
          ]),
        ),
      ]),
    );
  }

  // E11
  Widget _diretrizes() {
    return _card(
      cor: const Color(0xFFF1F2FA),
      child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.gpp_maybe_outlined, color: Color(0xFF9A6A00)),
        SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Diretrizes de Segurança Agrou',
                style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text(
                'Nunca realize transferências de sinal ou adiantamentos sem verificar presencialmente a máquina ou contratar nossa vistoria técnica terceirizada. Os pagamentos oficiais do Agrou são processados via Transporte Eletrônico (GT-e).',
                style: TextStyle(fontSize: 12, color: AgrouColors.textoSec)),
          ]),
        ),
      ]),
    );
  }

  // E12
  Widget _rodape() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: SafeArea(
        top: false,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: FilledButton.icon(
                  key: const Key('btnWhatsApp'),
                  onPressed: abrirWhatsApp,
                  style: FilledButton.styleFrom(
                      backgroundColor: AgrouColors.whatsapp,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text('Negociar no WhatsApp',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 50,
              height: 50,
              child: IconButton.filledTonal(
                key: const Key('btnTelefone'),
                style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFDCE4FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                onPressed: () => aviso('Ligando para ${dados.vendedorNome}…'),
                icon: const Icon(Icons.phone_outlined),
              ),
            ),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            Expanded(
              flex: 3,
              child: TextButton.icon(
                key: const Key('btnProposta'),
                onPressed: () => aviso('Proposta formal em breve'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.assignment_turned_in_outlined,
                    size: 16, color: AgrouColors.verde),
                label: const Text(
                    'Emitir Proposta Formal com Garantia de Compra',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AgrouColors.verde,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              flex: 1,
              child: Text('Anúncio ${dados.codigo}',
                  maxLines: 2,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 10, color: AgrouColors.textoSec)),
            ),
          ]),
        ]),
      ),
    );
  }
}
