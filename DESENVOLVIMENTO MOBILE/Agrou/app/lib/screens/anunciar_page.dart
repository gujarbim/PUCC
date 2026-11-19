import 'package:flutter/material.dart';

import '../models/meus_anuncios.dart';
import '../theme/agrou_colors.dart';
import 'painel_page.dart';

class AnunciarPage extends StatefulWidget {
  final MeuAnuncio? anuncioInicial;
  final bool abrirPainelAoPublicar;

  const AnunciarPage({
    super.key,
    this.anuncioInicial,
    this.abrirPainelAoPublicar = true,
  });

  @override
  State<AnunciarPage> createState() => _AnunciarPageState();
}

class _FotoItem {
  final String asset;
  final String rotulo;
  final bool verificada;

  const _FotoItem(this.asset, this.rotulo, {this.verificada = false});
}

class _AnunciarPageState extends State<AnunciarPage> {
  static const _marcas = [
    'John Deere',
    'Case IH',
    'Valtra',
    'New Holland',
    'Massey Ferguson',
    'Jacto',
    'Baldan',
    'Nelore PO',
  ];

  static const _tracoes = [
    '4x4 Integral',
    '4x2',
    'Esteira',
  ];

  static const _estados = [
    'Usado - Excelente estado (Revisado em concessionária)',
    'Seminovo',
    'Usado - Bom estado',
    'Novo',
  ];

  static const _fotosExtras = [
    _FotoItem('assets/foto1.png', 'Cabine / Motor'),
    _FotoItem('assets/opp_trator.jpg', 'Implemento'),
    _FotoItem('assets/opp_nelore.jpg', 'Lote Geral'),
  ];

  late String _categoria;
  late String _marca;
  late String _tracao;
  late String _estado;
  late bool _aceitaContraproposta;
  late bool _permutaGraos;
  late bool _aptoFinanciamento;
  late bool _destaque;
  late List<_FotoItem> _fotos;
  int _extraIdx = 0;

  late final TextEditingController _modeloCtrl;
  late final TextEditingController _anoCtrl;
  late final TextEditingController _horimetroCtrl;
  late final TextEditingController _potenciaCtrl;
  late final TextEditingController _valorCtrl;
  late final TextEditingController _whatsCtrl;
  late final TextEditingController _localCtrl;

  String? _erroModelo;
  String? _erroValor;
  String? _erroLocal;
  String? _erroWhats;
  bool _enviando = false;

  bool get _modoEdicao => widget.anuncioInicial != null;

  @override
  void initState() {
    super.initState();
    final a = widget.anuncioInicial;
    _categoria = a?.categoria ?? 'Máquinas';
    _marca = _marcas.contains(a?.marca) ? a!.marca : 'John Deere';
    _tracao = _tracoes.contains(a?.tracao) ? a!.tracao : '4x4 Integral';
    _estado = _estados.contains(a?.estado)
        ? a!.estado
        : 'Usado - Excelente estado (Revisado em concessionária)';
    _aceitaContraproposta = a?.aceitaContraproposta ?? true;
    _permutaGraos = a?.permutaGraos ?? true;
    _aptoFinanciamento = a?.aptoFinanciamento ?? true;
    _destaque = a?.destaque ?? true;

    _fotos = [
      const _FotoItem('assets/anunciar_horimetro.png', 'Horímetro OK',
          verificada: true),
      const _FotoItem('assets/anunciar_frontal.png', 'Vista Frontal'),
      const _FotoItem('assets/anunciar_pneus.png', 'Pneus & Rodado'),
    ];

    _modeloCtrl = TextEditingController(text: a?.modelo ?? '8335R');
    _anoCtrl = TextEditingController(text: a?.ano ?? '2013');
    _horimetroCtrl = TextEditingController(text: a?.horimetro ?? '1.150');
    _potenciaCtrl = TextEditingController(text: a?.potencia ?? '335');
    _valorCtrl = TextEditingController(
      text: '${formatarReais(a?.valor ?? 430000)},00',
    );
    _whatsCtrl = TextEditingController(text: a?.whatsapp ?? '(17) 99821-XXXX');
    _localCtrl = TextEditingController(text: a?.local ?? 'Mirassol, SP');
  }

  @override
  void dispose() {
    _modeloCtrl.dispose();
    _anoCtrl.dispose();
    _horimetroCtrl.dispose();
    _potenciaCtrl.dispose();
    _valorCtrl.dispose();
    _whatsCtrl.dispose();
    _localCtrl.dispose();
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

  bool _validar() {
    final modelo = _modeloCtrl.text.trim();
    final valor = lerReais(_valorCtrl.text);
    final local = _localCtrl.text.trim();
    final whats = _whatsCtrl.text.trim();

    setState(() {
      _erroModelo = modelo.isEmpty ? 'Informe o modelo comercial' : null;
      _erroValor = valor == null ? 'Informe um valor válido maior que zero' : null;
      _erroLocal = local.isEmpty ? 'Informe a cidade / ponto de coleta' : null;
      _erroWhats = whats.isEmpty ? 'Informe o WhatsApp de contato' : null;
    });

    if (_erroModelo != null ||
        _erroValor != null ||
        _erroLocal != null ||
        _erroWhats != null) {
      _aviso('Preencha os campos obrigatórios antes de publicar');
      return false;
    }
    return true;
  }

  void _salvar({required StatusAnuncio status}) {
    if (_enviando) return;
    if (status == StatusAnuncio.ativo && !_validar()) return;

    final modelo = _modeloCtrl.text.trim().isEmpty
        ? 'Rascunho sem modelo'
        : _modeloCtrl.text.trim();
    final valor = lerReais(_valorCtrl.text) ?? 0;
    final local =
        _localCtrl.text.trim().isEmpty ? 'Mirassol, SP' : _localCtrl.text.trim();

    _enviando = true;
    final store = MeusAnunciosStore.instancia;
    final img = _fotos.length > 1
        ? _fotos[1].asset
        : (_fotos.isNotEmpty
            ? _fotos.first.asset
            : 'assets/anunciar_frontal.png');

    if (_modoEdicao) {
      final atualizado = widget.anuncioInicial!.copyWith(
        categoria: _categoria,
        marca: _marca,
        modelo: modelo,
        ano: _anoCtrl.text.trim().isEmpty ? '2013' : _anoCtrl.text.trim(),
        horimetro: _horimetroCtrl.text.trim().isEmpty
            ? '0'
            : _horimetroCtrl.text.trim(),
        potencia:
            _potenciaCtrl.text.trim().isEmpty ? '0' : _potenciaCtrl.text.trim(),
        tracao: _tracao,
        estado: _estado,
        valor: valor > 0 ? valor : widget.anuncioInicial!.valor,
        whatsapp: _whatsCtrl.text.trim(),
        local: local,
        aceitaContraproposta: _aceitaContraproposta,
        permutaGraos: _permutaGraos,
        aptoFinanciamento: _aptoFinanciamento,
        destaque: _destaque,
        status: status,
        limparFixos: true,
      );
      store.atualizar(atualizado);
      _aviso('Anúncio atualizado com sucesso');
    } else {
      final novo = MeuAnuncio(
        id: store.novoId(),
        categoria: _categoria,
        marca: _marca,
        modelo: modelo,
        ano: _anoCtrl.text.trim().isEmpty ? '2013' : _anoCtrl.text.trim(),
        horimetro: _horimetroCtrl.text.trim().isEmpty
            ? '0'
            : _horimetroCtrl.text.trim(),
        potencia:
            _potenciaCtrl.text.trim().isEmpty ? '0' : _potenciaCtrl.text.trim(),
        tracao: _tracao,
        estado: _estado,
        valor: valor > 0 ? valor : 430000,
        whatsapp: _whatsCtrl.text.trim(),
        local: local,
        aceitaContraproposta: _aceitaContraproposta,
        permutaGraos: _permutaGraos,
        aptoFinanciamento: _aptoFinanciamento,
        destaque: _destaque,
        fotos: _fotos.map((f) => f.asset).toList(),
        status: status,
        diasLabel: status == StatusAnuncio.pausado ? 'rascunho salvo' : 'agora',
        imagem: img,
        etiquetaCategoria:
            _categoria == 'Máquinas' ? 'Máquinas Agrícolas' : 'Pecuária de Corte',
        rodapeFoto: 'FOB $local',
        avisoPausa: status == StatusAnuncio.pausado
            ? 'Rascunho salvo no galpão • Pronto para revisão'
            : null,
      );
      store.publicar(novo);
      _aviso(status == StatusAnuncio.pausado
          ? 'Rascunho salvo em Pausados'
          : 'Anúncio publicado com sucesso!');
    }

    if (widget.abrirPainelAoPublicar) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PainelPage(
            abaInicial: status == StatusAnuncio.pausado
                ? StatusAnuncio.pausado
                : StatusAnuncio.ativo,
          ),
        ),
      );
    } else {
      Navigator.pop(context, status);
    }
  }

  void _adicionarFoto() {
    setState(() {
      _fotos.add(_fotosExtras[_extraIdx % _fotosExtras.length]);
      _extraIdx++;
    });
    _aviso('Foto adicionada (${_fotos.length} fotos)');
  }

  void _removerFoto(int idx) {
    setState(() => _fotos.removeAt(idx));
    _aviso('Foto removida (${_fotos.length} restantes)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _cabecalho(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 435),
          child: ListView(
            key: const Key('listaAnunciar'),
            padding: const EdgeInsets.only(bottom: 28),
            children: [
              _barraProgresso(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _secaoFotos(),
                    const SizedBox(height: 16),
                    _secaoClassificacao(),
                    const SizedBox(height: 16),
                    _secaoFichaTecnica(),
                    const SizedBox(height: 16),
                    _secaoCondicoes(),
                    const SizedBox(height: 16),
                    _secaoOrigemContato(),
                    const SizedBox(height: 16),
                    _cardDestaque(),
                    const SizedBox(height: 20),
                    _acoesFinais(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // A1
  PreferredSizeWidget _cabecalho() {
    return AppBar(
      backgroundColor: AgrouColors.fundo,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 64,
      leading: IconButton(
        key: const Key('btnVoltarAnunciar'),
        icon: const Icon(Icons.arrow_back, color: AgrouColors.texto),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            _aviso('Voltando para o Início');
          }
        },
      ),
      titleSpacing: 0,
      title: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset('assets/logo_agrou.jpg',
              width: 30, height: 30, fit: BoxFit.cover),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            _modoEdicao ? 'Editar Anúncio' : 'Anunciar',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AgrouColors.texto,
            ),
          ),
        ),
      ]),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: const AssetImage('assets/avatar_user.png'),
          ),
        ),
      ],
    );
  }

  // A2
  Widget _barraProgresso() {
    return Container(
      color: const Color(0xFFF3F4FC),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(children: [
        Row(children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: AgrouColors.verdeBotao,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('2',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('Dados Técnicos & Fotos',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AgrouColors.texto)),
          ),
          const Text('Passo 2 de 3',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AgrouColors.textoSec)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: 0.66,
            minHeight: 7,
            backgroundColor: AgrouColors.lavanda,
            valueColor: const AlwaysStoppedAnimation(AgrouColors.verdeBotao),
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.check_circle_outline,
                    size: 13, color: AgrouColors.verdeBotao),
                SizedBox(width: 3),
                Flexible(
                  child: Text('1. Dados Básicos',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AgrouColors.verdeBotao)),
                ),
              ]),
            ),
            SizedBox(width: 6),
            Flexible(
              child: Text('2. Especificações',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AgrouColors.verdeBotao)),
            ),
            SizedBox(width: 6),
            Flexible(
              child: Text('3. Revisão & Contrato',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: AgrouColors.textoSec)),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _cardBranco({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Color(0x0D000000), blurRadius: 8)
          ],
        ),
        child: child,
      );

  Widget _tituloSecao(IconData icone, String texto) => Row(children: [
        Icon(icone, size: 20, color: AgrouColors.verdeBotao),
        const SizedBox(width: 8),
        Expanded(
          child: Text(texto,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AgrouColors.texto)),
        ),
      ]);

  Widget _rotulo(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(t,
            style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: AgrouColors.textoSec)),
      );

  InputDecoration _decoracaoCampo({
    String? sufixo,
    IconData? prefixo,
    String? erro,
  }) =>
      InputDecoration(
        filled: true,
        fillColor: AgrouColors.cinzaCard,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        suffixText: sufixo,
        suffixStyle:
            const TextStyle(color: AgrouColors.textoSec, fontSize: 12),
        prefixIcon: prefixo != null
            ? Icon(prefixo, size: 18, color: AgrouColors.textoSec)
            : null,
        errorText: erro,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      );

  // A3
  Widget _secaoFotos() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Expanded(
          child: Text('Fotos & Registro\nObrigatório',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  color: AgrouColors.texto)),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE1BA),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.verified_outlined, size: 15, color: Color(0xFF4A2E00)),
            SizedBox(width: 5),
            Text('AUDITORIA\nAGROU',
                style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: Color(0xFF4A2E00))),
          ]),
        ),
      ]),
      const SizedBox(height: 6),
      const Text(
        'Imagens nítidas aumentam em 70% o fechamento seguro.',
        style: TextStyle(fontSize: 13, color: AgrouColors.textoSec),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFECEFFE),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(children: [
          Icon(Icons.speed, size: 22, color: AgrouColors.verdeBotao),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Obrigatório: Foto do Horímetro/Registro',
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AgrouColors.texto)),
                SizedBox(height: 2),
                Text(
                    'Fotografe com nitidez o painel ligado para homologação do lote.',
                    style:
                        TextStyle(fontSize: 11.5, color: AgrouColors.textoSec)),
              ],
            ),
          ),
        ]),
      ),
      const SizedBox(height: 12),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _fotos.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 122,
        ),
        itemBuilder: (_, i) {
          if (i == _fotos.length) {
            return InkWell(
              key: const Key('btnAdicionarFoto'),
              borderRadius: BorderRadius.circular(8),
              onTap: _adicionarFoto,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF1FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AgrouColors.verdeClaro,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add_a_photo_outlined,
                            size: 20, color: AgrouColors.verdeEscuro),
                      ),
                      const SizedBox(height: 6),
                      const Text('Adicionar Foto',
                          style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: AgrouColors.texto)),
                      const Text('Implemento / Motor',
                          style: TextStyle(
                              fontSize: 10.5, color: AgrouColors.textoSec)),
                    ],
                  ),
                ),
              ),
            );
          }
          final foto = _fotos[i];
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(fit: StackFit.expand, children: [
              Image.asset(foto.asset, fit: BoxFit.cover),
              Positioned(
                left: 6,
                bottom: 6,
                right: 36,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: foto.verificada
                          ? AgrouColors.verdeBotao
                          : const Color(0xCC1E2433),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      foto.verificada ? '✓ ${foto.rotulo}' : foto.rotulo,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 6,
                bottom: 6,
                child: InkWell(
                  key: Key('btnRemoverFoto_$i'),
                  onTap: () => _removerFoto(i),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC62828),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline,
                        color: Colors.white, size: 15),
                  ),
                ),
              ),
            ]),
          );
        },
      ),
    ]);
  }

  // A4
  Widget _secaoClassificacao() {
    Widget tab(String valor, IconData ic) {
      final ativo = _categoria == valor;
      return Expanded(
        child: InkWell(
          key: Key('cat_$valor'),
          borderRadius: BorderRadius.circular(6),
          onTap: () => setState(() => _categoria = valor),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
            decoration: BoxDecoration(
              color: ativo ? AgrouColors.verdeBotao : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(ic,
                  size: 16, color: ativo ? Colors.white : AgrouColors.texto),
              const SizedBox(width: 6),
              Flexible(
                child: Text(valor,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: ativo ? Colors.white : AgrouColors.texto)),
              ),
            ]),
          ),
        ),
      );
    }

    return _cardBranco(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _tituloSecao(Icons.agriculture_outlined, 'Classificação do Maquinário'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFECEFFE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(children: [
            tab('Máquinas', Icons.agriculture_outlined),
            tab('Animais / Gado', Icons.pets_outlined),
          ]),
        ),
        const SizedBox(height: 14),
        _rotulo('MARCA FABRICANTE'),
        DropdownButtonFormField<String>(
          key: const Key('dropMarca'),
          initialValue: _marca,
          isExpanded: true,
          decoration: _decoracaoCampo(),
          items: [
            for (final m in _marcas)
              DropdownMenuItem(value: m, child: Text(m)),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _marca = v);
          },
        ),
        const SizedBox(height: 14),
        _rotulo('MODELO COMERCIAL'),
        TextField(
          key: const Key('campoModelo'),
          controller: _modeloCtrl,
          decoration: _decoracaoCampo(erro: _erroModelo),
        ),
      ]),
    );
  }

  // A5
  Widget _secaoFichaTecnica() {
    return _cardBranco(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _tituloSecao(Icons.tune, 'Ficha Técnica Obrigatória'),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _rotulo('ANO FABRICAÇÃO'),
              TextField(
                key: const Key('campoAno'),
                controller: _anoCtrl,
                keyboardType: TextInputType.number,
                decoration: _decoracaoCampo(),
              ),
            ]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _rotulo('HORÍMETRO (HORAS)'),
              TextField(
                key: const Key('campoHorimetro'),
                controller: _horimetroCtrl,
                keyboardType: TextInputType.number,
                decoration: _decoracaoCampo(sufixo: 'hrs'),
              ),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _rotulo('POTÊNCIA NOMINAL'),
              TextField(
                key: const Key('campoPotencia'),
                controller: _potenciaCtrl,
                keyboardType: TextInputType.number,
                decoration: _decoracaoCampo(sufixo: 'cv'),
              ),
            ]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _rotulo('TIPO DE TRAÇÃO'),
              DropdownButtonFormField<String>(
                key: const Key('dropTracao'),
                initialValue: _tracao,
                isExpanded: true,
                decoration: _decoracaoCampo(),
                items: [
                  for (final t in _tracoes)
                    DropdownMenuItem(
                        value: t,
                        child: Text(t, overflow: TextOverflow.ellipsis)),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _tracao = v);
                },
              ),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        _rotulo('ESTADO DE CONSERVAÇÃO'),
        DropdownButtonFormField<String>(
          key: const Key('dropEstado'),
          initialValue: _estado,
          isExpanded: true,
          decoration: _decoracaoCampo(),
          items: [
            for (final e in _estados)
              DropdownMenuItem(
                  value: e, child: Text(e, overflow: TextOverflow.ellipsis)),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _estado = v);
          },
        ),
      ]),
    );
  }

  // A6
  Widget _secaoCondicoes() {
    Widget opcao(
      Key key,
      String titulo,
      String sub,
      IconData icone,
      Color corIcone,
      bool valor,
      ValueChanged<bool> onChanged,
    ) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          key: key,
          borderRadius: BorderRadius.circular(8),
          onTap: () => onChanged(!valor),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF1FC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              Checkbox(
                value: valor,
                activeColor: AgrouColors.verdeBotao,
                onChanged: (v) => onChanged(v ?? false),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AgrouColors.texto)),
                    Text(sub,
                        style: const TextStyle(
                            fontSize: 11.5, color: AgrouColors.textoSec)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(icone, size: 20, color: corIcone),
            ]),
          ),
        ),
      );
    }

    return _cardBranco(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _tituloSecao(Icons.payments_outlined, 'Condições Comerciais'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3FC),
            borderRadius: BorderRadius.circular(8),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Valor à Vista / Liquidação',
                style: TextStyle(fontSize: 12, color: AgrouColors.textoSec)),
            const SizedBox(height: 4),
            Row(crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
              const Text('R\$ ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AgrouColors.verdeBotao)),
              Expanded(
                child: TextField(
                  key: const Key('campoValor'),
                  controller: _valorCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AgrouColors.texto),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    errorText: _erroValor,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 4),
            const Text('Precificação média da categoria: R\$ 420k - 450k',
                style: TextStyle(fontSize: 11, color: AgrouColors.textoSec)),
          ]),
        ),
        const SizedBox(height: 14),
        _rotulo('FLEXIBILIDADE DE NEGOCIAÇÃO'),
        opcao(
          const Key('chkContraproposta'),
          'Aceita Contraproposta',
          'Aberto a margem de desconto para pagamento imediato',
          Icons.handshake_outlined,
          AgrouColors.verdeBotao,
          _aceitaContraproposta,
          (v) => setState(() => _aceitaContraproposta = v),
        ),
        opcao(
          const Key('chkPermuta'),
          'Permuta por Grãos (Barter Safra)',
          'Equivalência em sacas de Soja / Milho na colheita',
          Icons.grain,
          AgrouColors.verdeBotao,
          _permutaGraos,
          (v) => setState(() => _permutaGraos = v),
        ),
        opcao(
          const Key('chkFinanciamento'),
          'Apto para Financiamento Bancário',
          'Documentação desimpedida para Plano Safra / Moderfrota',
          Icons.account_balance_outlined,
          const Color(0xFF8C5A00),
          _aptoFinanciamento,
          (v) => setState(() => _aptoFinanciamento = v),
        ),
      ]),
    );
  }

  // A7
  Widget _secaoOrigemContato() {
    return _cardBranco(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _tituloSecao(
            Icons.location_on_outlined, 'Origem e Contato Certificado'),
        const SizedBox(height: 12),
        _rotulo('CANAL DIRETO (WHATSAPP)'),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: TextField(
              key: const Key('campoWhatsapp'),
              controller: _whatsCtrl,
              keyboardType: TextInputType.phone,
              decoration: _decoracaoCampo(
                  prefixo: Icons.chat_outlined, erro: _erroWhats),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AgrouColors.verdeClaro,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.verified_outlined,
                  size: 15, color: AgrouColors.verdeEscuro),
              SizedBox(width: 4),
              Text('SMS Validado',
                  style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AgrouColors.verdeEscuro)),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        _rotulo('PONTO DE COLETA / INSPEÇÃO'),
        TextField(
          key: const Key('campoLocal'),
          controller: _localCtrl,
          decoration: _decoracaoCampo(
              prefixo: Icons.location_on_outlined, erro: _erroLocal),
        ),
        const SizedBox(height: 6),
        const Text(
          'Hub logístico próximo a rodovias estaduais (FOB Disponível).',
          style: TextStyle(fontSize: 11, color: AgrouColors.textoSec),
        ),
      ]),
    );
  }

  // A8
  Widget _cardDestaque() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3E9FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF8A5900),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.workspace_premium_outlined,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text('Destaque Topo\nAgro',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    color: AgrouColors.texto)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFDBA8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('5x Mais\nVistas',
                style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: Color(0xFF4A2E00))),
          ),
        ]),
        const SizedBox(height: 10),
        const Text(
          'Fixe seu trator no topo da busca estadual por 30 dias com selo de lote inspecionado.',
          style: TextStyle(fontSize: 12.5, color: AgrouColors.textoSec),
        ),
        const SizedBox(height: 10),
        Row(children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Taxa única',
                    style:
                        TextStyle(fontSize: 11, color: AgrouColors.textoSec)),
                Text('R\$ 49,90',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF7A4E00))),
              ],
            ),
          ),
          Switch(
            key: const Key('switchDestaque'),
            value: _destaque,
            activeTrackColor: AgrouColors.verdeBotao,
            activeThumbColor: Colors.white,
            onChanged: (v) => setState(() => _destaque = v),
          ),
        ]),
      ]),
    );
  }

  // A9
  Widget _acoesFinais() {
    return Column(children: [
      SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton.icon(
          key: const Key('btnPublicarAnuncio'),
          onPressed: () => _salvar(status: StatusAnuncio.ativo),
          style: FilledButton.styleFrom(
            backgroundColor: AgrouColors.verdeBotao,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          icon: const Icon(Icons.rocket_launch_outlined),
          label: Text(
            _modoEdicao ? 'Salvar Alterações' : 'Publicar Anúncio Agora',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: double.infinity,
        height: 46,
        child: FilledButton.tonalIcon(
          key: const Key('btnSalvarRascunho'),
          onPressed: () => _salvar(status: StatusAnuncio.pausado),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFE7ECFC),
            foregroundColor: AgrouColors.texto,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          icon: const Icon(Icons.save_outlined, size: 18),
          label: const Text(
            'Salvar Rascunho & Continuar no Galpão',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      const SizedBox(height: 14),
      const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.verified_user, size: 14, color: AgrouColors.verdeBotao),
        SizedBox(width: 6),
        Flexible(
          child: Text('Transação Segura & Custódia Contratual Agrou Brasil',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: AgrouColors.textoSec)),
        ),
      ]),
    ]);
  }
}
