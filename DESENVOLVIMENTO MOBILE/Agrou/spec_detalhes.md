# Especificação – Tela "Detalhes Do Lote" (Must M2)

Must M2: ver os detalhes técnicos de um anúncio e negociar com o vendedor pelo WhatsApp.

**Limite de implementação:** Esta tela já foi construída na atividade anterior; durante a integração do fluxo, **não alterar nenhuma outra tela** além do recebimento dos dados do anúncio e do retorno para a tela **Agrou – Início**.

**Origem dos dados:** Os dados exibidos na tela (categoria, etiquetas, título, localização, galeria de fotos, preço, condição de permuta, card do vendedor, ficha técnica de 7 itens, histórico de manutenção, origem do frete e código do anúncio) vêm do objeto `Anuncio` enviado pela tela **Agrou – Início** no momento da navegação (`Navigator.push`), com fallback para o anúncio padrão **"Trator John Deere 8335R"** quando aberta isoladamente em testes.

---

## Versão 1 – escrita na atividade anterior (em miniatura)

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

---

## Versão Final – revisada com o Figma e com a navegação do fluxo M1 → M2

**Objetivo:** o comprador confere as fotos e a ficha técnica do lote recebido da tela Início e abre a conversa com o vendedor no WhatsApp ou retorna à lista mantendo seus filtros.

### Estrutura (de cima para baixo)
| # | Elemento | Conteúdo exato |
|---|----------|----------------|
| E1 | Cabeçalho fixo (`64 px`, `#FAF8FF`) | Seta voltar (`btnVoltar`) · logo `"Agrou"` (`#F1F3EE`, `#0F5C2A`) · título **"Detalhes Do Lote"** · avatar do usuário à direita (`assets/avatar_user.png`) |
| E2 | Galeria | Foto `height: 292 px`, contador **"1/N"** (ex.: **"1/6"**) no canto superior esquerdo, botões **favoritar** e **compartilhar** no canto superior direito, setas **‹ ›** nas laterais |
| E3 | Miniaturas | Até 5 miniaturas (`64×48`) abaixo da foto; a selecionada recebe borda `#1B7A3A` de `2 px` |
| E4 | Etiquetas | 3 etiquetas do anúncio (no padrão: "Tratores & Máquinas" em `#DCE4FF`, "Usado Revisado" em `#8AF7A0`, "Produtor Verificado (CPF/CNPJ)" em `#FFDDB3`) |
| E5 | Título e local | Título do lote (no padrão: **"Trator John Deere 8335R"**) · localização com pin (no padrão: **"Mirassol, SP • Disponível para vistoria física na fazenda"**) |
| E6 | Card de preço | **"VALOR À VISTA NEGOCIÁVEL"** · valor em `#1B7A3A` (no padrão: **"R$ 430.000"**) · etiqueta **"Permuta"** e subtítulo (no padrão: **"Gado ou Soja Futura"**) · faixa `#F1F2FA` **"Garantia Agrou Safe: pagamento retido em conta escrow até validação do laudo no embarque."** |
| E7 | Card do vendedor | Foto (`48×48`), nome com ícone de verificação (no padrão: **"Antônio Novaes"**), fazenda/local (**"Fazenda Santa Fé • Mirassol/SP"**), **"Produtor cadastrado desde 2021"**, nota **★ 4.9 (28 vendas concluídas)**, blocos **"RESPOSTA < 15 minutos"** e **"NF ORIGEM Validada no Sefaz"** |
| E8 | Ficha Técnica Oficial | Etiqueta **"REVISÃO AUTORIZADA"** · grade 2 colunas com os 7 itens técnicos do lote (no padrão: Horímetro `1.150 horas` · Ano/Modelo `2012 / 2013` · Potência Nominal `335 cv (9.0L)` · Câmbio `PowerShift™ 16x5` · Piloto Automático `Pré-disposto + ATI` · Rodados & Pneus `Radiais 800 Michelin` · Hidráulico & Válvulas `Barramento Hidráulico + TDP + 4 VCRs de Alto Fluxo`) |
| E9 | Histórico de Manutenção | Destaque (no padrão: **"Motor e Transmissão Novos (08/2024)"**) + 3 observações do proprietário em lista |
| E10 | Simulação de Prancha & Frete | **"Cotação p/ Prancha Pesada"** + botão **"Calcular CEP"** |
| E11 | Diretrizes de Segurança Agrou | Bloco em fundo `#F1F2FA` com ícone de escudo `#9A6A00` e texto orientativo de vistoria presencial |
| E12 | Rodapé fixo (`#FFFFFF`) | Botão `#25D366` **"Negociar no WhatsApp"** + botão **telefone** · link **"Emitir Proposta Formal com Garantia de Compra"** · código do anúncio (no padrão: **"Anúncio #AGR-8335"**) |

### Critérios de aceitação e navegação de volta
| ID | Ao tocar em… | Acontece… |
|----|--------------|-----------|
| C1 (Volta) | Seta voltar (E1) | Ao tocar na seta de voltar (`btnVoltar`), fecha a tela **Detalhes Do Lote** (`Navigator.pop`) e **volta à tela Agrou – Início mantendo o texto de busca, a região, o setor, a modalidade selecionada e o estado de favorito do anúncio**; se aberta sem tela anterior na pilha, exibe o aviso **"Voltando para o Início"** |
| C2 | Favoritar (E2) | O coração muda para preenchido em `#F44336` e aparece o aviso **"Adicionado aos favoritos"**; tocando novamente, alterna para borda vazia e mostra **"Removido dos favoritos"**, refletindo o estado ao retornar para a tela **Início** |
| C3 | Compartilhar (E2) | Aparece o aviso **"Link do anúncio copiado"** |
| C4 | Seta › (E2) | Mostra a próxima foto e o contador incrementa (`"1/6"` → `"2/6"`); na última foto retorna à primeira |
| C5 | Seta ‹ (E2) | Mostra a foto anterior e o contador decrementa; na primeira foto vai para a última |
| C6 | Miniatura (E3) | A foto principal muda para a miniatura tocada, o contador atualiza e a miniatura recebe borda `#1B7A3A` de `2 px` |
| C7 | Calcular CEP (E10) | Abre diálogo solicitando CEP; se informado CEP numérico com 8 dígitos (aceitando hífen), calcula e exibe **"Frete estimado: R$ 4.800"**; se vazio, só com espaços ou inválido, exibe erro de validação sem calcular valor incorreto |
| C8 | Negociar no WhatsApp (E12) | Abre o WhatsApp do vendedor com a mensagem preenchida com o título e código do anúncio |
| C9 | Telefone (E12) | Aparece o aviso **"Ligando para [nome do vendedor]…"** |
| C10 | Emitir Proposta Formal (E12) | Aparece o aviso **"Proposta formal em breve"** |
| C11 | Rolagem da tela | Cabeçalho (E1) e rodapé (E12) continuam fixos; somente o conteúdo central rola |
