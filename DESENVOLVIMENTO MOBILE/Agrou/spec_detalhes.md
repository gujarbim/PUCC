# Especificação – Tela "Detalhes do Lote" (Must M2)

Must M2: ver os detalhes técnicos de um anúncio e negociar com o vendedor pelo WhatsApp.

---

## Versão 1 – escrita pela IA (a partir do print do Figma em miniatura)

**Objetivo:** mostrar os detalhes de um trator à venda e permitir contato com o vendedor.

**Elementos**
1. AppBar com seta de voltar e título "Detalhes do Lote".
2. Foto grande do trator.
3. Título "Trator John Deere 8335R" e localização "Mirassol, SP".
4. Preço "R$ 430.000".
5. Card do vendedor com nome e avaliação.
6. Ficha técnica com Horímetro, Ano, Potência e Câmbio.
7. Histórico de manutenção.
8. Simulação de frete com botão "Calcular CEP".
9. Botão "Negociar no WhatsApp" no final da página.

**Critérios de aceitação**
- A tela mostra todas as informações do anúncio.
- O botão do WhatsApp funciona.
- O layout fica bonito no celular.

---

## Versão 2 – corrigida pelo grupo (comparando com o Figma em tamanho real)

**Objetivo:** o comprador confere as fotos e a ficha técnica do lote e abre a conversa com o vendedor no WhatsApp sem sair do fluxo.

### Estrutura (de cima para baixo)
| # | Elemento | Conteúdo exato |
|---|----------|----------------|
| E1 | Cabeçalho fixo | Seta voltar · logo "Agrou" · título **"Detalhes Do Lote"** · avatar do usuário à direita |
| E2 | Galeria | Foto 390×292, contador **"1/6"** no canto superior esquerdo, botões **favoritar** e **compartilhar** no canto superior direito, setas **‹ ›** nas laterais |
| E3 | Miniaturas | 5 miniaturas abaixo da foto; a selecionada fica destacada |
| E4 | Etiquetas | "Tratores & Máquinas" (azul), "Usado Revisado" (verde), "Produtor Verificado (CPF/CNPJ)" (laranja) |
| E5 | Título e local | **"Trator John Deere 8335R"** · "Mirassol, SP • Disponível para vistoria física na fazenda" |
| E6 | Card de preço | "VALOR À VISTA NEGOCIÁVEL" · **"R$ 430.000"** em verde · etiqueta "Permuta – Gado ou Soja Futura" · aviso "Garantia Agrou Safe…" |
| E7 | Card do vendedor | Foto, "Antônio Novaes" com selo, "Fazenda Santa Fé • Mirassol/SP", "Produtor cadastrado desde 2021", nota **★ 4.9 (28 vendas concluídas)**, blocos "RESPOSTA < 15 minutos" e "NF ORIGEM Validada no Sefaz" |
| E8 | Ficha Técnica Oficial | Etiqueta "REVISÃO AUTORIZADA" · grade 2 colunas: Horímetro 1.150 horas · Ano/Modelo 2012/2013 · Potência 335 cv (9.0L) · Câmbio PowerShift™ 16x5 · Piloto automático Pré-disposto + ATI · Rodados Radiais 800 Michelin · Hidráulico (largura total) |
| E9 | Histórico de Manutenção | Destaque "Motor e Transmissão Novos (08/2024)" + 3 observações do proprietário em lista |
| E10 | Simulação de Prancha & Frete | "Cotação p/ Prancha Pesada" + botão **"Calcular CEP"** |
| E11 | Diretrizes de Segurança Agrou | Aviso em fundo claro com ícone de escudo |
| E12 | Rodapé fixo | Botão verde **"Negociar no WhatsApp"** + botão **telefone** · link "Emitir Proposta Formal com Garantia de Compra" · "Anúncio #AGR-8335" |

### Critérios de aceitação (cada elemento tocável)
| ID | Ao tocar em… | Acontece… |
|----|--------------|-----------|
| C1 | Seta voltar (E1) | Volta para a tela anterior; se não houver, mostra o aviso "Voltando para o Início" |
| C2 | Favoritar (E2) | O coração fica preenchido em vermelho e aparece o aviso "Adicionado aos favoritos"; tocando de novo, desfaz e mostra "Removido dos favoritos" |
| C3 | Compartilhar (E2) | Aparece o aviso "Link do anúncio copiado" |
| C4 | Seta › (E2) | Mostra a próxima foto e o contador muda de "1/6" para "2/6"; na última volta para a primeira |
| C5 | Seta ‹ (E2) | Mostra a foto anterior e o contador diminui; na primeira vai para a última |
| C6 | Miniatura (E3) | A foto principal troca para a miniatura tocada, o contador atualiza e a miniatura fica com borda verde |
| C7 | Calcular CEP (E10) | Abre um diálogo pedindo o CEP; ao confirmar, mostra "Frete estimado: R$ 4.800" |
| C8 | Negociar no WhatsApp (E12) | Abre o WhatsApp do vendedor com a mensagem "Olá! Tenho interesse no Trator John Deere 8335R (#AGR-8335)" |
| C9 | Telefone (E12) | Aparece o aviso "Ligando para Antônio Novaes…" |
| C10 | Emitir Proposta Formal (E12) | Aparece o aviso "Proposta formal em breve" |
| C11 | Rolagem da tela | Cabeçalho (E1) e rodapé (E12) continuam fixos; só o conteúdo rola |

### O que mudou da v1 para a v2
1. Título corrigido para **"Detalhes Do Lote"** (o Figma usa o "Do" maiúsculo) e incluídos o logo e o avatar no cabeçalho.
2. **Incluídos elementos que faltavam:** contador "1/6", favoritar, compartilhar, setas, miniaturas, etiquetas, "Permuta", "Agrou Safe", diretrizes de segurança, botão telefone, link de proposta e código do anúncio.
3. Ficha técnica completa: eram 4 itens, no Figma são 7.
4. Card do vendedor detalhado (fazenda, desde 2021, 28 vendas, tempo de resposta, NF).
5. Botão do WhatsApp corrigido: não fica no fim da página, fica **fixo no rodapé**.
6. **Critérios vagos** ("funciona", "fica bonito") trocados por critérios testáveis no formato "Ao tocar em X, acontece Y" (C1 a C11).
7. Textos exatos copiados do Figma (preço, local, ficha técnica).
