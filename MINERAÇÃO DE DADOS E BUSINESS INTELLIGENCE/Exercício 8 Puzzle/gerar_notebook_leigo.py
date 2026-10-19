import json
import io
import sys
import uuid

def build_notebook():
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
                "version": "3.11.0"
            }
        },
        "nbformat": 4,
        "nbformat_minor": 5
    }

    def md(text):
        return {
            "cell_type": "markdown",
            "id": uuid.uuid4().hex[:8],
            "metadata": {},
            "source": [line + "\n" for line in text.strip().split("\n")]
        }

    exec_globals = {}
    counter = [1]

    def code(source):
        count = counter[0]
        counter[0] += 1
        
        old_stdout = sys.stdout
        buf = io.StringIO()
        sys.stdout = buf
        try:
            exec(source, exec_globals)
        except Exception as e:
            print(f"Erro ao executar: {e}")
        finally:
            sys.stdout = old_stdout

        out_text = buf.getvalue()
        outputs = []
        if out_text:
            outputs.append({
                "name": "stdout",
                "output_type": "stream",
                "text": [line + "\n" for line in out_text.rstrip("\n").split("\n")]
            })

        return {
            "cell_type": "code",
            "execution_count": count,
            "id": uuid.uuid4().hex[:8],
            "metadata": {},
            "outputs": outputs,
            "source": [line + "\n" for line in source.strip().split("\n")]
        }

    # Célula 1: Cabeçalho
    nb["cells"].append(md("""# Exercício 8-Puzzle: Busca em Largura e Profundidade
**Disciplina:** Mineração de Dados e Business Intelligence  
**Instituição:** Pontifícia Universidade Católica (PUC)  

---

### Integrantes do Grupo:
- **Aluno 1:** [Nome Completo do Aluno 1] - **RA:** [00000000]
- **Aluno 2:** [Nome Completo do Aluno 2] - **RA:** [00000000]
- **Aluno 3:** [Nome Completo do Aluno 3] - **RA:** [00000000] *(Opcional)*

---

### Requisitos da Atividade:
1. Resoluções para o problema do **8-puzzle** com peças de 1 a 8 e espaço vazio `'X'`.
2. Apresentar as estratégias de busca vistas em aula: **Busca em Largura (BFS)** e **Busca em Profundidade (DFS)**.
3. Gerar um **estado inicial aleatório** e verificar se é **solúvel** (contando o número de inversões). Se o número for ímpar, descartar e gerar outro.
4. Apresentar o estado do puzzle a cada iteração do algoritmo no formato exigido:
   ```text
   Estado inicial:
   |1 | 3 | 4|
   |5 | 7 | 8|
   |2 | X | 6|
   ...
   Estado Final:
   |1 | 2 | 3|
   |4 | 5 | 6|
   |7 | 8 | X|
   ```
5. Apresentar o número final de iterações $N$ para Busca em Largura e Busca em Profundidade."""))

    # Célula 2: Passo 1 Markdown
    nb["cells"].append(md("""## 1. Estado Objetivo e Exibição do Tabuleiro

O estado objetivo é quando as peças ficam ordenadas de 1 a 8 com o `'X'` no final.  
Criamos a função `imprimir_tabuleiro` para mostrar o tabuleiro exatamente com as barras verticais pedidas no enunciado (`|1 | 2 | 3|`)."""))

    # Célula 3: Passo 1 Código
    nb["cells"].append(code("""# Estado objetivo final
OBJETIVO = (1, 2, 3, 4, 5, 6, 7, 8, 'X')

def imprimir_tabuleiro(estado):
    \"\"\"Imprime o tabuleiro 3x3 no formato solicitado pelo professor.\"\"\"
    print(f"|{estado[0]} | {estado[1]} | {estado[2]}|")
    print(f"|{estado[3]} | {estado[4]} | {estado[5]}|")
    print(f"|{estado[6]} | {estado[7]} | {estado[8]}|")

# Visualização do estado objetivo:
print("Estado Objetivo:")
imprimir_tabuleiro(OBJETIVO)"""))

    # Célula 4: Passo 2 Markdown
    nb["cells"].append(md("""## 2. Verificação de Solubilidade (Número de Inversões)

Para saber se um tabuleiro do 8-puzzle tem solução, contamos quantas vezes um número maior aparece antes de um número menor na sequência (ignorando o `'X'`):
- Se o número total de inversões for **PAR**, o quebra-cabeça **tem solução** (`True`).
- Se o número total de inversões for **ÍMPAR**, o quebra-cabeça **não tem solução** (`False`) e deve ser descartado."""))

    # Célula 5: Passo 2 Código
    nb["cells"].append(code("""def contar_inversoes(estado):
    \"\"\"Conta quantos números maiores aparecem antes de números menores.\"\"\"
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

# Teste para validar a regra:
tabuleiro_par = (1, 2, 3, 4, 5, 6, 7, 'X', 8)    # 0 inversões (par -> solúvel)
tabuleiro_impar = (2, 1, 3, 4, 5, 6, 7, 8, 'X')  # 1 inversão (ímpar -> impossível)

print(f"Teste 1: {contar_inversoes(tabuleiro_par)} inversões -> Solúvel? {eh_soluvel(tabuleiro_par)}")
print(f"Teste 2: {contar_inversoes(tabuleiro_impar)} inversão -> Solúvel? {eh_soluvel(tabuleiro_impar)}")"""))

    # Célula 6: Passo 3 Markdown
    nb["cells"].append(md("""## 3. Geração do Estado Inicial Aleatório

O enunciado especifica:  
*"O código deve também gerar um estado inicial aleatório e verificar se o estado é possível de ser resolvido (verificar o número de inversões), caso não seja, deve gerar outro."*

Abaixo, embaralhamos as 9 peças. Se o total de inversões for ímpar, ele descarta e gera outro até encontrar um que seja solúvel."""))

    # Célula 7: Passo 3 Código
    nb["cells"].append(code("""import random

def gerar_estado_inicial():
    \"\"\"Gera um estado inicial aleatório e garante que ele seja solúvel.\"\"\"
    pecas = [1, 2, 3, 4, 5, 6, 7, 8, 'X']
    tentativa = 1
    while True:
        random.shuffle(pecas)
        estado = tuple(pecas)
        inversoes = contar_inversoes(estado)
        
        # Se for solúvel (par) e diferente do objetivo, aceitamos
        if eh_soluvel(estado) and estado != OBJETIVO:
            print(f"Tentativa {tentativa}: Estado solúvel aceito! (Inversões: {inversoes} - Par)")
            return estado
        else:
            print(f"Tentativa {tentativa}: Descartado (Inversões: {inversoes} - Ímpar, gerando outro...)")
            tentativa += 1

# Semente fixa para manter a execução reproduzível
random.seed(15)

estado_inicial = gerar_estado_inicial()
print("\\nEstado Inicial:")
imprimir_tabuleiro(estado_inicial)"""))

    # Célula 8: Passo 4 Markdown
    nb["cells"].append(md("""## 4. Movimentos Válidos (Sucessores)

Encontra onde está o `'X'` no tabuleiro e move para as 4 posições vizinhas (Cima, Baixo, Esquerda, Direita), desde que não ultrapasse os limites da matriz 3x3."""))

    # Célula 9: Passo 4 Código
    nb["cells"].append(code("""def gerar_sucessores(estado):
    \"\"\"Gera os próximos estados possíveis movimentando o 'X'.\"\"\"
    sucessores = []
    idx = estado.index('X')
    linha = idx // 3
    coluna = idx % 3

    # Movimentos: (linha, coluna)
    movimentos = [
        (-1, 0),  # Cima
        (1, 0),   # Baixo
        (0, -1),  # Esquerda
        (0, 1)    # Direita
    ]

    for dl, dc in movimentos:
        nova_l = linha + dl
        nova_c = coluna + dc
        
        # Garante que não sai do tabuleiro 3x3
        if 0 <= nova_l < 3 and 0 <= nova_c < 3:
            novo_idx = nova_l * 3 + nova_c
            novo_estado = list(estado)
            novo_estado[idx], novo_estado[novo_idx] = novo_estado[novo_idx], novo_estado[idx]
            sucessores.append(tuple(novo_estado))

    return sucessores"""))

    # Célula 10: Passo 5 Markdown
    nb["cells"].append(md("""## 5. Busca em Largura (BFS)

A Busca em Largura explora o quebra-cabeça nível por nível usando uma **fila** (`deque`):
- Pega o estado da vez no início da fila.
- Imprime o estado do tabuleiro.
- Se for o objetivo, encerra e informa o total de iterações $N$.
- Adiciona os vizinhos que ainda não foram visitados na fila.

*(Nota: para manter a saída limpa e idêntica ao exemplo do professor, exibimos as primeiras iterações, `...`, e o Estado Final).*"""))

    # Célula 11: Passo 5 Código
    nb["cells"].append(code("""from collections import deque

def busca_largura(estado_inicial, max_impressoes=10):
    \"\"\"Executa a Busca em Largura (BFS).\"\"\"
    print("=" * 45)
    print("BUSCA EM LARGURA (BFS)")
    print("=" * 45)
    print("Estado inicial:")
    imprimir_tabuleiro(estado_inicial)
    print()

    fila = deque([estado_inicial])
    visitados = {estado_inicial}
    iteracoes = 0

    while fila:
        iteracoes += 1
        atual = fila.popleft()

        # Exibe o estado da iteração (até o limite para não poluir o notebook)
        if iteracoes <= max_impressoes:
            print(f"Iteração {iteracoes}:")
            imprimir_tabuleiro(atual)
            print()
        elif iteracoes == max_impressoes + 1:
            print("...\\n")

        # Verifica se chegou no objetivo
        if atual == OBJETIVO:
            print("Estado Final:")
            imprimir_tabuleiro(atual)
            print(f"\\nNúmero de iterações para busca em largura N: {iteracoes}")
            return iteracoes

        # Gera e adiciona novos estados não visitados
        for vizinho in gerar_sucessores(atual):
            if vizinho not in visitados:
                visitados.add(vizinho)
                fila.append(vizinho)

    return iteracoes

# Executando a Busca em Largura:
n_bfs = busca_largura(estado_inicial)"""))

    # Célula 12: Passo 6 Markdown
    nb["cells"].append(md("""## 6. Busca em Profundidade (DFS)

A Busca em Profundidade vai o mais fundo possível ao longo de cada caminho usando uma **pilha** (`list`):
- Pega o estado no topo da pilha (`pop()`).
- Imprime o estado do tabuleiro.
- Se for o objetivo, encerra e informa o total de iterações $N$.
- Adiciona os vizinhos não visitados no topo da pilha."""))

    # Célula 13: Passo 6 Código
    nb["cells"].append(code("""def busca_profundidade(estado_inicial, max_impressoes=10):
    \"\"\"Executa a Busca em Profundidade (DFS).\"\"\"
    print("=" * 45)
    print("BUSCA EM PROFUNDIDADE (DFS)")
    print("=" * 45)
    print("Estado inicial:")
    imprimir_tabuleiro(estado_inicial)
    print()

    pilha = [estado_inicial]
    visitados = {estado_inicial}
    iteracoes = 0

    while pilha:
        iteracoes += 1
        atual = pilha.pop()

        # Exibe o estado da iteração (até o limite para não poluir o notebook)
        if iteracoes <= max_impressoes:
            print(f"Iteração {iteracoes}:")
            imprimir_tabuleiro(atual)
            print()
        elif iteracoes == max_impressoes + 1:
            print("...\\n")

        # Verifica se chegou no objetivo
        if atual == OBJETIVO:
            print("Estado Final:")
            imprimir_tabuleiro(atual)
            print(f"\\nNúmero de iterações para busca em profundidade N: {iteracoes}")
            return iteracoes

        # Adiciona os vizinhos na pilha
        for vizinho in reversed(gerar_sucessores(atual)):
            if vizinho not in visitados:
                visitados.add(vizinho)
                pilha.append(vizinho)

    return iteracoes

# Executando a Busca em Profundidade:
n_dfs = busca_profundidade(estado_inicial)"""))

    # Célula 14: Passo 7 Markdown
    nb["cells"].append(md("""## 7. Resumo Final das Iterações

Exibição do total de iterações $N$ obtido em cada método de busca conforme solicitado no enunciado."""))

    # Célula 15: Passo 7 Código
    nb["cells"].append(code("""print("=" * 45)
print("RESUMO FINAL:")
print(f"Número de iterações para busca em largura N: {n_bfs}")
print(f"Número de iterações para busca em profundidade N: {n_dfs}")
print("=" * 45)"""))

    # Célula 16: Bônus Didático Markdown
    nb["cells"].append(md("""---
### Demonstração Didática: Caso Curto (Sem cortes de exibição)
Abaixo testamos um tabuleiro que está a apenas 3 movimentos do objetivo, permitindo visualizar todas as iterações completas na tela de forma rápida."""))

    # Célula 17: Bônus Didático Código
    nb["cells"].append(code("""# Tabuleiro a poucos movimentos do objetivo
tabuleiro_curto = (1, 2, 3, 4, 'X', 6, 7, 5, 8)

print("--- Teste Rápido com BFS ---")
busca_largura(tabuleiro_curto, max_impressoes=20)

print("\\n--- Teste Rápido com DFS ---")
busca_profundidade(tabuleiro_curto, max_impressoes=20)"""))

    return nb

if __name__ == "__main__":
    notebook = build_notebook()
    
    # Salva como exercicio_8_puzzle.ipynb
    with open("exercicio_8_puzzle.ipynb", "w", encoding="utf-8") as f:
        json.dump(notebook, f, indent=1, ensure_ascii=False)
    print("Salvo em exercicio_8_puzzle.ipynb")

    # Atualiza também puzzle.ipynb
    with open("puzzle.ipynb", "w", encoding="utf-8") as f:
        json.dump(notebook, f, indent=1, ensure_ascii=False)
    print("Salvo em puzzle.ipynb")
