# Especificação – Tela "Agrou – Início" (Must M1)

Must M1: navegar e buscar anúncios por categorias (Animais, Máquinas, Insumos, Veículos) e abrir um anúncio da lista de oportunidades.

**Limite de implementação:** Construir somente a tela **Agrou – Início** e os dados estáticos dos anúncios exibidos nela; **não alterar nenhuma outra tela** (nem criar telas adicionais como Explorar, Anunciar, Anúncios ou Perfil).

**Origem dos dados:** Os 4 setores e os 4 anúncios de "Oportunidades do Dia" vêm da base estática local em memória (`anunciosIniciais` em `lib/models/anuncio.dart`), com textos e valores extraídos do protótipo do Figma (`figma.svg`).

---

## Estrutura (de cima para baixo)

| # | Elemento | Conteúdo exato |
|---|----------|----------------|
| E1 | Cabeçalho fixo (64 px, `#FAF8FF`) | Logo `Agrou` (`32×32`, `assets/logo_agrou.jpg`) · título **"Agrou"** em `#0F5C2A` e subtítulo **"Início"** em `#5B6070` · botão de notificações (sino com ponto `#BA1A1A` de `8×8`) e avatar `32×32` (`assets/avatar_user.png`) à direita |
| E2 | Faixa de cotação (36 px, `#283044`) | Ponto `#7FFC97` (`8×8`) + **"MERCADO AGORA"** · à direita: **"Boi Gordo SP: R$ 315,50/@"** + seta de alta + **"+0.8%"** em `#7FFC97` |
| E3 | Banner Hero com busca (`#006B2C` → `#1B7A3A`) | Pílula **"Plataforma Oficial do Agronegócio"** · título **"Negocie direto no campo sem intermediários"** · subtítulo **"A maior rede de pecuaristas, cerealistas e produtores rurais do Brasil. Conecte tratores, gado e insumos em tempo recorde."** · cartão branco com campo de busca (placeholder **"Buscar tratores, nelore, soja, colheitadeiras..."**), botão de filtros (`#EAEDFF`), seletor de região (inicial **"Mato Grosso & SP"**) e botão verde **"Buscar →"** |
| E4 | Faixa de verificação (`#F1F2FA`) | Quadrado `#8AF7A0` (`40×40`) com ícone de selo · título **"100% Produtores Verificados"** · subtítulo **"Zero Golpes • Checagem de CAR, GTA e Nota Fiscal"** · seta `>` à direita |
| E5 | Setores Principais | Cabeçalho **"Setores Principais"** / **"Explore por cadeia produtiva"** + link **"Ver todos>"** · grade 2×2 de cartões `128 px` com foto e texto branco: **1.** "Tratores & Máquinas" ("John Deere, Case, Valtra") · **2.** "Gado & Animais" ("Nelore PO, Cruzamento, Bezerras") · **3.** "Insumos & Sementes" ("Adubo, Defensivos, Soja/Milho") · **4.** "Veículos & Carga" ("Camionetes, Bitrens, Carretas") |
| E6 | Modalidades de Negócio | Título **"Modalidades de Negócio"** · 3 botões horizontais: **"Compra Direta"** (inicialmente ativo em `#006B2C`, texto branco), **"Leilões Ativos"** (`#F1F2FA`), **"Barter & Permuta"** (`#F1F2FA`) |
| E7 | Oportunidades do Dia | Cabeçalho **"Oportunidades do Dia"** / **"Lotes auditados com documentação regular"** · lista de 4 cards (`foto 192 px`, badge topo-esquerdo, badge base-direita, categoria, local com pin, título, 2 colunas técnicas em `#F1F2FA`, rótulo/valor em `#1B7A3A` e botão **"Negociar"**): **1.** `Lote 45 Novilhas Nelore PO Registradas` (`PECUÁRIA DE CORTE`, `Uberaba, MG`, `Peso Médio: 320 kg / 10.7 @`, `Idade & Status: 18 Meses (Vacinadas)`, `Valor Total do Lote: R$ 148.000`) · **2.** `Trator John Deere 8335R (335 cv) Cabinado` (`TRATORES AGRÍCOLAS`, `Mirassol, SP`, `Horímetro: 1.150 horas originais`, `Transmissão: AutoPowr IVT • Duplado`, `Preço à Vista: R$ 430.000`) · **3.** `Colheitadeira New Holland CR 9060` (`COLHEITADEIRAS DE GRÃOS`, `Rio Verde, GO`, `Horas de Motor/Trilha: 2.400h / 1.780h`, `Plataforma: 35 Pés Drapper Flex`, `Valor Negociável: R$ 890.000`) · **4.** `Pulverizador Jacto Uniport 3030 Plus` (`PULVERIZADORES`, `Sorriso, MT`, `Capacidade Tanque: 3.000 Litros`, `Barra de Pulverização: 32 Metros Corte Seção`, `Valor Especial: R$ 620.000`) |
| E8 | Banner CTA anunciante (`#283044`) | Etiqueta **"VENDA DIRETA SEM COMISSÃO"** (`#7FFC97`) · título **"Tem maquinário ou gado para negociar?"** · texto **"Crie seu anúncio grátis em 2 minutos e receba propostas diretas no WhatsApp de compradores qualificados de todo o Brasil."** · botão **"Publicar Anúncio Grátis"** · rodapé **"Sem mensalidade"** e **"Contato Direto"** |
| E9 | Rodapé institucional (`#E2E7FF`) | Logo **"Agrou"** · descrição do ecossistema · 4 links (**Termos e Condições**, **Privacidade & LGPD**, **Suporte ao Produtor**, **Segurança & GTA**) · **"© 2026 Agrou Tecnologia Agrícola Ltda. Todos os direitos reservados."** |
| E10 | Barra inferior fixa (`64 px`, `#FAF8FF`) | 5 itens: **"Início"** (selecionado `#006B2C`), **"Explorar"**, botão central `+` **"Anunciar"** (`48×48`, `#006B2C`), **"Anúncios"** com badge **"3"**, **"Perfil"** |

---

## Critérios de aceitação (elementos da tela)

| ID | Ao tocar em… | Acontece… |
|----|--------------|-----------|
| I1 | Notificações ou Avatar (E1) | Exibe o aviso **"Nenhuma notificação nova"** (para o sino) ou **"Usuário logado: Antônio Carlos Novaes"** (para o avatar) |
| I2 | Campo de busca + botão **"Buscar →"** (E3) | Se houver texto válido após `.trim()`, filtra a lista **"Oportunidades do Dia"** por título, categoria ou local exibindo somente os correspondentes (ou estado vazio **"Nenhum anúncio encontrado"** com botão **"Limpar filtros"**). Se o campo estiver vazio ou só com espaços, mantém os 4 anúncios (ou remove filtro de texto) sem apagar os resultados nem gerar erro |
| I3 | Seletor de região **"Mato Grosso & SP"** (E3) | Abre opções de região (**Todas as regiões**, **Mato Grosso & SP**, **Uberaba, MG**, **Mirassol, SP**, **Rio Verde, GO**, **Sorriso, MT**); ao escolher uma região específica, filtra a lista para a região correspondente e atualiza o texto do seletor |
| I4 | Botão de filtros avançados (E3) / Faixa de verificação (E4) | Exibe o aviso **"Filtros técnicos aplicados"** (ou diálogo de filtro rápido) e **"Produtores validados por CAR, GTA e Sefaz"** |
| I5 | Card de setor em **Setores Principais** (E5) | Seleciona o setor tocado com borda verde `#006B2C` e filtra **"Oportunidades do Dia"** pelo setor escolhido; tocando no mesmo setor ou em **"Ver todos>"**, remove o filtro e volta a exibir todos os 4 anúncios |
| I6 | Botão em **Modalidades de Negócio** (E6) | Alterna o botão selecionado para `#006B2C` (texto branco) e filtra os anúncios da modalidade (**Compra Direta** mostra os 4 anúncios; **Barter & Permuta** mostra os que aceitam permuta: Trator John Deere 8335R e Colheitadeira New Holland CR 9060; **Leilões Ativos** exibe a mensagem **"Nenhum leilão ativo no momento"** com botão **"Ver todos os lotes"**) |
| I7 | **"Publicar Anúncio Grátis"** (E8), links do rodapé (E9) ou abas **"Explorar" / "Anunciar" / "Anúncios" / "Perfil"** (E10) | Exibe aviso informando que a tela correspondente está fora do fluxo atual (ex.: **"Criação de anúncio disponível na próxima entrega"**), sem alterar a tela atual |
| I8 | Rolagem da tela | Cabeçalho (E1) e barra inferior (E10) permanecem fixos; apenas o conteúdo central rola |

---

## Critério de navegação (ida)

| ID | Destino | Regra ("Ao tocar em X, abre a tela Y com Z") |
|----|---------|---------------------------------------------|
| N1 | **Detalhes Do Lote** (a partir do Card 1 – Novilhas Nelore) | Ao tocar no card ou no botão **"Negociar"** de **"Lote 45 Novilhas Nelore PO Registradas"**, abre a tela **Detalhes Do Lote** com o título **"Lote 45 Novilhas Nelore PO Registradas"**, localização **"Uberaba, MG • Fazenda Santa Clara"**, valor **"R$ 148.000"**, fotos do lote e ficha técnica de pecuária |
| N2 | **Detalhes Do Lote** (a partir do Card 2 – Trator John Deere 8335R) | Ao tocar no card ou no botão **"Negociar"** de **"Trator John Deere 8335R (335 cv) Cabinado"**, abre a tela **Detalhes Do Lote** com o título **"Trator John Deere 8335R"**, localização **"Mirassol, SP • Disponível para vistoria física na fazenda"**, valor **"R$ 430.000"**, galeria de 6 fotos e ficha técnica de 7 itens |
| N3 | **Detalhes Do Lote** (a partir do Card 3 – Colheitadeira New Holland CR 9060) | Ao tocar no card ou no botão **"Negociar"** de **"Colheitadeira New Holland CR 9060"**, abre a tela **Detalhes Do Lote** com o título **"Colheitadeira New Holland CR 9060"**, localização **"Rio Verde, GO • Disponível para vistoria na fazenda"**, valor **"R$ 890.000"**, foto da colheitadeira e ficha técnica de colheitadeira |
| N4 | **Detalhes Do Lote** (a partir do Card 4 – Pulverizador Jacto Uniport 3030 Plus) | Ao tocar no card ou no botão **"Negociar"** de **"Pulverizador Jacto Uniport 3030 Plus"**, abre a tela **Detalhes Do Lote** com o título **"Pulverizador Jacto Uniport 3030 Plus"**, localização **"Sorriso, MT • Disponível para vistoria na fazenda"**, valor **"R$ 620.000"**, foto do pulverizador e ficha técnica do pulverizador |
