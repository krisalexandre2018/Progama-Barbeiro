/// Script auxiliar para gerar hashes de CPF e Senha
///
/// Execute: dart run scripts/gerar_hashes.dart

import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

/// Hash de CPF com SHA256
String hashCpf(String cpf) {
  final bytes = utf8.encode(cpf);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

/// Hash de senha com SHA256
String hashSenha(String senha) {
  final bytes = utf8.encode(senha);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

void main() {
  print('🔐 Gerador de Hashes para Firestore\n');

  // Valores padrão do admin
  const adminCpf = '13681715670';
  const adminSenha = '971409';

  print('📋 Hashes para o admin padrão:');
  print('CPF: $adminCpf');
  print('Senha: $adminSenha\n');

  final cpfHash = hashCpf(adminCpf);
  final senhaHash = hashSenha(adminSenha);

  print('✅ Resultados:');
  print('─' * 70);
  print('CPF Hash (ID do documento):');
  print(cpfHash);
  print('');
  print('Senha Hash:');
  print(senhaHash);
  print('─' * 70);
  print('');
  print('Últimos 4 dígitos do CPF: ${adminCpf.substring(adminCpf.length - 4)}');
  print('');

  // Opção para gerar custom
  print('\n🔧 Deseja gerar hashes customizados? (s/n): ');
  final resposta = stdin.readLineSync()?.toLowerCase();

  if (resposta == 's' || resposta == 'sim') {
    print('\nDigite o CPF (apenas números): ');
    final cpfCustom = stdin.readLineSync() ?? '';

    print('Digite a senha: ');
    final senhaCustom = stdin.readLineSync() ?? '';

    if (cpfCustom.isNotEmpty && senhaCustom.isNotEmpty) {
      final cpfHashCustom = hashCpf(cpfCustom);
      final senhaHashCustom = hashSenha(senhaCustom);

      print('\n✅ Hashes customizados:');
      print('─' * 70);
      print('CPF: $cpfCustom');
      print('Senha: $senhaCustom');
      print('');
      print('CPF Hash (ID do documento):');
      print(cpfHashCustom);
      print('');
      print('Senha Hash:');
      print(senhaHashCustom);
      print('─' * 70);
      print('');
      print('Últimos 4 dígitos do CPF: ${cpfCustom.substring(cpfCustom.length - 4)}');
    }
  }

  print('\n✅ Concluído!');
}
