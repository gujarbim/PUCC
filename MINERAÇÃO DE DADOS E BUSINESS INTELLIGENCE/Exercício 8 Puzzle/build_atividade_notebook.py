import json
import io
import sys
import uuid

def build_and_execute_notebook():
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
                "version": "3.14.0"
            }
        },
        "nbformat": 4,
        "nbformat_minor": 5
    }

    def md_cell(source):
        return {
            "cell_type": "markdown",
            "id": uuid.uuid4().hex[:8],
            "metadata": {},
            "source": [line + "\n" for line in source.strip().split("\n")]
        }

    # Ambiente de execução compartilhado para as células
    exec_globals = {}
    cell_counter = [1]

    def code_cell(source):
        cell_id = uuid.uuid4().hex[:8]
        count = cell_counter[0]
        cell_counter[0] += 1
        
        # Executar código e capturar stdout
        old_stdout = sys.stdout
        redirected_output = io.StringIO()
        sys.stdout = redirected_output
        try:
            exec(source, exec_globals)
        except Exception as e:
            print(f"Erro na execução da célula: {e}")
        finally:
            sys.stdout = old_stdout
            
        output_text = redirected_output.getvalue()
        outputs = []
        if output_text:
            outputs.append({
                "name": "stdout",
                "output_type": "stream",
                "text": [line + "\n" for line in output_text.rstrip("\n").split("\n")]
            })

        return {
            "cell_type": "code",
            "execution_count": count,
            "id": cell_id,
            "metadata": {},
            "outputs": outputs,
            "source": [line + "\n" for line in source.strip().split("\n")]
        }

    # =========================================================================
    # 1. Cabeçalho Acadêmico
    # =========================================================================
    nb["cells"].append(md_cell("""# Atividade de Busca em Grafos: BFS e DFS
**Disciplina:** Mineração de Dados e Business Intelligence / Inteligência Artificial  
**Instituição:** Pontifícia Universidade Católica de Campinas (PUC-Campinas)  
**Professor:** Fernando H. C. Silva  

---

### Integrantes do Grupo:
- **Aluno 1:** [Nome Completo do Aluno 1] - **RA:** [00000000]
- **Aluno 2:** [Nome Completo do Aluno 2] - **RA:** [00000000]
- **Aluno 3:** [Nome Completo do Aluno 3] - **RA:** [00000000] *(Opcional)*

---

### Enunciado da Atividade:
Dado o grafo abaixo, gere uma representação do grafo em Python, aplique os algoritmos de busca vistos em aula (**Busca em Largura - BFS** e **Busca em Profundidade - DFS**) e responda para cada um desses:

1. **Quantos nós foram visitados?**
2. **Qual foi o caminho encontrado?**
3. **Quantos níveis foram explorados?**
4. **O algoritmo encontrou o caminho com menor número de arestas?**"""))

    # =========================================================================
    # 2. Estrutura do Grafo
    # =========================================================================
    nb["cells"].append(md_cell("""## 1. Estrutura e Topologia do Grafo

O grafo fornecido no enunciado possui estrutura de árvore hierárquica enraizada no nó `INÍCIO`, com 13 vértices ao todo:

```text
       INÍCIO
       /    \\
      A      B
    / | \\   / \\
   C  D  E F   G
  / \\ |        |
 H   I J       K
     |
     L
```

### Distribuição dos Nós por Níveis (Profundidade em relação à Raiz):
- **Nível 0:** `INÍCIO` (Raiz)
- **Nível 1:** `A`, `B`
- **Nível 2:** `C`, `D`, `E`, `F`, `G`
- **Nível 3:** `H`, `I`, `J`, `K`
- **Nível 4:** `L` (Folha mais profunda)

### Parâmetros da Busca:
- **Nó de Origem (Início):** `INÍCIO`
- **Nó Objetivo (Meta):** `L` (o nó folha mais profundo, localizado no nível 4)"""))

    # =========================================================================
    # 3. Representação do Grafo em Python
    # =========================================================================
    nb["cells"].append(md_cell("""## 2. Representação do Grafo em Python

Representamos o grafo utilizando uma **Lista de Adjacências** implementada através de um dicionário (`dict`) em Python. Cada chave representa um nó e o valor correspondente é a lista ordenada de seus sucessores/filhos (da esquerda para a direita conforme o diagrama)."""))

    nb["cells"].append(code_cell("""# Representação do Grafo por Lista de Adjacências (Dicionário de Listas)
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

# Mapeamento do nível (profundidade) de cada nó na árvore
niveis_grafo = {
    'INÍCIO': 0,
    'A': 1, 'B': 1,
    'C': 2, 'D': 2, 'E': 2, 'F': 2, 'G': 2,
    'H': 3, 'I': 3, 'J': 3, 'K': 3,
    'L': 4
}

print("=" * 60)
print("ESTRUTURA DO GRAFO CARREGADA:")
print("=" * 60)
for no, vizinhos in grafo.items():
    filhos_str = ", ".join(vizinhos) if vizinhos else "Nenhum (Nó folha)"
    print(f"• Nó {no:<7} | Nível {niveis_grafo[no]} | Filhos: [{filhos_str}]")"""))

    # =========================================================================
    # 4. Teoria e Implementação BFS
    # =========================================================================
    nb["cells"].append(md_cell("""## 3. Busca em Largura (Breadth-First Search - BFS)

### Conceito e Funcionamento:
A **Busca em Largura (BFS)** explora o espaço de estados de forma sistemática por **camadas / níveis**. Ela visita todos os nós no nível $d$ antes de visitar qualquer nó no nível $d+1$.

- **Estrutura de Dados:** Utiliza uma **Fila FIFO (First-In, First-Out)** (`collections.deque`).
- **Garantia de Otimalidade:** Em grafos com custos uniformes por aresta (como este grafo não ponderado), a BFS **garante encontrar a solução com o menor número de arestas**.
- **Critério de Parada:** O teste de objetivo é realizado quando o nó é retirado da fila para ser expandido."""))

    nb["cells"].append(code_cell("""from collections import deque

def busca_largura(grafo, inicio='INÍCIO', objetivo='L', verbose=True):
    \"\"\"
    Executa a Busca em Largura (BFS) a partir de um nó inicial até o objetivo.
    
    Retorna um dicionário com:
    - nos_visitados: ordem em que os nós foram visitados/expandidos
    - total_visitados: quantidade total de nós visitados
    - caminho: sequência de nós do início até o objetivo
    - num_arestas: total de arestas percorridas no caminho final
    - niveis_explorados: lista com todos os níveis explorados
    - total_niveis: quantidade total de níveis explorados
    \"\"\"
    if verbose:
        print("=" * 65)
        print(f"EXECUÇÃO: BUSCA EM LARGURA (BFS) | '{inicio}' -> '{objetivo}'")
        print("=" * 65)
        
    # Fila armazena tuplas: (nó_atual, caminho_percorrido_até_ele)
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
            print(f"Iteração {iteracao:02d}: Nó Desenfileirado = '{atual}' (Nível {nivel_atual})")
            print(f"             Caminho até aqui: {' -> '.join(caminho)}")

        # Verificação do objetivo
        if atual == objetivo:
            if verbose:
                print(f"\\n>>> OBJETIVO '{objetivo}' ENCONTRADO NA ITERAÇÃO {iteracao}! <<<\\n")
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

        # Expansão dos sucessores
        for filho in grafo.get(atual, []):
            if filho not in visitados and filho not in na_fila:
                na_fila.add(filho)
                fila.append((filho, caminho + [filho]))
                
        if verbose:
            fila_atual_str = [n for n, _ in fila]
            print(f"             Fila após expansão: {fila_atual_str}\\n")

    return None

# Executando a Busca em Largura (BFS)
resultado_bfs = busca_largura(grafo, inicio='INÍCIO', objetivo='L', verbose=True)

print("=" * 65)
print("RESUMO DA BUSCA EM LARGURA (BFS):")
print(f"• Nós visitados ({resultado_bfs['total_visitados']}): {resultado_bfs['nos_visitados']}")
print(f"• Caminho encontrado: {' -> '.join(resultado_bfs['caminho'])}")
print(f"• Número de arestas: {resultado_bfs['num_arestas']}")
print(f"• Níveis explorados ({resultado_bfs['total_niveis']}): {resultado_bfs['niveis_explorados']}")
print("=" * 65)"""))

    # =========================================================================
    # 5. Teoria e Implementação DFS
    # =========================================================================
    nb["cells"].append(md_cell("""## 4. Busca em Profundidade (Depth-First Search - DFS)

### Conceito e Funcionamento:
A **Busca em Profundidade (DFS)** aprofunda-se o máximo possível ao longo de cada ramo antes de realizar o retrocesso (*backtracking*). Ela segue o ramo esquerdo até um nó folha ou beco sem saída, e então volta ao nó ancestral com alternativas não exploradas.

- **Estrutura de Dados:** Utiliza uma **Pilha LIFO (Last-In, First-Out)** (`list`).
- **Ordem de Inserção na Pilha:** Para visitar os filhos na ordem natural da esquerda para a direita (como `C`, `D`, `E`), os nós são inseridos na pilha em ordem invertida (`reversed`), garantindo que o filho mais à esquerda seja o primeiro a ser desempilhado no próximo passo.
- **Garantia de Otimalidade:** A DFS **não garante** encontrar o caminho com menor número de arestas em grafos gerais. No entanto, em árvores onde há caminho único entre a raiz e a folha objetivo, o caminho encontrado coincide com o único caminho existente."""))

    nb["cells"].append(code_cell("""def busca_profundidade(grafo, inicio='INÍCIO', objetivo='L', verbose=True):
    \"\"\"
    Executa a Busca em Profundidade (DFS) a partir de um nó inicial até o objetivo.
    
    Retorna um dicionário com:
    - nos_visitados: ordem em que os nós foram visitados/expandidos
    - total_visitados: quantidade total de nós visitados
    - caminho: sequência de nós do início até o objetivo
    - num_arestas: total de arestas percorridas no caminho final
    - niveis_explorados: lista com todos os níveis explorados
    - total_niveis: quantidade total de níveis explorados
    \"\"\"
    if verbose:
        print("=" * 65)
        print(f"EXECUÇÃO: BUSCA EM PROFUNDIDADE (DFS) | '{inicio}' -> '{objetivo}'")
        print("=" * 65)

    # Pilha armazena tuplas: (nó_atual, caminho_percorrido_até_ele)
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
            print(f"Iteração {iteracao:02d}: Nó Desempilhado = '{atual}' (Nível {nivel_atual})")
            print(f"             Caminho até aqui: {' -> '.join(caminho)}")

        # Verificação do objetivo
        if atual == objetivo:
            if verbose:
                print(f"\\n>>> OBJETIVO '{objetivo}' ENCONTRADO NA ITERAÇÃO {iteracao}! <<<\\n")
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

        # Expansão dos sucessores (ordem invertida na pilha para manter navegação esquerda -> direita)
        sucessores = grafo.get(atual, [])
        for filho in reversed(sucessores):
            if filho not in visitados and filho not in na_pilha:
                na_pilha.add(filho)
                pilha.append((filho, caminho + [filho]))

        if verbose:
            pilha_atual_str = [n for n, _ in pilha]
            print(f"             Pilha após expansão: {pilha_atual_str}\\n")

    return None

# Executando a Busca em Profundidade (DFS)
resultado_dfs = busca_profundidade(grafo, inicio='INÍCIO', objetivo='L', verbose=True)

print("=" * 65)
print("RESUMO DA BUSCA EM PROFUNDIDADE (DFS):")
print(f"• Nós visitados ({resultado_dfs['total_visitados']}): {resultado_dfs['nos_visitados']}")
print(f"• Caminho encontrado: {' -> '.join(resultado_dfs['caminho'])}")
print(f"• Número de arestas: {resultado_dfs['num_arestas']}")
print(f"• Níveis explorados ({resultado_dfs['total_niveis']}): {resultado_dfs['niveis_explorados']}")
print("=" * 65)"""))

    # =========================================================================
    # 6. Tabela Comparativa de Resultados
    # =========================================================================
    nb["cells"].append(md_cell("""## 5. Tabela Comparativa de Resultados

Abaixo apresentamos o comparativo lado a lado entre os dois algoritmos executados com o objetivo `L`:"""))

    nb["cells"].append(code_cell("""import pandas as pd

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
        f"{resultado_bfs['total_visitados']} nós",
        " -> ".join(resultado_bfs['nos_visitados']),
        " -> ".join(resultado_bfs['caminho']),
        f"{resultado_bfs['num_arestas']} arestas",
        f"{resultado_bfs['total_niveis']} níveis {resultado_bfs['niveis_explorados']}",
        'SIM (Garantia Teórica)'
    ],
    'Busca em Profundidade (DFS)': [
        'Pilha LIFO (Last-In, First-Out)',
        'Ramo a Ramo (Vertical)',
        f"{resultado_dfs['total_visitados']} nós",
        " -> ".join(resultado_dfs['nos_visitados']),
        " -> ".join(resultado_dfs['caminho']),
        f"{resultado_dfs['num_arestas']} arestas",
        f"{resultado_dfs['total_niveis']} níveis {resultado_dfs['niveis_explorados']}",
        'SIM (Caminho Único na Árvore)'
    ]
}

df_comparativo = pd.DataFrame(dados_comparacao)
df_comparativo.set_index('Métrica', inplace=True)
pd.set_option('display.max_colwidth', None)
print(df_comparativo.to_string())"""))

    # =========================================================================
    # 7. Respostas Formais às 4 Perguntas
    # =========================================================================
    nb["cells"].append(md_cell("""## 6. Respostas Formais às Perguntas da Atividade

Com base nas execuções realizadas para o nó objetivo **`L`**, respondemos pontualmente a cada uma das 4 questões formuladas pelo professor:

---

### Pergunta 1: Quantos nós foram visitados?

* **Busca em Largura (BFS):** **13 nós visitados.**  
  * **Sequência de visitação:** `INÍCIO` $\\rightarrow$ `A` $\\rightarrow$ `B` $\\rightarrow$ `C` $\\rightarrow$ `D` $\\rightarrow$ `E` $\\rightarrow$ `F` $\\rightarrow$ `G` $\\rightarrow$ `H` $\\rightarrow$ `I` $\\rightarrow$ `J` $\\rightarrow$ `K` $\\rightarrow$ `L`.  
  * *Explicação:* Por operar em largura, a BFS visitou todos os nós dos níveis 0, 1 e 2, e os nós `H`, `I`, `J`, `K` do nível 3 antes de desenfileirar e encontrar o nó `L` no nível 4.

* **Busca em Profundidade (DFS):** **6 nós visitados.**  
  * **Sequência de visitação:** `INÍCIO` $\\rightarrow$ `A` $\\rightarrow$ `C` $\\rightarrow$ `H` $\\rightarrow$ `I` $\\rightarrow$ `L`.  
  * *Explicação:* A DFS desceu diretamente pelo primeiro ramo à esquerda (`A` $\\rightarrow$ `C`). Ao chegar na folha `H`, fez backtracking imediato para `C`, desceu para `I` e em seguida encontrou diretamente o nó `L`, sem precisar explorar os ramos de `D`, `E` e `B`.

---

### Pergunta 2: Qual foi o caminho encontrado?

* **Busca em Largura (BFS):**  
  $$\\mathbf{INÍCIO \\rightarrow A \\rightarrow C \\rightarrow I \\rightarrow L}$$  
  * O caminho é composto por **4 arestas** (saltos).

* **Busca em Profundidade (DFS):**  
  $$\\mathbf{INÍCIO \\rightarrow A \\rightarrow C \\rightarrow I \\rightarrow L}$$  
  * O caminho é composto por **4 arestas** (saltos).

---

### Pergunta 3: Quantos níveis foram explorados?

* **Busca em Largura (BFS):** **5 níveis explorados** (Níveis 0, 1, 2, 3 e 4).  
  * A BFS explorou exaustivamente todos os nós dos níveis 0, 1, 2 e 3, alcançando a profundidade máxima no nível 4 ao encontrar `L`.

* **Busca em Profundidade (DFS):** **5 níveis explorados** (Níveis 0, 1, 2, 3 e 4).  
  * Embora a DFS tenha visitado menos nós no total, ela navegou verticalmente pelo caminho `INÍCIO` (0) $\\rightarrow$ `A` (1) $\\rightarrow$ `C` (2) $\\rightarrow$ `H`/`I` (3) $\\rightarrow$ `L` (4), atingindo todos os 5 níveis de profundidade da árvore.

---

### Pergunta 4: O algoritmo encontrou o caminho com menor número de arestas?

* **Busca em Largura (BFS):** **SIM.**  
  * **Justificativa Teórica:** A BFS possui a propriedade de **otimalidade** para grafos não ponderados (custo uniforme de 1 por aresta). Ela sempre garante encontrar o caminho com o menor número possível de arestas até qualquer objetivo. O caminho de 4 arestas é o mínimo absoluto até `L`.

* **Busca em Profundidade (DFS):** **SIM (neste caso específico).**  
  * **Justificativa Teórica:** Em grafos gerais, a DFS **NÃO garante** encontrar o caminho com menor número de arestas, pois pode aprofundar-se em um caminho muito longo antes de testar caminhos mais curtos. Porém, no grafo proposto (uma árvore direcionada sem ciclos ou caminhos redundantes alternativos), **existe apenas um único caminho possível entre a raiz e cada nó folha**. Como só existe esse único caminho até `L`, o caminho encontrado pelo DFS foi, obrigatoriamente, o de menor número de arestas (4 arestas)."""))

    # =========================================================================
    # 8. Análise Complementar com Outros Objetivos
    # =========================================================================
    nb["cells"].append(md_cell("""## 7. Análise Complementar: Comparação com Outros Objetivos (Bônus)

Para demonstrar a versatilidade da implementação e comprovar o contraste teórico entre BFS e DFS, criamos uma função que permite testar qualquer outro nó como meta (por exemplo, os nós `'G'`, `'K'` ou `'J'`):"""))

    nb["cells"].append(code_cell("""def comparar_buscas(grafo, inicio='INÍCIO', objetivo='G'):
    \"\"\"Compara BFS e DFS para qualquer nó objetivo de forma sucinta.\"\"\"
    b = busca_largura(grafo, inicio=inicio, objetivo=objetivo, verbose=False)
    d = busca_profundidade(grafo, inicio=inicio, objetivo=objetivo, verbose=False)
    
    print(f"============================================================")
    print(f"COMPARAÇÃO PARA OBJETIVO: '{objetivo}'")
    print(f"============================================================")
    print(f"• BFS -> {b['total_visitados']:2d} nós visitados | Caminho: {' -> '.join(b['caminho'])} ({b['num_arestas']} arestas)")
    print(f"• DFS -> {d['total_visitados']:2d} nós visitados | Caminho: {' -> '.join(d['caminho'])} ({d['num_arestas']} arestas)")
    print()

# Testando com o nó 'G' (localizado no ramo direito, nível 2):
comparar_buscas(grafo, objetivo='G')

# Testando com o nó 'K' (filho de G no ramo direito, nível 3):
comparar_buscas(grafo, objetivo='K')

# Testando com o nó 'J' (filho de D no nível 3):
comparar_buscas(grafo, objetivo='J')"""))

    # =========================================================================
    # 9. Conclusão Geral
    # =========================================================================
    nb["cells"].append(md_cell("""## 8. Conclusão Geral

A atividade prática permitiu validar em código as principais propriedades teóricas dos algoritmos de busca não-informada vistos em sala de aula:

1. **Eficiência no Caso do Nó `L`:** Como `L` estava localizado na extrema esquerda da base da árvore, a **DFS** obteve uma eficiência significativamente superior em termos de quantidade de nós visitados (**6 nós** contra **13 nós** da BFS), economizando expansões desnecessárias no ramo direito.
2. **Contraste no Ramo Direito:** Quando testamos objetivos localizados à direita (como `'G'` ou `'K'`), a situação se inverte: a **BFS** encontra o objetivo com muito menos nós visitados, enquanto a **DFS** precisa esgotar primeiro todo o ramo esquerdo por backtracking.
3. **Otimalidade:** A **BFS** comprovou sua garantia matemática de encontrar o caminho ótimo em número de arestas, enquanto a **DFS** atingiu o mesmo caminho ótimo devido à topologia em árvore que restringe a existência a caminhos únicos."""))

    return nb

if __name__ == '__main__':
    notebook_dict = build_and_execute_notebook()
    output_path = r'c:\DEV\PUC\MINERAÇÃO DE DADOS E BUSINESS INTELLIGENCE\Exercício 8 Puzzle\atividade_de_busca.ipynb'
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(notebook_dict, f, indent=1, ensure_ascii=False)
    print(f"Notebook gerado e pré-executado com sucesso em: {output_path}")
