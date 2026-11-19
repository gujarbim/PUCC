# Especificação – Tela "Painel – Meus Anúncios" (Must M4)

Must M4: painel do anunciante para acompanhar métricas e gerenciar os próprios anúncios (criar, editar, pausar, reativar, marcar como vendido e excluir).

## Estrutura da tela (de cima para baixo)

| # | Elemento | Conteúdo exato do Figma |
|---|----------|-------------------------|
| P1 | Cabeçalho fixo | Logo Agrou · título **"Agrou"** e subtítulo **"Meus Anúncios"** · ícone de notificações com indicador vermelho · avatar do usuário à direita |
| P2 | Faixa de cotações | Fundo azul escuro (`#283044`) com ícone verde de tendência e texto **"Soja Mar/25: R$ 138,40/sc (+0.8%) \| Milho Campinas: R$ 68,20/sc (-0.3%)"** |
| P3 | Card do Produtor | Foto do produtor com selo verificado · etiqueta **"Produtor Verificado ✓"** · nome **"Antônio Carlos Novaes"** · **"Fazenda Boa Esperança • Mirassol, SP"** · 3 blocos de métricas: **Anúncios Ativos** (dinâmico, inicia em `3`), **48 Cliques WhatsApp** (`+14%`), **1.420 Visualizações** (`Mês`) |
| P4 | Gestão de Lotes & Máquinas | Título **"Gestão de Lotes & Máquinas"** · botão **"+ Novo anúncio"** à direita · 3 abas com contadores dinâmicos: **"Ativos [3]"**, **"Pausados [1]"**, **"Vendidos [4]"** |
| P5 | Cards de anúncios ativos | Foto com selo verde `● Ativo • há X dias`, etiqueta de categoria (`Máquinas Agrícolas` / `Pecuária de Corte`) e rodapé da foto (`FOB Mirassol, SP` / `Média: 210 kg / cab.`) · título, subtítulo técnico e preço à direita (`Valor à vista R$ 430.000`, `Lote fechado R$ 162.000`) · faixa de métricas (`840 visualizações • 26 contatos WhatsApp`) · botão **"⚡ Turbinar Anúncio (Destaque Regional)"** (no anúncio principal) · botões **"Editar"**, **"Pausar"**, **"Marcar como Vendido"** / **"Excluir"** |
| P6 | Card de anúncio pausado | Foto com selo dourado `⏸ Pausado • Negociação em Barretos` e faixa *"Comprador reservou via WhatsApp • Aguardando sinal de frete"* · título **"Grade Aradora Baldan 28 Discos"** · `Proposta atual R$ 65.000` · botões **"Reativar Anúncio"** (verde) e **"Confirmar Venda"** |
| P7 | Segurança da Propriedade | Card com selo verde **"100% Validado"**, texto de auditoria, linhas `CPF / CNPJ Titular (***.482.908-**)` e `CAR (Cadastro Ambiental Rural) (SP-3530300-***)` e botões **"Cartilha Antifraude"** e **"Suporte WhatsApp"** |
| P8 | Barra de navegação inferior fixa | 5 itens: **Início**, **Explorar**, botão central **"+ Anunciar"**, **Anúncios** (ativo, com badge dinâmico da quantidade de ativos) e **Perfil** |

## Navegações e critérios de aceitação

| ID | Botão / Ação | Tela que abre / O que mostra |
|----|--------------|------------------------------|
| PN1 | **+ Novo anúncio** (P4) ou **+ Anunciar** (P8) | Abre a tela **Anunciar** em modo criação; ao publicar, retorna ao **Painel** com o novo anúncio listado em **Ativos** e contador incrementado |
| PN2 | **Editar** em um card (P5) | Abre a tela **Anunciar** preenchida com os dados atuais daquele anúncio (modelo, ano, valor, local); ao salvar, volta ao **Painel** mostrando os valores atualizados no card |
| PN3 | **Pausar** em um card ativo (P5) | Move o anúncio para **Pausados**, diminui o contador **Ativos** e aumenta **Pausados** |
| PN4 | **Reativar Anúncio** em um card pausado (P6) | Move o anúncio de volta para **Ativos**, atualizando os contadores das abas e do card do produtor |
| PN5 | **Marcar como Vendido** (P5) / **Confirmar Venda** (P6) | Move o anúncio para **Vendidos**, incrementando o contador de vendidos |
| PN6 | **Excluir** em um card (P5) | Remove o anúncio da lista e exibe confirmação, atualizando o contador de **Ativos** |
| PN7 | Abas **Ativos / Pausados / Vendidos** (P4) | Filtra os cards exibidos conforme o status selecionado |
| PN8 | Tocar na foto/título de um card (P5/P6) | Abre **Detalhes Do Lote** com os dados do anúncio tocado; seta voltar retorna ao **Painel** |
| PN9 | **Início** na barra inferior (P8) | Retorna à tela **Agrou – Início**, refletindo os anúncios ativos atualizados |
| PN10 | **Turbinar Anúncio**, **Cartilha Antifraude**, **Suporte WhatsApp** | Exibe feedback claro (SnackBar) informando a ação executada |
