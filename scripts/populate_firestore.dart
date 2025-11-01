// cspell:disable
/// Script para popular o Firebase Firestore com dados de exemplo
///
/// Execute este script para criar automaticamente:
/// - Coleção 'usuarios' com 1 usuário de teste
/// - Coleção 'agendamentos' com vários horários livres
/// - Coleção 'recuperacao_senha' (vazia)
///
/// Como executar:
/// 1. Certifique-se de que o Firebase está configurado (firebase_options.dart existe)
/// 2. Execute: dart run scripts/populate_firestore.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';

// Importe as opções do Firebase do seu projeto
import '../lib/firebase_options.dart';

void main() async {
  print('🔥 Iniciando script de população do Firestore...\n');

  // Inicializar Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado com sucesso!\n');
  } catch (e) {
    print('❌ Erro ao inicializar Firebase: $e');
    exit(1);
  }

  final firestore = FirebaseFirestore.instance;

  // Perguntar ao usuário o que deseja fazer
  print('O que você deseja fazer?');
  print('1 - Popular TUDO (usuarios + agendamentos)');
  print('2 - Popular apenas usuários');
  print('3 - Popular apenas agendamentos');
  print('4 - Limpar TUDO (CUIDADO!)');
  print('0 - Sair');
  stdout.write('\nEscolha uma opção: ');

  final choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      await populateUsers(firestore);
      await populateAppointments(firestore);
      break;
    case '2':
      await populateUsers(firestore);
      break;
    case '3':
      await populateAppointments(firestore);
      break;
    case '4':
      stdout.write('\n⚠️  TEM CERTEZA? Digite "SIM" para confirmar: ');
      final confirm = stdin.readLineSync();
      if (confirm == 'SIM') {
        await clearAllData(firestore);
      } else {
        print('❌ Operação cancelada.');
      }
      break;
    case '0':
      print('👋 Saindo...');
      exit(0);
    default:
      print('❌ Opção inválida!');
      exit(1);
  }

  print('\n✅ Script finalizado com sucesso!');
  exit(0);
}

/// Popular coleção 'usuarios' com usuário de teste
Future<void> populateUsers(FirebaseFirestore firestore) async {
  print('\n📝 Populando coleção "usuarios"...');

  final usersCollection = firestore.collection('usuarios');

  // Usuário de teste 1: CPF 12345678901, Senha 123456
  final cpf1 = '12345678901';
  final senha1 = '123456';
  final cpfHash1 = sha256.convert(utf8.encode(cpf1)).toString();
  final senhaHash1 = sha256.convert(utf8.encode(senha1)).toString();

  await usersCollection.doc(cpfHash1).set({
    'nome': 'João Silva',
    'senha': senhaHash1,
    'cpf_ultimos_digitos': cpf1.substring(cpf1.length - 4),
    'data_criacao': FieldValue.serverTimestamp(),
    'agendamentos_ativos': 0,
  });
  print('   ✅ Usuário criado: João Silva (CPF: $cpf1, Senha: $senha1)');

  // Usuário de teste 2: CPF 98765432100, Senha senha123
  final cpf2 = '98765432100';
  final senha2 = 'senha123';
  final cpfHash2 = sha256.convert(utf8.encode(cpf2)).toString();
  final senhaHash2 = sha256.convert(utf8.encode(senha2)).toString();

  await usersCollection.doc(cpfHash2).set({
    'nome': 'Maria Santos',
    'senha': senhaHash2,
    'cpf_ultimos_digitos': cpf2.substring(cpf2.length - 4),
    'data_criacao': FieldValue.serverTimestamp(),
    'agendamentos_ativos': 0,
  });
  print('   ✅ Usuário criado: Maria Santos (CPF: $cpf2, Senha: $senha2)');

  // Usuário de teste 3: CPF 11122233344, Senha 1234
  final cpf3 = '11122233344';
  final senha3 = '1234';
  final cpfHash3 = sha256.convert(utf8.encode(cpf3)).toString();
  final senhaHash3 = sha256.convert(utf8.encode(senha3)).toString();

  await usersCollection.doc(cpfHash3).set({
    'nome': 'Carlos Oliveira',
    'senha': senhaHash3,
    'cpf_ultimos_digitos': cpf3.substring(cpf3.length - 4),
    'data_criacao': FieldValue.serverTimestamp(),
    'agendamentos_ativos': 0,
  });
  print('   ✅ Usuário criado: Carlos Oliveira (CPF: $cpf3, Senha: $senha3)');

  print('\n✅ Coleção "usuarios" populada com 3 usuários de teste!');
}

/// Popular coleção 'agendamentos' com horários livres
Future<void> populateAppointments(FirebaseFirestore firestore) async {
  print('\n📅 Populando coleção "agendamentos"...');

  final appointmentsCollection = firestore.collection('agendamentos');

  // Data de hoje
  final hoje = DateTime.now();

  // Lista de horários para criar (próximos 7 dias)
  const diasSemana = ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];
  const horarios = [
    '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30',
    '11:00', '11:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30',
    '17:00', '17:30', '18:00', '18:30', '19:00', '19:30', '20:00', '20:30',
    '21:00', '21:30', '22:00', '22:30', '23:00', '23:30',
  ];

  int totalCriados = 0;

  // Criar horários para os próximos 7 dias
  for (int i = 1; i <= 7; i++) {
    final data = hoje.add(Duration(days: i));
    final dataISO = '${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}';
    final dataBR = '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
    final diaSemana = diasSemana[data.weekday % 7];

    // Criar alguns horários aleatórios por dia (não todos, para não poluir)
    // Vamos criar 5 horários por dia
    for (int j = 0; j < horarios.length; j += 6) {
      if (j >= horarios.length) break;

      final hora = horarios[j];
      final horaFormatada = hora.replaceAll(':', '');
      final docId = '${dataISO}_$horaFormatada';

      await appointmentsCollection.doc(docId).set({
        'data': dataBR,
        'data_iso': dataISO,
        'dia_semana': diaSemana,
        'hora': hora,
        'status': 'livre',
      });

      totalCriados++;
    }
  }

  print('   ✅ Criados $totalCriados horários livres para os próximos 7 dias');
  print('\n✅ Coleção "agendamentos" populada!');
}

/// Limpar TODOS os dados do Firestore (USE COM CUIDADO!)
Future<void> clearAllData(FirebaseFirestore firestore) async {
  print('\n🗑️  Limpando TODOS os dados do Firestore...');

  // Limpar usuarios
  print('   🗑️  Deletando usuários...');
  final users = await firestore.collection('usuarios').get();
  for (var doc in users.docs) {
    await doc.reference.delete();
  }
  print('   ✅ ${users.docs.length} usuários deletados');

  // Limpar agendamentos
  print('   🗑️  Deletando agendamentos...');
  final appointments = await firestore.collection('agendamentos').get();
  for (var doc in appointments.docs) {
    await doc.reference.delete();
  }
  print('   ✅ ${appointments.docs.length} agendamentos deletados');

  // Limpar recuperacao_senha
  print('   🗑️  Deletando códigos de recuperação...');
  final recovery = await firestore.collection('recuperacao_senha').get();
  for (var doc in recovery.docs) {
    await doc.reference.delete();
  }
  print('   ✅ ${recovery.docs.length} códigos deletados');

  print('\n✅ Firestore limpo com sucesso!');
}
