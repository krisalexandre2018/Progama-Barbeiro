# Diagnóstico: Problema com visualização da agenda

## Problema Reportado
O usuário relata que **não consegue ver a agenda** no aplicativo.

## Análise do Código

### 1. Fluxo de Dados

**Admin (Visualizar todos horários):**
1. `AdminAgendaScreen` carrega → `AppointmentsProvider.carregarTodosHorarios()`
2. Provider chama → `FirebaseManager.obterTodosHorarios()`
3. FirebaseManager busca no Firestore: `collection('agendamentos')`

**Cliente (Visualizar horários livres):**
1. `ClientPanelScreen` carrega → `AppointmentsProvider.carregarHorariosLivres()`
2. Provider chama → `FirebaseManager.obterHorariosLivres()`
3. FirebaseManager busca no Firestore com filtro: `status == 'livre'`

### 2. Query do Firestore (IMPORTANTE!)

```dart
// lib/services/firebase_manager.dart:253-261
final snapshot = await _db
    .collection('agendamentos')
    .where('data_iso', isGreaterThanOrEqualTo: hoje)  // ← Índice composto necessário!
    .orderBy('data_iso')                               // ← Índice composto necessário!
    .orderBy('hora')                                   // ← Índice composto necessário!
    .get();
```

**⚠️ PROBLEMA POTENCIAL #1: Índice Composto Não Criado**

O Firestore **requer um índice composto** quando você usa:
- `where()` + múltiplos `orderBy()` em campos diferentes

Se o índice não foi criado, a query **FALHARÁ SILENCIOSAMENTE** ou retornará uma lista vazia.

### 3. Possíveis Causas

#### Causa A: Índice Firestore Ausente ⚠️
**Probabilidade: ALTA**

O Firestore precisa de um índice composto para:
```
Collection: agendamentos
Fields: data_iso (Ascending), hora (Ascending)
Query Scope: Collection
```

**Como verificar:**
1. Abra o Firebase Console: https://console.firebase.google.com
2. Vá em **Firestore Database** → **Indexes** (aba)
3. Procure por um índice na coleção `agendamentos` com campos `data_iso` e `hora`

**Se NÃO existir, você verá um erro no console do Flutter:**
```
[firebase_firestore] Query requires an index. You can create it here: https://console.firebase.google.com/...
```

#### Causa B: Nenhum Horário Cadastrado
**Probabilidade: MÉDIA**

O admin pode não ter criado nenhum horário ainda.

**Como verificar:**
1. Login como admin (CPF: `13681715670`, Senha: `971409`)
2. Ir em "Painel do Dono" → "Criar Horários"
3. Selecionar datas e horários → Criar

#### Causa C: Data ISO Incorreta
**Probabilidade: BAIXA**

Se os horários foram criados com `data_iso` no formato errado ou com datas passadas, eles não aparecerão.

**Formato correto:**
- `data_iso`: `"2025-11-01"` (YYYY-MM-DD)
- Query busca: `data_iso >= "2025-11-01"` (hoje)

Se as datas foram criadas como `"2024-10-25"`, elas NÃO aparecerão.

#### Causa D: Regras do Firestore Bloqueando Leitura
**Probabilidade: MUITO BAIXA**

O arquivo `firestore.rules` está configurado para permitir **tudo** em desenvolvimento:

```
match /{document=**} {
  allow read, write: if true;  ← Permite tudo
}
```

### 4. Logs de Debug Adicionados

Adicionei logs no `FirebaseManager.obterTodosHorarios()`:

```dart
debugPrint('📅 Buscando horários de hoje ($hoje) em diante...');
debugPrint('✅ Encontrados ${snapshot.docs.length} horários no Firestore');
debugPrint('📋 Horários carregados: ${horarios.length}');
```

**Como verificar os logs:**
1. Execute o app: `flutter run`
2. No terminal, procure por linhas como:
   - `📅 Buscando horários de hoje (2025-11-01) em diante...`
   - `✅ Encontrados 42 horários no Firestore`
   - `📋 Horários carregados: 42`

### 5. Soluções Recomendadas

#### Solução 1: Criar Índice Composto no Firestore ⭐ RECOMENDADO

**Opção A: Via Firebase Console (Manual)**
1. Acesse: https://console.firebase.google.com
2. Selecione seu projeto: `barbearia-ricardo-sidney`
3. Vá em **Firestore Database** → **Indexes**
4. Clique em **Create Index**
5. Configure:
   - **Collection ID**: `agendamentos`
   - **Fields to index**:
     - Campo 1: `data_iso` → **Ascending**
     - Campo 2: `hora` → **Ascending**
   - **Query Scope**: `Collection`
6. Clique em **Create**

**Opção B: Via URL de Erro (Automático)**
1. Execute o app com `flutter run`
2. Acesse a tela de agenda (admin ou cliente)
3. Procure no console por uma linha tipo:
   ```
   [firebase_firestore] Query requires an index. You can create it here: https://console.firebase.google.com/...
   ```
4. Copie o link e abra no navegador
5. O Firebase já vai criar o índice automaticamente para você

**⏱️ IMPORTANTE**: Após criar o índice, **aguarde 5-10 minutos** para ele ser construído.

#### Solução 2: Criar Horários de Teste

Se não houver nenhum horário no banco:

1. Faça login como **admin**:
   - CPF: `13681715670`
   - Senha: `971409`

2. Vá em **"Painel do Dono"**

3. Clique em **"Criar Horários"**

4. Selecione:
   - **Datas**: Próximos 7 dias (Segunda até Domingo)
   - **Horários**: De 07:00 até 23:30 (intervalos de 30 min)

5. Clique em **"Criar Horários"**

6. Aguarde a confirmação: `"X horários criados!"`

7. Volte e acesse **"Ver Agenda Completa"**

#### Solução 3: Verificar Dados no Firestore

Acesse o Firestore diretamente:

1. Firebase Console → **Firestore Database**
2. Procure pela coleção `agendamentos`
3. Verifique:
   - ✅ Existem documentos?
   - ✅ Campo `data_iso` existe e tem formato `YYYY-MM-DD`?
   - ✅ Datas são >= data de hoje?

#### Solução 4: Simplificar Query (Temporário)

Se o índice não puder ser criado por algum motivo, você pode **simplificar a query** removendo um `orderBy()`:

```dart
// Opção 1: Remover orderBy de 'hora' (menos organizado)
final snapshot = await _db
    .collection('agendamentos')
    .where('data_iso', isGreaterThanOrEqualTo: hoje)
    .orderBy('data_iso')
    .get();

// Opção 2: Ordenar em memória (mais lento, mas funciona)
final snapshot = await _db
    .collection('agendamentos')
    .where('data_iso', isGreaterThanOrEqualTo: hoje)
    .get();

// Ordenar manualmente após buscar:
final horarios = snapshot.docs.map(...).toList();
horarios.sort((a, b) {
  final cmpData = a['data_iso'].compareTo(b['data_iso']);
  if (cmpData != 0) return cmpData;
  return a['hora'].compareTo(b['hora']);
});
```

### 6. Checklist de Diagnóstico

Execute este checklist para identificar a causa:

- [ ] **1. Verificar console do Flutter**
  ```bash
  flutter run
  # Acesse a tela de agenda
  # Procure por mensagens de erro sobre índices
  ```

- [ ] **2. Verificar logs de debug**
  ```
  Procure por:
  📅 Buscando horários de hoje (XXXX-XX-XX) em diante...
  ✅ Encontrados X horários no Firestore

  Se X = 0, o problema é falta de dados ou índice
  ```

- [ ] **3. Verificar Firebase Console**
  - Firestore Database → Coleção `agendamentos` tem documentos?
  - Firestore Database → Indexes → Existe índice para `data_iso + hora`?

- [ ] **4. Testar criação de horários**
  - Login como admin → "Criar Horários"
  - Criar pelo menos 10 horários
  - Verificar se aparece mensagem de sucesso

- [ ] **5. Verificar data do sistema**
  ```bash
  # No código, hoje é calculado como:
  DateFormat('yyyy-MM-dd').format(DateTime.now())

  # Se o sistema estiver com data errada, isso afeta a query
  ```

### 7. Comandos Úteis

```bash
# Ver logs do Flutter (incluindo Firebase)
flutter run -v

# Limpar cache do Flutter
flutter clean
flutter pub get

# Reconstruir o app
flutter run

# Ver diagnósticos do projeto
flutter doctor -v
```

### 8. Próximos Passos

1. **Execute o app** com `flutter run`
2. **Abra a tela de agenda** (admin ou cliente)
3. **Observe o console** do Flutter
4. **Copie qualquer mensagem de erro** sobre índices
5. **Siga a URL fornecida** pelo Firebase para criar o índice automaticamente

### 9. Contato com o Firebase

Se mesmo após criar o índice o problema persistir:

1. Verifique no Firebase Console → **Firestore → Indexes** se o status é:
   - ✅ **Enabled** (verde) → Índice pronto
   - ⏳ **Building** (amarelo) → Aguarde 5-10 minutos
   - ❌ **Error** (vermelho) → Recrie o índice

2. Aguarde a construção do índice completar antes de testar novamente

---

## Resumo: Causa Mais Provável

**🎯 CAUSA #1: Índice Firestore Ausente**

**Sintoma:**
- Tela de agenda vazia
- Nenhum erro visível na UI
- Console pode mostrar aviso sobre índice necessário

**Solução Rápida:**
1. Execute `flutter run`
2. Acesse a agenda
3. Copie URL de erro do console (se houver)
4. Abra URL no navegador → Crie índice automaticamente
5. Aguarde 5-10 minutos
6. Teste novamente

**OU:**

Crie o índice manualmente no Firebase Console:
- Collection: `agendamentos`
- Field 1: `data_iso` (Ascending)
- Field 2: `hora` (Ascending)
- Scope: Collection

---

**Última atualização:** 2025-11-01
