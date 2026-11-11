# Exercício 8-Puzzle: Busca em Largura e Profundidade

**Disciplina:** Mineração de Dados e Business Intelligence - Prática  
**Instituição:** Pontifícia Universidade Católica (PUC)  

---

## 👥 Identificação do Grupo

| Aluno | Nome Completo | RA |
| :--- | :--- | :--- |
| **Aluno 1** | [Nome do Aluno 1] | [0000000] |
| **Aluno 2** | [Nome do Aluno 2] | [0000000] |
| **Aluno 3** | [Nome do Aluno 3] | [0000000] |

---

## 📌 Sequência de Ações do Código

O programa foi estruturado em uma sequência linear de 7 passos claros:

1. **Passo 1: Estado Objetivo e Tabuleiro**
   - *O que faz:* Define o estado final ordenado `(1, 2, 3, 4, 5, 6, 7, 8, 'X')` e a função para formatar a grade 3x3 no padrão `|1 | 2 | 3|`.
   - *Por que faz:* Padroniza a representação visual exigida na especificação da atividade.

2. **Passo 2: Verificação de Solubilidade (Número de Inversões)**
   - *O que faz:* Conta quantos pares de números estão fora de ordem numérica (ignorando `'X'`).
   - *Por que faz:* Qualquer movimento no 8-puzzle altera a quantidade de inversões em $0$, $+2$ ou $-2$ (a paridade se mantém constante). Como a meta tem $0$ inversões (par), o quebra-cabeça **só é solúvel se o número de inversões for PAR**.

3. **Passo 3: Geração do Estado Inicial Aleatório**
   - *O que faz:* Embaralha os blocos aleatoriamente e testa as inversões. Se for ímpar, descarta e sorteia novamente até obter um estado par.
   - *Por que faz:* Atende à regra do enunciado de descartar estados impossíveis de resolver.

4. **Passo 4: Movimentos Válidos (Sucessores)**
   - *O que faz:* Localiza a posição do `'X'` e gera os novos estados movendo o espaço vazio para Cima, Baixo, Esquerda ou Direita dentro dos limites 3x3.
   - *Por que faz:* Representa os operadores de transição permitidos no problema.

5. **Passo 5: Busca em Largura (BFS)**
   - *O que faz:* Explora os estados nível a nível usando uma fila FIFO (`deque`), exibindo o tabuleiro a cada iteração e incrementando $N$.
   - *Por que faz:* Garante encontrar o menor caminho até o objetivo (solução ótima).

6. **Passo 6: Busca em Profundidade (DFS)**
   - *O que faz:* Explora os estados aprofundando o máximo possível ao longo de cada ramo usando uma pilha LIFO (`list`) com controle de visitados.
   - *Por que faz:* Implementa a busca não-informada em profundidade vista em sala de aula.

7. **Passo 7: Comparativo Final**
   - *O que faz:* Exibe o número final de iterações $N$ de cada busca.
   - *Por que faz:* Permite comparar o desempenho de ambas as estratégias para o mesmo estado inicial.

---

## 🚀 Como Executar

### Pré-requisitos
Python 3.10 ou superior instalado.

### Via Terminal
```bash
python puzzle.py
```

### Via Jupyter Notebook
Abra o arquivo [`puzzle.ipynb`](puzzle.ipynb) no VS Code ou terminal:
```bash
jupyter notebook puzzle.ipynb
```
Execute as células sequencialmente (`Shift + Enter`).
