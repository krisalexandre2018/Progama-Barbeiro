/// Script para migrar dados do banco 'mododeproducao' para '(default)'
///
/// Execute: dart run scripts/migrar_dados.dart
///
/// Este script copia todos os dados das coleções:
/// - usuarios
/// - agendamentos
/// - recuperacao_senha
///
/// Do banco 'mododeproducao' para o banco '(default)'

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../lib/firebase_options.dart';

Future<void> main() async {
  print('🔧 Inicializando Firebase...\n');

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print('✅ Firebase inicializado!\n');

    // Banco antigo (mododeproducao)
    final dbAntigo = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: 'mododeproducao',
    );

    // Banco novo (default)
    final dbNovo = FirebaseFirestore.instance;

    print('📦 Origem: mododeproducao');
    print('📦 Destino: (default)\n');
    print('─' * 70);

    // ==================== MIGRAR USUÁRIOS ====================
    print('\n👥 Migrando USUÁRIOS...');

    final usuarios = await dbAntigo.collection('usuarios').get();
    print('   Encontrados: ${usuarios.docs.length} documentos');

    int contadorUsuarios = 0;
    for (var doc in usuarios.docs) {
      try {
        await dbNovo.collection('usuarios').doc(doc.id).set(doc.data());
        contadorUsuarios++;
        print('   ✓ ${doc.id.substring(0, 12)}... migrado');
      } catch (e) {
        print('   ✗ Erro ao migrar ${doc.id}: $e');
      }
    }

    print('   ✅ Total migrado: $contadorUsuarios usuários\n');

    // ==================== MIGRAR AGENDAMENTOS ====================
    print('📅 Migrando AGENDAMENTOS...');

    final agendamentos = await dbAntigo.collection('agendamentos').get();
    print('   Encontrados: ${agendamentos.docs.length} documentos');

    int contadorAgendamentos = 0;
    for (var doc in agendamentos.docs) {
      try {
        final dados = doc.data();
        await dbNovo.collection('agendamentos').doc(doc.id).set(dados);
        contadorAgendamentos++;

        // Mostra data e hora do agendamento
        final data = dados['data'] ?? 'N/A';
        final hora = dados['hora'] ?? 'N/A';
        final status = dados['status'] ?? 'N/A';
        print('   ✓ $data $hora ($status)');
      } catch (e) {
        print('   ✗ Erro ao migrar ${doc.id}: $e');
      }
    }

    print('   ✅ Total migrado: $contadorAgendamentos agendamentos\n');

    // ==================== MIGRAR RECUPERAÇÃO DE SENHA ====================
    print('🔑 Migrando RECUPERAÇÃO DE SENHA...');

    final recuperacao = await dbAntigo.collection('recuperacao_senha').get();
    print('   Encontrados: ${recuperacao.docs.length} documentos');

    int contadorRecuperacao = 0;
    for (var doc in recuperacao.docs) {
      try {
        await dbNovo.collection('recuperacao_senha').doc(doc.id).set(doc.data());
        contadorRecuperacao++;
        print('   ✓ ${doc.id.substring(0, 12)}... migrado');
      } catch (e) {
        print('   ✗ Erro ao migrar ${doc.id}: $e');
      }
    }

    print('   ✅ Total migrado: $contadorRecuperacao códigos\n');

    // ==================== RESUMO ====================
    print('─' * 70);
    print('\n📊 RESUMO DA MIGRAÇÃO:');
    print('   Usuários: $contadorUsuarios');
    print('   Agendamentos: $contadorAgendamentos');
    print('   Recuperação de senha: $contadorRecuperacao');
    print('   TOTAL: ${contadorUsuarios + contadorAgendamentos + contadorRecuperacao} documentos\n');

    print('✅ Migração concluída com sucesso!\n');
    print('⚠️  PRÓXIMO PASSO:');
    print('   Execute: dart run scripts/populate_admin.dart');
    print('   Para criar o administrador no banco (default)\n');

  } catch (e) {
    print('❌ Erro durante a migração: $e');
    rethrow;
  }
}
