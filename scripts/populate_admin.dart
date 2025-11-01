/// Script para popular dados iniciais do administrador no Firestore
///
/// Execute: dart run scripts/populate_admin.dart
///
/// Este script cria o administrador inicial no banco de dados (default)
/// com as credenciais:
/// CPF: 13681715670
/// Senha: 971409

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import '../lib/firebase_options.dart';

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

Future<void> main() async {
  print('🔧 Inicializando Firebase...');

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print('✅ Firebase inicializado!');
    print('📦 Usando banco: (default)\n');

    final db = FirebaseFirestore.instance;

    // Dados do admin
    const adminCpf = '13681715670';
    const adminSenha = '971409';
    const adminNome = 'Ricardo Sidney';

    final cpfId = hashCpf(adminCpf);
    final senhaHash = hashSenha(adminSenha);

    print('👤 Criando administrador...');
    print('Nome: $adminNome');
    print('CPF: $adminCpf');
    print('Senha: $adminSenha');
    print('CPF Hash: $cpfId');
    print('Senha Hash: $senhaHash\n');

    // Verifica se já existe
    final docRef = db.collection('admins').doc(cpfId);
    final doc = await docRef.get();

    if (doc.exists) {
      print('⚠️  Administrador já existe!');
      print('Deseja sobrescrever? (s/n): ');
      final resposta = stdin.readLineSync()?.toLowerCase();

      if (resposta != 's' && resposta != 'sim') {
        print('❌ Operação cancelada.');
        exit(0);
      }
    }

    // Cria/atualiza o documento
    await docRef.set({
      'nome': adminNome,
      'senha': senhaHash,
      'cpf_ultimos_digitos': adminCpf.substring(adminCpf.length - 4),
      'data_criacao': FieldValue.serverTimestamp(),
      'tipo': 'admin',
    });

    print('\n✅ Administrador criado com sucesso!');
    print('\n📝 Credenciais de login:');
    print('CPF: $adminCpf');
    print('Senha: $adminSenha');
    print('\n⚠️  IMPORTANTE: Altere a senha após o primeiro login!');

    exit(0);
  } catch (e) {
    print('❌ Erro: $e');
    exit(1);
  }
}
