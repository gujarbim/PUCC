## 1. Tipo fixo
Em Dart, as variáveis possuem um tipo fixo. Quando declaramos var seguidores = 120;,infere automaticamente que a variável é do tipo numérico inteiro. A partir desse momento, o tipo da variável fica travado. Por isso, a linha seguidores = 1M; dá erro, estamos tentando colocar um textomString dentro de uma caixa que já foi fixada na memória para receber apenas números inteiros.

## 2. Escolha de tipo
Para a nota média, usaria o tipo double, pois ele é o tipo da linguagem projetado especificamente para armazenar números decimais e fracionários. Para a verificação da conta, usaria o tipo bool, pois ele é feito para representar estados binários.

## 3. var ou final
Ela deve ser declarada com final. O critério para o uso do final é a intenção de proteger uma variável contra reatribuições. Como o nome de usuário é definido no cadastro e não sofre mais nenhuma mutação depois disso, declarar com final expressa claramente a intenção do código e impede que o valor seja alterado acidentalmente no futuro, além de ajudar a memória.

## 4. Comparando DateTime
O tipo DateTime é uma classe que agrupa múltiplas informações ao mesmo tempo, diferentemente de int ou double, que guardam apenas um valor numérico simples e nativo. Por não ser um número simples, os operadores matemáticos básicos <, > não sabem como interpreta de forma direta. No lugar deles, utilizamos os métodos próprios da classe para comparação de tempo, isBefore, isAfter e isAtSameMomentAs.

## 5. Interpolação
O que aparece no console é Login: 9h05.
A diferença no uso das chaves se dá pela complexidade da expressão avaliada. A variável $min não precisa de chaves pois é uma variável de acesso direto. Já o ultimoLogin.hour precisa das chaves {} porque não estamos imprimindo a variável inteira, mas sim acessando uma propriedade hour dentro do objeto. As chaves dizem para avaliar toda a expressão interna primeiro. Se usássemos apenas $ultimoLogin.hour sem chaves, ele tentaria imprimir o objeto inteiro e colaria o texto hour no final literalmente.
