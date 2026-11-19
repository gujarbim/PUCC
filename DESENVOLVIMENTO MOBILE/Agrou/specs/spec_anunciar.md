# Especificação – Tela "Anunciar" (Must M3)

Must M3: criação e publicação de anúncio com fotos, classificação, ficha técnica obrigatória, preço, condições e contato certificado.

## Estrutura da tela (de cima para baixo)

| # | Elemento | Conteúdo exato do Figma |
|---|----------|-------------------------|
| A1 | Cabeçalho fixo | Seta voltar · logo Agrou · título **"Anunciar"** (ou "Editar Anúncio" no modo edição) · avatar do usuário à direita |
| A2 | Barra de progresso | Círculo verde **"2"** · **"Dados Técnicos & Fotos"** · **"Passo 2 de 3"** à direita · barra verde preenchida (~66%) · etapas: `✓ 1. Dados Básicos`, `2. Especificações`, `3. Revisão & Contrato` |
| A3 | Fotos & Registro Obrigatório | Título **"Fotos & Registro Obrigatório"** · selo **"AUDITORIA AGROU"** · subtítulo *"Imagens nítidas aumentam em 70% o fechamento seguro."* · aviso *"Obrigatório: Foto do Horímetro/Registro — Fotografe com nitidez o painel ligado para homologação do lote."* · grade 2×2 com 3 fotos iniciais (`✓ Horímetro OK`, `Vista Frontal`, `Pneus & Rodado`, cada uma com botão vermelho de excluir) + cartão **"Adicionar Foto (Implemento / Motor)"** |
| A4 | Classificação do Maquinário | Seletor segmentado **"Máquinas"** (ativo em verde) / **"Animais / Gado"** · dropdown **MARCA FABRICANTE** (padrão `John Deere`) · campo **MODELO COMERCIAL** (padrão `8335R`) |
| A5 | Ficha Técnica Obrigatória | Grade 2×2: **ANO FABRICAÇÃO** (`2013`), **HORÍMETRO (HORAS)** (`1.150` `hrs`), **POTÊNCIA NOMINAL** (`335` `cv`), **TIPO DE TRAÇÃO** (dropdown `4x4 Integral`) + dropdown **ESTADO DE CONSERVAÇÃO** (`Usado - Excelente estado (Revisado em concessionária)`) |
| A6 | Condições Comerciais | Card **"Valor à Vista / Liquidação"** com campo editável **"R$ 430.000,00"** e referência *"Precificação média da categoria: R$ 420k - 450k"* · seção **FLEXIBILIDADE DE NEGOCIAÇÃO** com 3 caixas marcáveis: *Aceita Contraproposta*, *Permuta por Grãos (Barter Safra)* e *Apto para Financiamento Bancário* |
| A7 | Origem e Contato Certificado | Campo **CANAL DIRETO (WHATSAPP)** (`(17) 99821-XXXX`) + selo **"SMS Validado"** · campo **PONTO DE COLETA / INSPEÇÃO** (`Mirassol, SP`) · texto auxiliar *"Hub logístico próximo a rodovias estaduais (FOB Disponível)."* |
| A8 | Destaque Topo Agro | Card em lavanda com selo **"5x Mais Vistas"**, descrição de 30 dias no topo estadual, **"Taxa única R$ 49,90"** e interruptor (Switch) ligado por padrão |
| A9 | Ações finais | Botão verde **"Publicar Anúncio Agora"** · botão secundário **"Salvar Rascunho & Continuar no Galpão"** · rodapé *"Transação Segura & Custódia Contratual Agrou Brasil"* |

## Navegações e critérios de aceitação

| ID | Botão / Ação | Tela que abre / O que mostra |
|----|--------------|------------------------------|
| AN1 | Seta voltar (A1) | Fecha **Anunciar** e retorna para a tela anterior (**Início** ou **Painel – Meus Anúncios**) sem criar ou alterar anúncio |
| AN2 | Excluir foto / Adicionar Foto (A3) | Remove a foto tocada da grade (atualizando a contagem) ou adiciona uma nova foto à lista |
| AN3 | Alternar **Máquinas** / **Animais / Gado** (A4) | Muda a categoria selecionada do anúncio; ao publicar, o anúncio entra no setor correspondente |
| AN4 | Marcar/desmarcar flexibilidades (A6) e Switch Destaque (A8) | Alterna o estado de cada opção comercial e do destaque de R$ 49,90 |
| AN5 | **Publicar Anúncio Agora** com campos obrigatórios válidos (A9) | Publica (ou salva edição) o anúncio na store compartilhada, exibe aviso de confirmação e abre **Painel – Meus Anúncios** exibindo o anúncio novo/editado no topo da aba **Ativos** (e também visível na tela **Início**) |
| AN6 | **Publicar Anúncio Agora** com campo obrigatório vazio (ex.: Modelo Comercial, Valor ou Local vazios) | Bloqueia a publicação, destaca a mensagem de validação em vermelho no campo vazio e mantém o usuário na tela **Anunciar** |
| AN7 | **Salvar Rascunho & Continuar no Galpão** (A9) | Salva o anúncio com status **Pausado** e abre **Painel – Meus Anúncios** com aviso de rascunho salvo |
| AN8 | Toque duplo rápido em **Publicar Anúncio Agora** | Trava anti-duplo-toque impede a criação de dois anúncios idênticos |
