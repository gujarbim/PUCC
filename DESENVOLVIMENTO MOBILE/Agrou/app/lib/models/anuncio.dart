import 'package:flutter/material.dart';

class ItemFicha {
  final IconData icone;
  final String rotulo;
  final String valor;
  final String sub;
  final bool subVerde;

  const ItemFicha({
    required this.icone,
    required this.rotulo,
    required this.valor,
    required this.sub,
    this.subVerde = false,
  });
}

class SetorInfo {
  final String id;
  final String titulo;
  final String subtitulo;
  final String imagem;
  final IconData icone;

  const SetorInfo({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.imagem,
    required this.icone,
  });
}

class Anuncio {
  final String id;
  final String codigo;
  final String setor;
  final String categoriaCard;
  final String tituloCard;
  final String tituloDetalhe;
  final String cidadeUf;
  final String regiaoFiltro;
  final String localDetalhe;
  final String precoLabel;
  final String preco;
  final String imagemCard;
  final String badgeFotoTopo;
  final Color badgeFotoTopoCor;
  final bool badgeTopoEstrela;
  final String badgeFotoBase;
  final String spec1Rotulo;
  final String spec1Valor;
  final String spec2Rotulo;
  final String spec2Valor;
  final List<String> modalidades;
  final List<String> fotosDetalhe;
  final List<String> etiquetas;
  final String permutaSub;
  final String vendedorNome;
  final String vendedorFazenda;
  final String vendedorDesde;
  final String vendedorNota;
  final String vendedorVendas;
  final List<ItemFicha> ficha;
  final String historicoTitulo;
  final String historicoDescricao;
  final List<String> historicoObs;
  final String freteEstimado;
  final String freteSubtitulo;

  const Anuncio({
    required this.id,
    required this.codigo,
    required this.setor,
    required this.categoriaCard,
    required this.tituloCard,
    required this.tituloDetalhe,
    required this.cidadeUf,
    required this.regiaoFiltro,
    required this.localDetalhe,
    required this.precoLabel,
    required this.preco,
    required this.imagemCard,
    required this.badgeFotoTopo,
    this.badgeFotoTopoCor = const Color(0xFF006B2C),
    this.badgeTopoEstrela = false,
    required this.badgeFotoBase,
    required this.spec1Rotulo,
    required this.spec1Valor,
    required this.spec2Rotulo,
    required this.spec2Valor,
    required this.modalidades,
    required this.fotosDetalhe,
    required this.etiquetas,
    required this.permutaSub,
    required this.vendedorNome,
    required this.vendedorFazenda,
    required this.vendedorDesde,
    required this.vendedorNota,
    required this.vendedorVendas,
    required this.ficha,
    required this.historicoTitulo,
    required this.historicoDescricao,
    required this.historicoObs,
    required this.freteEstimado,
    required this.freteSubtitulo,
  });
}

const List<SetorInfo> setoresPrincipais = [
  SetorInfo(
    id: 'Tratores & Máquinas',
    titulo: 'Tratores & Máquinas',
    subtitulo: 'John Deere, Case, Valtra',
    imagem: 'assets/setor_maquinas.jpg',
    icone: Icons.agriculture_outlined,
  ),
  SetorInfo(
    id: 'Gado & Animais',
    titulo: 'Gado & Animais',
    subtitulo: 'Nelore PO, Cruzamento, Bezerras',
    imagem: 'assets/setor_gado.jpg',
    icone: Icons.pets_outlined,
  ),
  SetorInfo(
    id: 'Insumos & Sementes',
    titulo: 'Insumos & Sementes',
    subtitulo: 'Adubo, Defensivos, Soja/Milho',
    imagem: 'assets/setor_insumos.jpg',
    icone: Icons.eco_outlined,
  ),
  SetorInfo(
    id: 'Veículos & Carga',
    titulo: 'Veículos & Carga',
    subtitulo: 'Camionetes, Bitrens, Carretas',
    imagem: 'assets/setor_veiculos.jpg',
    icone: Icons.local_shipping_outlined,
  ),
];

const List<Anuncio> anunciosIniciais = [
  Anuncio(
    id: 'agr-4501',
    codigo: '#AGR-4501',
    setor: 'Gado & Animais',
    categoriaCard: 'PECUÁRIA DE CORTE',
    tituloCard: 'Lote 45 Novilhas Nelore PO Registradas',
    tituloDetalhe: 'Lote 45 Novilhas Nelore PO Registradas',
    cidadeUf: 'Uberaba, MG',
    regiaoFiltro: 'Minas Gerais',
    localDetalhe: 'Uberaba, MG • Fazenda Santa Clara c/ embarcador',
    precoLabel: 'Valor Total do Lote',
    preco: '148.000',
    imagemCard: 'assets/opp_nelore.jpg',
    badgeFotoTopo: 'Produtor Auditado',
    badgeFotoTopoCor: Color(0xFF006B2C),
    badgeFotoBase: '45 Cabeças',
    spec1Rotulo: 'Peso Médio:',
    spec1Valor: '320 kg / 10.7 @',
    spec2Rotulo: 'Idade & Status:',
    spec2Valor: '18 Meses (Vacinadas)',
    modalidades: ['Compra Direta'],
    fotosDetalhe: [
      'assets/opp_nelore.jpg',
      'assets/setor_gado.jpg',
      'assets/opp_nelore.jpg',
    ],
    etiquetas: [
      'Gado & Animais',
      'Registro ABCZ (RGD)',
      'Produtor Verificado (CPF/CNPJ)',
    ],
    permutaSub: 'Arroba do Boi / Milho',
    vendedorNome: 'Fazenda Santa Clara',
    vendedorFazenda: 'Haras & Pecuária • Uberaba/MG',
    vendedorDesde: 'Produtor cadastrado desde 2020',
    vendedorNota: '4.8',
    vendedorVendas: '(19 vendas\nconcluídas)',
    ficha: [
      ItemFicha(
        icone: Icons.pets_outlined,
        rotulo: 'QUANTIDADE',
        valor: '45 Cabeças',
        sub: 'Lote fechado uniforme',
        subVerde: true,
      ),
      ItemFicha(
        icone: Icons.calendar_month_outlined,
        rotulo: 'IDADE MÉDIA',
        valor: '18 Meses',
        sub: 'Novilhas p/ cria/recria',
      ),
      ItemFicha(
        icone: Icons.monitor_weight_outlined,
        rotulo: 'PESO MÉDIO',
        valor: '320 kg / 10.7 @',
        sub: 'Pesagem em balança digital',
      ),
      ItemFicha(
        icone: Icons.verified_outlined,
        rotulo: 'REGISTRO',
        valor: 'Nelore PO (RGD)',
        sub: 'Certificado ABCZ ativo',
        subVerde: true,
      ),
      ItemFicha(
        icone: Icons.vaccines_outlined,
        rotulo: 'SANIDADE',
        valor: 'Protocolo em dia',
        sub: 'Aftosa, Raiva, Brucelose',
      ),
      ItemFicha(
        icone: Icons.grass_outlined,
        rotulo: 'ALIMENTAÇÃO',
        valor: 'A pasto + mineral',
        sub: 'Braquiária + suplemento',
        subVerde: true,
      ),
      ItemFicha(
        icone: Icons.receipt_long_outlined,
        rotulo: 'DOCUMENTAÇÃO & EMBARQUE',
        valor: 'GTA Eletrônica + Exames Negativos (Tuberculose/Brucelose)',
        sub: 'Liberação imediata após fechamento em conta Agrou Safe',
      ),
    ],
    historicoTitulo: 'Manejo Sanitário Certificado (10/2026)',
    historicoDescricao:
        'Rebanho acompanhado por médico veterinário credenciado ao IMA-MG, com controle zootécnico completo e vacinação comprovada.',
    historicoObs: [
      'Lote homogêneo selecionado para reprodução e matrizes de alto ganho de peso.',
      'Curral com tronco e balança eletrônica disponíveis para conferência presencial.',
      'Documentação GTA e emissão de nota fiscal do produtor prontas no ato.',
    ],
    freteEstimado: 'R\$ 2.400',
    freteSubtitulo: 'Cotação p/ Gaiola Boiadeira',
  ),
  Anuncio(
    id: 'agr-8335',
    codigo: '#AGR-8335',
    setor: 'Tratores & Máquinas',
    categoriaCard: 'TRATORES AGRÍCOLAS',
    tituloCard: 'Trator John Deere 8335R (335 cv) Cabinado',
    tituloDetalhe: 'Trator John Deere 8335R',
    cidadeUf: 'Mirassol, SP',
    regiaoFiltro: 'Mato Grosso & SP',
    localDetalhe: 'Mirassol, SP • Disponível para vistoria física na fazenda',
    precoLabel: 'Preço à Vista',
    preco: '430.000',
    imagemCard: 'assets/opp_trator.jpg',
    badgeFotoTopo: 'Laudo Mecânico OK',
    badgeFotoTopoCor: Color(0xFF006B2C),
    badgeFotoBase: 'Ano 2013 • 335 cv',
    spec1Rotulo: 'Horímetro:',
    spec1Valor: '1.150 horas originais',
    spec2Rotulo: 'Transmissão:',
    spec2Valor: 'AutoPowr IVT • Duplado',
    modalidades: ['Compra Direta', 'Barter & Permuta'],
    fotosDetalhe: [
      'assets/foto1.png',
      'assets/thumb2.png',
      'assets/thumb3.png',
      'assets/thumb4.png',
      'assets/thumb5.png',
      'assets/thumb3.png',
    ],
    etiquetas: [
      'Tratores & Máquinas',
      'Usado Revisado',
      'Produtor Verificado (CPF/CNPJ)',
    ],
    permutaSub: 'Gado ou Soja Futura',
    vendedorNome: 'Antônio Novaes',
    vendedorFazenda: 'Fazenda Santa Fé • Mirassol/SP',
    vendedorDesde: 'Produtor cadastrado desde 2021',
    vendedorNota: '4.9',
    vendedorVendas: '(28 vendas\nconcluídas)',
    ficha: [
      ItemFicha(
        icone: Icons.speed,
        rotulo: 'HORÍMETRO',
        valor: '1.150 horas',
        sub: 'Baixa rodagem p/ ano',
        subVerde: true,
      ),
      ItemFicha(
        icone: Icons.calendar_month_outlined,
        rotulo: 'ANO / MODELO',
        valor: '2012 / 2013',
        sub: 'Nacional montado',
      ),
      ItemFicha(
        icone: Icons.bolt,
        rotulo: 'POTÊNCIA NOMINAL',
        valor: '335 cv (9.0L)',
        sub: '6 Cilindros Turbo',
      ),
      ItemFicha(
        icone: Icons.settings_outlined,
        rotulo: 'CÂMBIO',
        valor: 'PowerShift™ 16x5',
        sub: 'Calibragem 100%',
        subVerde: true,
      ),
      ItemFicha(
        icone: Icons.satellite_alt_outlined,
        rotulo: 'PILOTO AUTOMÁTICO',
        valor: 'Pré-disposto + ATI',
        sub: 'Compatível StarFire',
      ),
      ItemFicha(
        icone: Icons.tire_repair_outlined,
        rotulo: 'RODADOS & PNEUS',
        valor: 'Radiais 800 Michelin',
        sub: '80% de vida útil',
        subVerde: true,
      ),
      ItemFicha(
        icone: Icons.plumbing,
        rotulo: 'HIDRÁULICO & VÁLVULAS',
        valor: 'Barramento Hidráulico + TDP + 4 VCRs de Alto Fluxo',
        sub: 'Bomba hidráulica de 227 L/min com acoplamento rápido',
      ),
    ],
    historicoTitulo: 'Motor e Transmissão Novos (08/2024)',
    historicoDescricao:
        'Retífica completa executada rigorosamente na concessionária autorizada John Deere com peças originais e nota fiscal comprovatória anexada.',
    historicoObs: [
      'Trator trabalhou unicamente em lavoura de grãos de safra e safrinha.',
      'Armazenado sempre em barracão coberto, sem exposição contínua a intempéries.',
      'Documentação rigorosamente limpa, pronto para transferência ou financiamento bancário (Pronaf/Moderfrota).',
    ],
    freteEstimado: 'R\$ 4.800',
    freteSubtitulo: 'Cotação p/ Prancha Pesada',
  ),
  Anuncio(
    id: 'agr-9060',
    codigo: '#AGR-9060',
    setor: 'Tratores & Máquinas',
    categoriaCard: 'COLHEITADEIRAS DE GRÃOS',
    tituloCard: 'Colheitadeira New Holland CR 9060',
    tituloDetalhe: 'Colheitadeira New Holland CR 9060',
    cidadeUf: 'Rio Verde, GO',
    regiaoFiltro: 'Goiás',
    localDetalhe: 'Rio Verde, GO • Disponível para vistoria técnica na fazenda',
    precoLabel: 'Valor Negociável',
    preco: '890.000',
    imagemCard: 'assets/opp_colheitadeira.jpg',
    badgeFotoTopo: 'Rotor Duplo Especial',
    badgeFotoTopoCor: Color(0xFFB26A00),
    badgeTopoEstrela: true,
    badgeFotoBase: 'Ano 2018 • Drapper 35ft',
    spec1Rotulo: 'Horas de Motor/Trilha:',
    spec1Valor: '2.400h / 1.780h',
    spec2Rotulo: 'Plataforma:',
    spec2Valor: '35 Pés Drapper Flex',
    modalidades: ['Compra Direta', 'Barter & Permuta'],
    fotosDetalhe: [
      'assets/opp_colheitadeira.jpg',
      'assets/setor_maquinas.jpg',
      'assets/opp_colheitadeira.jpg',
    ],
    etiquetas: [
      'Tratores & Máquinas',
      'Revisada Safra 2026',
      'Produtor Verificado (CPF/CNPJ)',
    ],
    permutaSub: 'Soja em Sacas / Milho',
    vendedorNome: 'Agropecuária Cerrado Verde',
    vendedorFazenda: 'Fazenda Boa Vista • Rio Verde/GO',
    vendedorDesde: 'Produtor cadastrado desde 2019',
    vendedorNota: '4.9',
    vendedorVendas: '(34 vendas\nconcluídas)',
    ficha: [
      ItemFicha(
        icone: Icons.speed,
        rotulo: 'MOTOR / TRILHA',
        valor: '2.400h / 1.780h',
        sub: 'Horímetro auditado',
        subVerde: true,
      ),
      ItemFicha(
        icone: Icons.calendar_month_outlined,
        rotulo: 'ANO / MODELO',
        valor: '2018 / 2018',
        sub: 'Único proprietário',
      ),
      ItemFicha(
        icone: Icons.agriculture_outlined,
        rotulo: 'PLATAFORMA',
        valor: '35 Pés Drapper',
        sub: 'Esteira revisada',
      ),
      ItemFicha(
        icone: Icons.settings_outlined,
        rotulo: 'SISTEMA DE TRILHA',
        valor: 'Twin Rotor™',
        sub: 'Rotores balanceados',
        subVerde: true,
      ),
      ItemFicha(
        icone: Icons.satellite_alt_outlined,
        rotulo: 'TELEMETRIA & GPS',
        valor: 'IntelliSteer Completo',
        sub: 'Monitor IntelliView IV',
      ),
      ItemFicha(
        icone: Icons.tire_repair_outlined,
        rotulo: 'RODADO DIANTEIRO',
        valor: 'Duplado Radial',
        sub: '75% de vida útil',
        subVerde: true,
      ),
      ItemFicha(
        icone: Icons.plumbing,
        rotulo: 'TANQUE GRANELEIRO & DESCARGA',
        valor: '11.500 Litros com Tubo de Descarga Rápida (126 L/s)',
        sub: 'Inclui carretinha de transporte para plataforma de 35 pés',
      ),
    ],
    historicoTitulo: 'Revisão Preventiva Pós-Colheita (05/2026)',
    historicoDescricao:
        'Troca de correntes do elevador, correias originais CNH e revisão do sistema hidráulico com notas fiscais anexadas.',
    historicoObs: [
      'Colheu apenas soja e milho em áreas planas do sudoeste goiano.',
      'Acompanha plataforma Drapper 35 pés e carretinha rodoviária.',
      'Nota fiscal de origem validada, sem alienação fiduciária.',
    ],
    freteEstimado: 'R\$ 7.900',
    freteSubtitulo: 'Cotação p/ Prancha Extensiva',
  ),
  Anuncio(
    id: 'agr-3030',
    codigo: '#AGR-3030',
    setor: 'Tratores & Máquinas',
    categoriaCard: 'PULVERIZADORES',
    tituloCard: 'Pulverizador Jacto Uniport 3030 Plus',
    tituloDetalhe: 'Pulverizador Jacto Uniport 3030 Plus',
    cidadeUf: 'Sorriso, MT',
    regiaoFiltro: 'Mato Grosso & SP',
    localDetalhe: 'Sorriso, MT • Disponível para vistoria na fazenda',
    precoLabel: 'Valor Especial',
    preco: '620.000',
    imagemCard: 'assets/opp_pulverizador.jpg',
    badgeFotoTopo: 'Único Dono',
    badgeFotoTopoCor: Color(0xFF006B2C),
    badgeFotoBase: 'Barras 32m • GPS Integrado',
    spec1Rotulo: 'Capacidade Tanque:',
    spec1Valor: '3.000 Litros',
    spec2Rotulo: 'Barra de Pulverização:',
    spec2Valor: '32 Metros Corte Seção',
    modalidades: ['Compra Direta'],
    fotosDetalhe: [
      'assets/opp_pulverizador.jpg',
      'assets/setor_maquinas.jpg',
      'assets/opp_pulverizador.jpg',
    ],
    etiquetas: [
      'Tratores & Máquinas',
      'Único Dono',
      'Produtor Verificado (CPF/CNPJ)',
    ],
    permutaSub: 'À vista / Financiamento',
    vendedorNome: 'Grupo Norte Sul Agrícola',
    vendedorFazenda: 'Fazenda Horizonte • Sorriso/MT',
    vendedorDesde: 'Produtor cadastrado desde 2022',
    vendedorNota: '4.9',
    vendedorVendas: '(15 vendas\nconcluídas)',
    ficha: [
      ItemFicha(
        icone: Icons.water_drop_outlined,
        rotulo: 'TANQUE DE CALDA',
        valor: '3.000 Litros',
        sub: 'Polietileno + agitador',
        subVerde: true,
      ),
      ItemFicha(
        icone: Icons.straighten,
        rotulo: 'BARRAS',
        valor: '32 Metros',
        sub: 'Corte bico a bico',
      ),
      ItemFicha(
        icone: Icons.bolt,
        rotulo: 'MOTORIZAÇÃO',
        valor: 'Cummins 243 cv',
        sub: 'Transmissão 4x4 hidrostática',
      ),
      ItemFicha(
        icone: Icons.speed,
        rotulo: 'HORÍMETRO',
        valor: '1.920 horas',
        sub: 'Manutenção autorizada',
        subVerde: true,
      ),
      ItemFicha(
        icone: Icons.satellite_alt_outlined,
        rotulo: 'TECNOLOGIA EMBARCADA',
        valor: 'Otmis Piloto + GPS',
        sub: 'Desligamento automático',
      ),
      ItemFicha(
        icone: Icons.height,
        rotulo: 'VÃO LIVRE',
        valor: '1,75 Metro',
        sub: 'Bitola regulável hidráulica',
        subVerde: true,
      ),
      ItemFicha(
        icone: Icons.plumbing,
        rotulo: 'BOMBA DE PULVERIZAÇÃO & ABASTECIMENTO',
        valor: 'Jacto JP 300 (300 L/min) + Incorporador de Defensivos',
        sub: 'Calibração eletrônica de vazão testada em bancada',
      ),
    ],
    historicoTitulo: 'Revisão de Barras e Bicos (09/2026)',
    historicoDescricao:
        'Conjunto de pontas cerâmicas e vedações dos cilindros de barra substituídos em concessionária Jacto.',
    historicoObs: [
      'Equipamento único dono, sempre operado pelo mesmo operador treinado.',
      'Cabine climatizada com filtro de carvão ativado novo.',
      'Pronto para trabalhar imediatamente na safra de soja.',
    ],
    freteEstimado: 'R\$ 5.600',
    freteSubtitulo: 'Cotação p/ Prancha Média',
  ),
];

final Anuncio anuncioPadrao = anunciosIniciais[1];
