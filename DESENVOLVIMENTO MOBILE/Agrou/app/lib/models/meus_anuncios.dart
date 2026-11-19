import 'package:flutter/foundation.dart';

enum StatusAnuncio { ativo, pausado, vendido }

class MeuAnuncio {
  final String id;
  final String categoria; // 'Máquinas' ou 'Animais / Gado'
  final String marca;
  final String modelo;
  final String ano;
  final String horimetro;
  final String potencia;
  final String tracao;
  final String estado;
  final int valor; // em reais
  final String whatsapp;
  final String local;
  final bool aceitaContraproposta;
  final bool permutaGraos;
  final bool aptoFinanciamento;
  final bool destaque;
  final List<String> fotos;
  final StatusAnuncio status;
  final String diasLabel;
  final String imagem;
  final String etiquetaCategoria;
  final String rodapeFoto;
  final String precoLabel;
  final String? tituloFixo;
  final String? subtituloFixo;
  final int visualizacoes;
  final int contatos;
  final bool mostrarTurbinar;
  final bool mostrarExcluir;
  final String? avisoPausa;

  const MeuAnuncio({
    required this.id,
    this.categoria = 'Máquinas',
    this.marca = 'John Deere',
    this.modelo = '8335R',
    this.ano = '2013',
    this.horimetro = '1.150',
    this.potencia = '335',
    this.tracao = '4x4 Integral',
    this.estado = 'Usado - Excelente estado (Revisado em concessionária)',
    this.valor = 430000,
    this.whatsapp = '(17) 99821-XXXX',
    this.local = 'Mirassol, SP',
    this.aceitaContraproposta = true,
    this.permutaGraos = true,
    this.aptoFinanciamento = true,
    this.destaque = true,
    this.fotos = const [
      'assets/anunciar_horimetro.png',
      'assets/anunciar_frontal.png',
      'assets/anunciar_pneus.png',
    ],
    this.status = StatusAnuncio.ativo,
    this.diasLabel = 'agora',
    this.imagem = 'assets/anunciar_frontal.png',
    this.etiquetaCategoria = 'Máquinas Agrícolas',
    this.rodapeFoto = 'FOB Mirassol, SP',
    this.precoLabel = 'Valor à vista',
    this.tituloFixo,
    this.subtituloFixo,
    this.visualizacoes = 0,
    this.contatos = 0,
    this.mostrarTurbinar = false,
    this.mostrarExcluir = true,
    this.avisoPausa,
  });

  String get titulo =>
      tituloFixo ??
      (categoria == 'Máquinas' ? 'Trator $marca $modelo' : 'Lote $modelo');

  String get subtitulo =>
      subtituloFixo ?? 'Ano $ano • ${horimetro}h trabalhadas • $tracao';

  String get precoFormatado => formatarReais(valor);

  MeuAnuncio copyWith({
    String? categoria,
    String? marca,
    String? modelo,
    String? ano,
    String? horimetro,
    String? potencia,
    String? tracao,
    String? estado,
    int? valor,
    String? whatsapp,
    String? local,
    bool? aceitaContraproposta,
    bool? permutaGraos,
    bool? aptoFinanciamento,
    bool? destaque,
    List<String>? fotos,
    StatusAnuncio? status,
    String? diasLabel,
    String? imagem,
    String? etiquetaCategoria,
    String? rodapeFoto,
    String? avisoPausa,
    bool limparFixos = false,
  }) {
    final novaCat = categoria ?? this.categoria;
    final novoLocal = local ?? this.local;
    return MeuAnuncio(
      id: id,
      categoria: novaCat,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      ano: ano ?? this.ano,
      horimetro: horimetro ?? this.horimetro,
      potencia: potencia ?? this.potencia,
      tracao: tracao ?? this.tracao,
      estado: estado ?? this.estado,
      valor: valor ?? this.valor,
      whatsapp: whatsapp ?? this.whatsapp,
      local: novoLocal,
      aceitaContraproposta: aceitaContraproposta ?? this.aceitaContraproposta,
      permutaGraos: permutaGraos ?? this.permutaGraos,
      aptoFinanciamento: aptoFinanciamento ?? this.aptoFinanciamento,
      destaque: destaque ?? this.destaque,
      fotos: fotos ?? this.fotos,
      status: status ?? this.status,
      diasLabel: diasLabel ?? this.diasLabel,
      imagem: imagem ?? this.imagem,
      etiquetaCategoria: etiquetaCategoria ??
          (novaCat == 'Máquinas' ? 'Máquinas Agrícolas' : 'Pecuária de Corte'),
      rodapeFoto: rodapeFoto ?? 'FOB $novoLocal',
      precoLabel: precoLabel,
      tituloFixo: limparFixos ? null : tituloFixo,
      subtituloFixo: limparFixos ? null : subtituloFixo,
      visualizacoes: visualizacoes,
      contatos: contatos,
      mostrarTurbinar: mostrarTurbinar,
      mostrarExcluir: mostrarExcluir,
      avisoPausa: avisoPausa ?? this.avisoPausa,
    );
  }
}

String formatarReais(int v) {
  final s = v.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

/// Converte "430.000,00" / "430000" em 430000. Retorna null se vazio ou <= 0.
int? lerReais(String texto) {
  final limpo = texto.trim();
  if (limpo.isEmpty) return null;
  final inteiro = limpo.split(',').first.replaceAll(RegExp(r'[^0-9]'), '');
  if (inteiro.isEmpty) return null;
  final v = int.tryParse(inteiro);
  if (v == null || v <= 0) return null;
  return v;
}

class MeusAnunciosStore extends ChangeNotifier {
  MeusAnunciosStore._() {
    reiniciar();
  }

  static final MeusAnunciosStore instancia = MeusAnunciosStore._();

  final List<MeuAnuncio> _itens = [];
  int _vendidosAnteriores = 4;
  int _seq = 0;

  List<MeuAnuncio> get itens => List.unmodifiable(_itens);

  List<MeuAnuncio> porStatus(StatusAnuncio s) =>
      _itens.where((a) => a.status == s).toList();

  int contar(StatusAnuncio s) =>
      _itens.where((a) => a.status == s).length +
      (s == StatusAnuncio.vendido ? _vendidosAnteriores : 0);

  void reiniciar() {
    _seq = 0;
    _vendidosAnteriores = 4;
    _itens
      ..clear()
      ..addAll(const [
        MeuAnuncio(
          id: 'jd8335r',
          tituloFixo: 'Trator John Deere 8335R',
          subtituloFixo:
              'Ano 2021 • 3.200h trabalhadas • Piloto Automático AutoTrac',
          marca: 'John Deere',
          modelo: '8335R',
          ano: '2021',
          horimetro: '3.200',
          potencia: '335',
          valor: 430000,
          diasLabel: 'há 5 dias',
          imagem: 'assets/painel_trator.png',
          etiquetaCategoria: 'Máquinas Agrícolas',
          rodapeFoto: 'FOB Mirassol, SP',
          precoLabel: 'Valor à vista',
          visualizacoes: 840,
          contatos: 26,
          mostrarTurbinar: true,
          mostrarExcluir: false,
        ),
        MeuAnuncio(
          id: 'nelore60',
          categoria: 'Animais / Gado',
          marca: 'Nelore PO',
          modelo: '60 Bezerras Nelore Desmama',
          tituloFixo: 'Lote 60 Bezerras Nelore Desmama',
          subtituloFixo:
              'Vacinação em dia • Rastreabilidade SISBOV • Genética PO',
          valor: 162000,
          diasLabel: 'há 12 dias',
          imagem: 'assets/painel_nelore.png',
          etiquetaCategoria: 'Pecuária de Corte',
          rodapeFoto: 'Média: 210 kg / cab.',
          precoLabel: 'Lote fechado',
          visualizacoes: 410,
          contatos: 18,
          mostrarTurbinar: false,
          mostrarExcluir: true,
        ),
        MeuAnuncio(
          id: 'jacto3030',
          marca: 'Jacto',
          modelo: 'Uniport 3030 Plus',
          tituloFixo: 'Pulverizador Jacto Uniport 3030 Plus',
          subtituloFixo: 'Tanque 3.000 L • Barras 32 m • GPS integrado',
          ano: '2022',
          horimetro: '980',
          potencia: '243',
          valor: 620000,
          local: 'Sorriso, MT',
          diasLabel: 'há 20 dias',
          imagem: 'assets/opp_pulverizador.jpg',
          etiquetaCategoria: 'Máquinas Agrícolas',
          rodapeFoto: 'FOB Sorriso, MT',
          precoLabel: 'Valor à vista',
          visualizacoes: 170,
          contatos: 4,
          mostrarTurbinar: false,
          mostrarExcluir: true,
        ),
        MeuAnuncio(
          id: 'baldan28',
          marca: 'Baldan',
          modelo: 'Grade 28 Discos',
          tituloFixo: 'Grade Aradora Baldan 28 Discos',
          subtituloFixo: 'Mancais a óleo reforçados • Discos 28" em ótimo estado',
          ano: '2019',
          horimetro: '600',
          valor: 65000,
          local: 'Barretos, SP',
          status: StatusAnuncio.pausado,
          diasLabel: 'Negociação em Barretos',
          imagem: 'assets/painel_grade.png',
          etiquetaCategoria: 'Implementos',
          rodapeFoto: 'FOB Barretos, SP',
          precoLabel: 'Proposta atual',
          mostrarTurbinar: false,
          mostrarExcluir: true,
          avisoPausa:
              'Comprador reservou via WhatsApp • Aguardando sinal de frete',
        ),
      ]);
    notifyListeners();
  }

  String novoId() => 'novo_${++_seq}';

  void publicar(MeuAnuncio a) {
    _itens.insert(0, a);
    notifyListeners();
  }

  void atualizar(MeuAnuncio a) {
    final i = _itens.indexWhere((x) => x.id == a.id);
    if (i >= 0) {
      _itens[i] = a;
      notifyListeners();
    }
  }

  void mudarStatus(String id, StatusAnuncio s) {
    final i = _itens.indexWhere((x) => x.id == id);
    if (i < 0) return;
    _itens[i] = _itens[i].copyWith(
      status: s,
      diasLabel: s == StatusAnuncio.ativo
          ? 'reativado agora'
          : (s == StatusAnuncio.pausado ? 'pausado agora' : 'vendido agora'),
    );
    notifyListeners();
  }

  void excluir(String id) {
    _itens.removeWhere((x) => x.id == id);
    notifyListeners();
  }
}
