import json

def create_simplified_notebook():
    nb = {
        "cells": [],
        "metadata": {
            "kernelspec": {
                "display_name": "Python 3",
                "language": "python",
                "name": "python3"
            },
            "language_info": {
                "codemirror_mode": {"name": "ipython", "version": 3},
                "file_extension": ".py",
                "mimetype": "text/x-python",
                "name": "python",
                "nbconvert_exporter": "python",
                "pygments_lexer": "ipython3",
                "version": "3.14.5"
            }
        },
        "nbformat": 4,
        "nbformat_minor": 5
    }

    def md_cell(source):
        return {
            "cell_type": "markdown",
            "metadata": {},
            "source": [line + "\n" for line in source.strip().split("\n")]
        }

    def code_cell(source):
        return {
            "cell_type": "code",
            "execution_count": None,
            "metadata": {},
            "outputs": [],
            "source": [line + "\n" for line in source.strip().split("\n")]
        }

    # Cabeçalho
    nb["cells"].append(md_cell("""# Exercício 8-Puzzle: Busca em Largura e Profundidade
**Disciplina:** Mineração de Dados e Business Intelligence - Prática  
**Instituição:** Pontifícia Universidade Católica (PUC)  

---

### Integrantes do Grupo:
- **Aluno 1:** [Nome do Aluno 1] - **RA:** [0000000]
- **Aluno 2:** [Nome do Aluno 2] - **RA:** [0000000]
- **Aluno 3:** [Nome do Aluno 3] - **RA:** [0000000] *(Opcional)*

---

### Objetivo:
Resolver o 8-puzzle através de:
1. Geração de estado inicial aleatório com teste de solubilidade via **número de inversões** (inversões par = solúvel; ímpar = descartar e gerar outro).
2. **Busca em Largura (BFS)** e **Busca em Profundidade (DFS)**.
3. Exibição do tabuleiro a cada iteração e contagem final de iterações $N$."""))

    # Passo 1
    nb["cells"].append(md_cell("""## Passo 1: Estado Objetivo e Formatação do Tabuleiro

- **O que faz:** Define a tupla do estado final desejado `(1, 2, 3, 4, 5, 6, 7, 8, 'X')` e uma função para imprimir a grade 3x3 com barras verticais.
- **Por que faz:** Para padronizar a representação do tabuleiro exatamente no formato exigido pelo enunciado (`|1 | 2 | 3|`)."""))

    nb["cells"].append(code_cell("""# Estado objetivo final
OBJETIVO = (1, 2, 3, 4, 5, 6, 7, 8, 'X')

def imprimir_tabuleiro(estado):
    \"\"\"Imprime o estado 3x3 no formato solicitado.\"\"\"
    for i in range(0, 9, 3):
        linha = estado[i:i+3]
        print(f"|{linha[0]} | {linha[1]} | {linha[2]}|")

# Demonstração:
print("Estado Objetivo:")
imprimir_tabuleiro(OBJETIVO)"""))

    # Passo 2
    nb["cells"].append(md_cell("""## Passo 2: Verificação de Solubilidade (Número de Inversões)

- **O que faz:** Conta quantas vezes um número maior aparece antes de um número menor na sequência linear (ignorando o `'X'`).
- **Por que faz:** Metade das $9! = 362.880$ permutações do 8-puzzle é impossível de resolver. Qualquer movimento de peça altera a quantidade de inversões em $0$, $+2$ ou $-2$ (paridade constante). Como o objetivo tem $0$ inversões (par), o quebra-cabeça **só tem solução se o número de inversões for PAR**."""))

    nb["cells"].append(code_cell("""def contar_inversoes(estado):
    \"\"\"Conta quantos pares estão fora da ordem numérica (ignorando 'X').\"\"\"
    numeros = [x for x in estado if x != 'X']
    inversoes = 0
    for i in range(len(numeros)):
        for j in range(i + 1, len(numeros)):
            if numeros[i] > numeros[j]:
                inversoes += 1
    return inversoes

def eh_soluvel(estado):
    \"\"\"Retorna True se o número de inversões for par.\"\"\"
    return contar_inversoes(estado) % 2 == 0

# Teste com o estado objetivo (0 inversões -> True)
print(f"Inversões no objetivo: {contar_inversoes(OBJETIVO)} -> Solúvel? {eh_soluvel(OBJETIVO)}")"""))

    # Passo 3
    nb["cells"].append(md_cell("""## Passo 3: Geração do Estado Inicial Aleatório

- **O que faz:** Embaralha as 9 posições aleatoriamente. Se o número de inversões for ímpar, descarta e repete o sorteio até encontrar um estado par (solúvel).
- **Por que faz:** Atende diretamente à exigência do enunciado: *"gerar um estado inicial aleatório e verificar se o estado é possível de ser resolvido (verificar o número de inversões), caso não seja, deve gerar outro."*"""))

    nb["cells"].append(code_cell("""import random

def gerar_estado_inicial():
    \"\"\"Gera uma configuração aleatória solúvel.\"\"\"
    pecas = [1, 2, 3, 4, 5, 6, 7, 8, 'X']
    tentativa = 1
    while True:
        random.shuffle(pecas)
        estado = tuple(pecas)
        inversoes = contar_inversoes(estado)
        if eh_soluvel(estado) and estado != OBJETIVO:
            print(f"[OK] Estado gerado na tentativa {tentativa} (Inversões: {inversoes} - Par/Solúvel)")
            return estado
        tentativa += 1

# Gerando e exibindo o estado inicial para os testes:
estado_inicial = gerar_estado_inicial()
print("\\nTabuleiro Inicial:")
imprimir_tabuleiro(estado_inicial)"""))

    # Passo 4
    nb["cells"].append(md_cell("""## Passo 4: Movimentos Válidos (Sucessores)

- **O que faz:** Identifica a posição do `'X'` e gera os novos tabuleiros trocando o `'X'` com os vizinhos imediatos (Cima, Baixo, Esquerda, Direita), sem ultrapassar as bordas 3x3.
- **Por que faz:** Define as transições de estado permitidas pelas regras do jogo."""))

    nb["cells"].append(code_cell("""def gerar_sucessores(estado):
    \"\"\"Gera todos os movimentos válidos para o espaço vazio 'X'.\"\"\"
    sucessores = []
    idx = estado.index('X')
    linha, col = divmod(idx, 3)

    # Movimentos: (variação de linha, variação de coluna)
    movimentos = [(-1, 0), (1, 0), (0, -1), (0, 1)]  # Cima, Baixo, Esquerda, Direita

    for dl, dc in movimentos:
        nova_l, nova_c = linha + dl, col + dc
        if 0 <= nova_l < 3 and 0 <= nova_c < 3:
            novo_idx = nova_l * 3 + nova_c
            novo_estado = list(estado)
            novo_estado[idx], novo_estado[novo_idx] = novo_estado[novo_idx], novo_estado[idx]
            sucessores.append(tuple(novo_estado))

    return sucessores"""))

    # Passo 5
    nb["cells"].append(md_cell("""## Passo 5: Busca em Largura (BFS)

- **O que faz:** Explora os estados nível por nível utilizando uma fila FIFO (`deque`). A cada iteração, retira o primeiro da fila, imprime o tabuleiro e gera os próximos estados não visitados.
- **Por que faz:** Garante encontrar a solução com o menor número de movimentos (ótima)."""))

    nb["cells"].append(code_cell("""from collections import deque

def busca_largura(estado_inicial, max_impressoes=15):
    \"\"\"Executa a Busca em Largura (BFS) imprimindo cada iteração.\"\"\"
    print("\\n" + "=" * 45)
    print("BUSCA EM LARGURA (BFS)")
    print("=" * 45)
    print("Estado inicial:")
    imprimir_tabuleiro(estado_inicial)
    print("-" * 45)

    fila = deque([estado_inicial])
    visitados = {estado_inicial}
    iteracoes = 0

    while fila:
        iteracoes += 1
        atual = fila.popleft()

        # Apresenta o estado a cada iteração
        if iteracoes <= max_impressoes:
            print(f"Iteração {iteracoes}:")
            imprimir_tabuleiro(atual)
            print()
        elif iteracoes == max_impressoes + 1:
            print("...\\n")

        # Verifica objetivo
        if atual == OBJETIVO:
            print("Estado Final:")
            imprimir_tabuleiro(atual)
            print(f"\\nNúmero de iterações para busca em largura N: {iteracoes}")
            return iteracoes

        # Expansão
        for vizinho in gerar_sucessores(atual):
            if vizinho not in visitados:
                visitados.add(vizinho)
                fila.append(vizinho)

    return iteracoes

# Executando BFS:
n_bfs = busca_largura(estado_inicial)"""))

    # Passo 6
    nb["cells"].append(md_cell("""## Passo 6: Busca em Profundidade (DFS)

- **O que faz:** Explora os estados aprofundando o máximo possível ao longo de cada ramo utilizando uma pilha LIFO (`list`). Utiliza um conjunto de visitados para evitar loops infinitos.
- **Por que faz:** Apresenta a estratégia alternativa vista em sala de aula (busca não-informada orientada a profundidade)."""))

    nb["cells"].append(code_cell("""def busca_profundidade(estado_inicial, max_impressoes=15):
    \"\"\"Executa a Busca em Profundidade (DFS) imprimindo cada iteração.\"\"\"
    print("\\n" + "=" * 45)
    print("BUSCA EM PROFUNDIDADE (DFS)")
    print("=" * 45)
    print("Estado inicial:")
    imprimir_tabuleiro(estado_inicial)
    print("-" * 45)

    pilha = [estado_inicial]
    visitados = {estado_inicial}
    iteracoes = 0

    while pilha:
        iteracoes += 1
        atual = pilha.pop()

        # Apresenta o estado a cada iteração
        if iteracoes <= max_impressoes:
            print(f"Iteração {iteracoes}:")
            imprimir_tabuleiro(atual)
            print()
        elif iteracoes == max_impressoes + 1:
            print("...\\n")

        # Verifica objetivo
        if atual == OBJETIVO:
            print("Estado Final:")
            imprimir_tabuleiro(atual)
            print(f"\\nNúmero de iterações para busca em profundidade N: {iteracoes}")
            return iteracoes

        # Expansão (ordem invertida na pilha para visitar na ordem padrão)
        for vizinho in reversed(gerar_sucessores(atual)):
            if vizinho not in visitados:
                visitados.add(vizinho)
                pilha.append(vizinho)

    return iteracoes

# Executando DFS:
n_dfs = busca_profundidade(estado_inicial)"""))

    # Passo 7
    nb["cells"].append(md_cell("""## Passo 7: Resumo e Comparação dos Resultados

- **O que faz:** Exibe lado a lado o número final de iterações $N$ obtido em cada método.
- **Por que faz:** Permite comparar a eficiência e o comportamento prático entre BFS e DFS para o mesmo estado inicial."""))

    nb["cells"].append(code_cell("""print("=" * 45)
print("RESUMO FINAL:")
print(f"Número de iterações para busca em largura N: {n_bfs}")
print(f"Número de iterações para busca em profundidade N: {n_dfs}")
print("=" * 45)"""))

    return nb

if __name__ == '__main__':
    notebook_content = create_simplified_notebook()
    with open('c:/DEV/PUC/MINERAÇÃO DE DADOS E BUSINESS INTELLIGENCE/Exercício 8 Puzzle/puzzle.ipynb', 'w', encoding='utf-8') as f:
        json.dump(notebook_content, f, indent=1, ensure_ascii=False)
    print("puzzle.ipynb simplificado gerado com sucesso!")
