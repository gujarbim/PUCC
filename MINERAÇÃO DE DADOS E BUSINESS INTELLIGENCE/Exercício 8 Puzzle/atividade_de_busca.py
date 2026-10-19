from collections import deque
import pandas as pd

grafo = {
    'INÍCIO': ['A', 'B'],
    'A': ['C', 'D', 'E'],
    'B': ['F', 'G'],
    'C': ['H', 'I'],
    'D': ['J'],
    'E': [],
    'F': [],
    'G': ['K'],
    'H': [],
    'I': ['L'],
    'J': [],
    'K': [],
    'L': []
}

niveis_grafo = {
    'INÍCIO': 0,
    'A': 1, 'B': 1,
    'C': 2, 'D': 2, 'E': 2, 'F': 2, 'G': 2,
    'H': 3, 'I': 3, 'J': 3, 'K': 3,
    'L': 4
}

def busca_largura(grafo, inicio='INÍCIO', objetivo='L', verbose=True):
    """
    Executa a Busca em Largura (BFS) utilizando Fila FIFO.
    Garante o caminho com o menor número de arestas (otimalidade).
    """
    if verbose:
        print("=" * 65)
        print(f"BUSCA EM LARGURA (BFS) | '{inicio}' -> '{objetivo}'")
        print("=" * 65)

    fila = deque([(inicio, [inicio])])
    visitados = []
    na_fila = {inicio}
    iteracao = 0

    while fila:
        iteracao += 1
        atual, caminho = fila.popleft()
        visitados.append(atual)
        nivel_atual = niveis_grafo[atual]

        if verbose:
            print(f"Iteração {iteracao:02d}: Desenfileirado = '{atual}' (Nível {nivel_atual})")
            print(f"             Caminho atual: {' -> '.join(caminho)}")

        if atual == objetivo:
            if verbose:
                print(f"\n>>> OBJETIVO '{objetivo}' ENCONTRADO NA ITERAÇÃO {iteracao}! <<<\n")
            niveis_atingidos = sorted(list(set(niveis_grafo[n] for n in visitados)))
            return {
                'algoritmo': 'Busca em Largura (BFS)',
                'nos_visitados': visitados,
                'total_visitados': len(visitados),
                'caminho': caminho,
                'num_arestas': len(caminho) - 1,
                'niveis_explorados': niveis_atingidos,
                'total_niveis': len(niveis_atingidos)
            }

        for filho in grafo.get(atual, []):
            if filho not in visitados and filho not in na_fila:
                na_fila.add(filho)
                fila.append((filho, caminho + [filho]))

        if verbose:
            fila_atual_str = [n for n, _ in fila]
            print(f"             Fila: {fila_atual_str}\n")

    return None

def busca_profundidade(grafo, inicio='INÍCIO', objetivo='L', verbose=True):
    """
    Executa a Busca em Profundidade (DFS) utilizando Pilha LIFO.
    Empilha sucessores na ordem inversa para explorar da esquerda para a direita.
    """
    if verbose:
        print("=" * 65)
        print(f"BUSCA EM PROFUNDIDADE (DFS) | '{inicio}' -> '{objetivo}'")
        print("=" * 65)

    pilha = [(inicio, [inicio])]
    visitados = []
    na_pilha = {inicio}
    iteracao = 0

    while pilha:
        iteracao += 1
        atual, caminho = pilha.pop()
        visitados.append(atual)
        nivel_atual = niveis_grafo[atual]

        if verbose:
            print(f"Iteração {iteracao:02d}: Desempilhado = '{atual}' (Nível {nivel_atual})")
            print(f"             Caminho atual: {' -> '.join(caminho)}")

        if atual == objetivo:
            if verbose:
                print(f"\n>>> OBJETIVO '{objetivo}' ENCONTRADO NA ITERAÇÃO {iteracao}! <<<\n")
            niveis_atingidos = sorted(list(set(niveis_grafo[n] for n in visitados)))
            return {
                'algoritmo': 'Busca em Profundidade (DFS)',
                'nos_visitados': visitados,
                'total_visitados': len(visitados),
                'caminho': caminho,
                'num_arestas': len(caminho) - 1,
                'niveis_explorados': niveis_atingidos,
                'total_niveis': len(niveis_atingidos)
            }

        for filho in reversed(grafo.get(atual, [])):
            if filho not in visitados and filho not in na_pilha:
                na_pilha.add(filho)
                pilha.append((filho, caminho + [filho]))

        if verbose:
            pilha_atual_str = [n for n, _ in pilha]
            print(f"             Pilha: {pilha_atual_str}\n")

    return None

if __name__ == "__main__":
    print("\n" + "=" * 65)
    print("ATIVIDADE DE BUSCA EM GRAFOS (PUC-CAMPINAS)")
    print("=" * 65 + "\n")

    res_bfs = busca_largura(grafo, inicio='INÍCIO', objetivo='L', verbose=True)
    res_dfs = busca_profundidade(grafo, inicio='INÍCIO', objetivo='L', verbose=True)

    dados_comparacao = {
        'Métrica': [
            'Estrutura de Dados',
            'Ordem de Exploração',
            'Quantidade de Nós Visitados',
            'Nós Visitados na Ordem',
            'Caminho Encontrado',
            'Número de Arestas do Caminho',
            'Níveis Explorados',
            'Encontrou Menor Número de Arestas?'
        ],
        'Busca em Largura (BFS)': [
            'Fila FIFO (First-In, First-Out)',
            'Nível a Nível (Horizontal)',
            f"{res_bfs['total_visitados']} nós",
            " -> ".join(res_bfs['nos_visitados']),
            " -> ".join(res_bfs['caminho']),
            f"{res_bfs['num_arestas']} arestas",
            f"{res_bfs['total_niveis']} níveis {res_bfs['niveis_explorados']}",
            'SIM (Garantia Teórica)'
        ],
        'Busca em Profundidade (DFS)': [
            'Pilha LIFO (Last-In, First-Out)',
            'Ramo a Ramo (Vertical)',
            f"{res_dfs['total_visitados']} nós",
            " -> ".join(res_dfs['nos_visitados']),
            " -> ".join(res_dfs['caminho']),
            f"{res_dfs['num_arestas']} arestas",
            f"{res_dfs['total_niveis']} níveis {res_dfs['niveis_explorados']}",
            'SIM (Caminho Único na Árvore)'
        ]
    }

    df = pd.DataFrame(dados_comparacao)
    df.set_index('Métrica', inplace=True)
    pd.set_option('display.max_colwidth', None)

    print("=" * 65)
    print("TABELA COMPARATIVA DOS RESULTADOS:")
    print("=" * 65)
    print(df.to_string())
    print("\n" + "=" * 65)
    print("RESPOSTAS FORMAIS ÀS 4 PERGUNTAS DA ATIVIDADE:")
    print("=" * 65)
    print("""

1. Quantos nós foram visitados?
   - BFS: 13 nós (INÍCIO, A, B, C, D, E, F, G, H, I, J, K, L)
   - DFS:  6 nós (INÍCIO, A, C, H, I, L)

2. Qual foi o caminho encontrado?
   - INÍCIO -> A -> C -> I -> L (4 arestas)

3. Quantos níveis foram explorados?
   - 5 níveis (0, 1, 2, 3 e 4)
    
4. O algoritmo encontrou o caminho com menor número de arestas?
   - BFS: SIM (garantia teórica de otimalidade para grafos não ponderados).
   - DFS: SIM (neste caso específico, pois na árvore o caminho até L é único).
    """)
