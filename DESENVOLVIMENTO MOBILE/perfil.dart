void main() {
  final String nomeUsuario = 'ana.silva';
  final bool contaVerificada = true;
  final double notaTotal = 13.5;
  final int numeroAvaliacoes = 3;
  
  final DateTime ultimoLogin = DateTime(2026, 9, 10, 7, 40);
  final int duracaoSessaoMin = 25;
  final DateTime proximaVerificacao = DateTime(2026, 9, 10, 8, 30);

  final double notaMedia = notaTotal / numeroAvaliacoes;

  final DateTime sessaoExpira = ultimoLogin.add(Duration(minutes: duracaoSessaoMin));

  final bool expiraAntesDaVerificacao = sessaoExpira.isBefore(proximaVerificacao);

  final String minutoFormatado = sessaoExpira.minute.toString().padLeft(2, '0');

  print('Usuário: $nomeUsuario');
  print('Conta verificada? $contaVerificada');
  print('Nota média: $notaMedia');
  print('Sessão expira às: ${sessaoExpira.hour}h$minutoFormatado');
  print('Expira antes da verificação? $expiraAntesDaVerificacao');
}
