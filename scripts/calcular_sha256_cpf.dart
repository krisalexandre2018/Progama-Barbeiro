import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

/// Script para calcular SHA-256 de CPF
/// Usado para criar ID de usuários e admins no Firestore
///
/// Uso:
/// dart run scripts/calcular_sha256_cpf.dart
///
/// Ou com CPF direto:
/// dart run scripts/calcular_sha256_cpf.dart 12345678900

void main(List<String> arguments) {
  print('═══════════════════════════════════════════════════════════');
  print('  📊 CALCULADORA DE SHA-256 PARA CPF');
  print('  App: Ricardo Sidney Barbeiro');
  print('═══════════════════════════════════════════════════════════\n');

  String cpf;

  if (arguments.isNotEmpty) {
    // CPF passado como argumento
    cpf = arguments[0];
  } else {
    // Solicitar CPF interativamente
    stdout.write('Digite o CPF (apenas números, 11 dígitos): ');
    cpf = stdin.readLineSync() ?? '';
  }

  // Limpar CPF (remover pontos, traços, espaços)
  cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

  // Validar
  if (cpf.length != 11) {
    print('\n❌ ERRO: CPF deve ter exatamente 11 dígitos!');
    print('   CPF informado: "$cpf" (${cpf.length} dígitos)\n');
    exit(1);
  }

  // Calcular SHA-256
  final bytes = utf8.encode(cpf);
  final hash = sha256.convert(bytes);
  final hashString = hash.toString();

  // Extrair últimos 3 dígitos
  final ultimosDigitos = cpf.substring(cpf.length - 3);

  print('\n═══════════════════════════════════════════════════════════');
  print('  ✅ RESULTADO');
  print('═══════════════════════════════════════════════════════════\n');

  print('📋 CPF Original: $cpf');
  print('📋 CPF Formatado: ${_formatarCpf(cpf)}');
  print('🔑 SHA-256 Hash: $hashString');
  print('🔢 Últimos 3 dígitos: $ultimosDigitos\n');

  print('═══════════════════════════════════════════════════════════');
  print('  📝 DADOS PARA FIRESTORE');
  print('═══════════════════════════════════════════════════════════\n');

  print('ID do Documento (usuarios ou admins):');
  print('  $hashString\n');

  print('Campo "cpf_ultimos_digitos":');
  print('  $ultimosDigitos\n');

  print('═══════════════════════════════════════════════════════════');
  print('  🔧 EXEMPLO DE DOCUMENTO NO FIRESTORE');
  print('═══════════════════════════════════════════════════════════\n');

  print('Coleção: admins');
  print('ID do Documento: $hashString');
  print('''
Campos:
{
  "nome": "Ricardo Sidney",
  "cpf_ultimos_digitos": "$ultimosDigitos",
  "senha": "[HASH_BCRYPT_DA_SENHA]",
  "data_criacao": "[TIMESTAMP]"
}
''');

  print('═══════════════════════════════════════════════════════════');
  print('  💡 PRÓXIMOS PASSOS');
  print('═══════════════════════════════════════════════════════════\n');

  print('1. Copie o SHA-256 Hash acima');
  print('2. Acesse Firebase Console: https://console.firebase.google.com');
  print('3. Vá em Firestore Database > Dados');
  print('4. Crie/edite documento na coleção "admins"');
  print('5. Use o SHA-256 como ID do documento');
  print('6. Adicione os campos mostrados acima\n');

  print('═══════════════════════════════════════════════════════════\n');
}

/// Formata CPF para exibição (000.000.000-00)
String _formatarCpf(String cpf) {
  if (cpf.length != 11) return cpf;
  return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}';
}
