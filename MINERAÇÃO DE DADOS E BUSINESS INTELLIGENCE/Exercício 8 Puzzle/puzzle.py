"""
======================================================================
PUC - MINERAÇÃO DE DADOS E BUSINESS INTELLIGENCE
EXERCÍCIO: 8-PUZZLE (BUSCA EM LARGURA E PROFUNDIDADE)

Integrantes do Grupo:
- Aluno 1: [Nome do Aluno 1] - RA: [0000000]
- Aluno 2: [Nome do Aluno 2] - RA: [0000000]
- Aluno 3: [Nome do Aluno 3] - RA: [0000000]
======================================================================
"""

import random
from collections import deque

# --------------------------------------------------------------------
# 1. ESTADO OBJETIVO E FORMATAÇÃO DO TABULEIRO
# --------------------------------------------------------------------
# O objetivo final é ter as peças de 1 a 8 ordenadas e o 'X' no final.
OBJETIVO = (1, 2, 3, 4, 5, 6, 7, 8, 'X')


def imprimir_tabuleiro(estado):
    """
    O QUE FAZ: Imprime o estado 3x3 no formato solicitado pelo professor:
    |1 | 2 | 3|
    |4 | 5 | 6|
    |7 | 8 | X|
    """
    for i in range(0, 9, 3):
        linha = estado[i:i+3]
        print(f"|{linha[0]} | {linha[1]} | {linha[2]}|")


# --------------------------------------------------------------------
# 2. VERIFICAÇÃO DE SOLUBILIDADE (CONTAGEM DE INVERSÕES)
# --------------------------------------------------------------------
# POR QUE: Metade das permutações do 8-puzzle é matematicamente impossível
# de resolver. Para saber se tem solução, contamos as inversões (números
# maiores que aparecem antes de números menores, ignorando o 'X').
# Se o total de inversões for PAR, o quebra-cabeça tem solução.

def contar_inversoes(estado):
    """Conta quantos pares de números estão fora de ordem crescente."""
    numeros = [x for x in estado if x != 'X']
    inversoes = 0
    for i in range(len(numeros)):
        for j in range(i + 1, len(numeros)):
            if numeros[i] > numeros[j]:
                inversoes += 1
    return inversoes


def eh_soluvel(estado):
    """Retorna True se o número de inversões for par (solúvel)."""
    return contar_inversoes(estado) % 2 == 0


# --------------------------------------------------------------------
# 3. GERAÇÃO DO ESTADO INICIAL ALEATÓRIO
# --------------------------------------------------------------------
# O QUE FAZ: Embaralha as peças de 1 a 8 e o 'X'.
# POR QUE: O enunciado exige gerar um estado aleatório e verificar se é
# solúvel. Se o número de inversões for ímpar, ele descarta e gera outro.

def gerar_estado_inicial():
    """Gera um estado aleatório e garante que ele seja solúvel."""
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


# --------------------------------------------------------------------
# 4. GERAÇÃO DE MOVIMENTOS VÁLIDOS (SUCESSORES)
# --------------------------------------------------------------------
# O QUE FAZ: Encontra a posição do 'X' e troca com as peças vizinhas válidas
# (Cima, Baixo, Esquerda ou Direita) sem sair do tabuleiro 3x3.

def gerar_sucessores(estado):
    """Gera os novos estados possíveis a partir do movimento do 'X'."""
    sucessores = []
    idx = estado.index('X')
    linha, col = divmod(idx, 3)

    # Movimentos possíveis: (delta_linha, delta_coluna)
    movimentos = [(-1, 0), (1, 0), (0, -1), (0, 1)]  # Cima, Baixo, Esquerda, Direita

    for dl, dc in movimentos:
        nova_l, nova_c = linha + dl, col + dc
        if 0 <= nova_l < 3 and 0 <= nova_c < 3:
            novo_idx = nova_l * 3 + nova_c
            novo_estado = list(estado)
            novo_estado[idx], novo_estado[novo_idx] = novo_estado[novo_idx], novo_estado[idx]
            sucessores.append(tuple(novo_estado))

    return sucessores


# --------------------------------------------------------------------
# 5. BUSCA EM LARGURA (BFS)
# --------------------------------------------------------------------
# O QUE FAZ: Explora o tabuleiro nível por nível usando uma fila FIFO.
# POR QUE: Garante encontrar a solução com o menor número de movimentos (ótima).
# Imprime cada iteração e retorna o total de iterações N.

def busca_largura(estado_inicial, max_impressoes=15):
    """Executa a Busca em Largura (BFS)."""
    print("\n" + "=" * 45)
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

        # Exibe o estado da iteração conforme o enunciado
        if iteracoes <= max_impressoes:
            print(f"Iteração {iteracoes}:")
            imprimir_tabuleiro(atual)
            print()
        elif iteracoes == max_impressoes + 1:
            print("...\n")

        # Verifica se atingiu o objetivo
        if atual == OBJETIVO:
            print("Estado Final:")
            imprimir_tabuleiro(atual)
            print(f"\nNúmero de iterações para busca em largura N: {iteracoes}")
            return iteracoes

        # Gera próximos estados não visitados
        for vizinho in gerar_sucessores(atual):
            if vizinho not in visitados:
                visitados.add(vizinho)
                fila.append(vizinho)

    return iteracoes


# --------------------------------------------------------------------
# 6. BUSCA EM PROFUNDIDADE (DFS)
# --------------------------------------------------------------------
# O QUE FAZ: Explora o tabuleiro aprofundando o máximo possível usando uma pilha LIFO.
# POR QUE: Usa menos memória na fronteira, mas não garante o caminho mais curto.
# Usa o conjunto 'visitados' para não entrar em loop infinito.

def busca_profundidade(estado_inicial, max_impressoes=15):
    """Executa a Busca em Profundidade (DFS)."""
    print("\n" + "=" * 45)
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

        # Exibe o estado da iteração conforme o enunciado
        if iteracoes <= max_impressoes:
            print(f"Iteração {iteracoes}:")
            imprimir_tabuleiro(atual)
            print()
        elif iteracoes == max_impressoes + 1:
            print("...\n")

        # Verifica se atingiu o objetivo
        if atual == OBJETIVO:
            print("Estado Final:")
            imprimir_tabuleiro(atual)
            print(f"\nNúmero de iterações para busca em profundidade N: {iteracoes}")
            return iteracoes

        # Adiciona os vizinhos na pilha
        for vizinho in reversed(gerar_sucessores(atual)):
            if vizinho not in visitados:
                visitados.add(vizinho)
                pilha.append(vizinho)

    return iteracoes


# --------------------------------------------------------------------
# 7. EXECUÇÃO PRINCIPAL
# --------------------------------------------------------------------
# Sequência clara de passos:
# 1. Gera estado inicial aleatório solúvel (via teste de inversões)
# 2. Executa a Busca em Largura (BFS)
# 3. Executa a Busca em Profundidade (DFS)
# 4. Apresenta o resumo final

if __name__ == "__main__":
    print("Iniciando resolução do 8-Puzzle...\n")

    # Passo 1: Gerar estado inicial aleatório solúvel
    estado_inicial = gerar_estado_inicial()

    # Passo 2: Executar BFS
    n_bfs = busca_largura(estado_inicial)

    # Passo 3: Executar DFS
    n_dfs = busca_profundidade(estado_inicial)

    # Passo 4: Resumo dos resultados
    print("\n" + "=" * 45)
    print("RESUMO FINAL:")
    print(f"Número de iterações para busca em largura N: {n_bfs}")
    print(f"Número de iterações para busca em profundidade N: {n_dfs}")
    print("=" * 45)
