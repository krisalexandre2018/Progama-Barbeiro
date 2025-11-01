# 🔧 Como Criar o Índice do Firestore para a Agenda

## 🎯 Problema
A agenda não aparece porque falta um **índice composto** no Firestore.

## ✅ Solução Rápida (Automática)

### Passo 1: Execute o app
```bash
flutter run
```

### Passo 2: Acesse a tela de agenda
- **Admin**: Login → Painel do Dono → Ver Agenda Completa
- **Cliente**: Login → Painel do Cliente (já mostra horários livres)

### Passo 3: Observe o console
Procure por uma mensagem parecida com:

```
[firebase_firestore/unknown] FAILED_PRECONDITION:
The query requires an index. You can create it here:
https://console.firebase.google.com/v1/r/project/barbearia-ricardo-sidney/firestore/indexes?create_composite=...
```

### Passo 4: Copie e abra a URL
- Copie a URL completa que aparece após "You can create it here:"
- Cole no navegador
- Faça login no Firebase (se necessário)
- O Firebase vai **criar o índice automaticamente**

### Passo 5: Aguarde
- O índice leva **5-10 minutos** para ser construído
- Você pode acompanhar o status em: Firebase Console → Firestore → Indexes

### Passo 6: Teste novamente
- Feche e reabra o app
- Acesse a agenda novamente
- Os horários devem aparecer! ✅

---

## 🛠️ Solução Manual (Se a automática não funcionar)

### Passo 1: Acesse o Firebase Console
https://console.firebase.google.com

### Passo 2: Selecione o projeto
`barbearia-ricardo-sidney`

### Passo 3: Vá em Firestore Database → Indexes
Clique na aba **"Indexes"** (não confunda com "Rules")

### Passo 4: Clique em "Create Index"

### Passo 5: Configure o índice

**Collection ID:**
```
agendamentos
```

**Fields to index:**
1. **Campo 1:**
   - Field path: `data_iso`
   - Query scope: `Ascending`

2. **Campo 2:**
   - Field path: `hora`
   - Query scope: `Ascending`

**Query scope:**
```
Collection
```

### Passo 6: Clique em "Create"

### Passo 7: Aguarde
Status do índice vai mudar de:
- ⏳ **Building** (amarelo) → Aguarde 5-10 minutos
- ✅ **Enabled** (verde) → Pronto para usar!

---

## 🔍 Como Verificar se o Índice foi Criado

### Opção 1: Via Firebase Console
1. Firebase Console → Firestore Database → Indexes
2. Procure por:
   - **Collection ID**: `agendamentos`
   - **Fields indexed**: `data_iso Asc, hora Asc`
   - **Status**: Enabled (verde)

### Opção 2: Via logs do app
Após criar o índice, execute:
```bash
flutter run
```

Você deve ver nos logs:
```
📅 Buscando horários de hoje (2025-11-01) em diante...
✅ Encontrados X horários no Firestore
📋 Horários carregados: X
```

Se `X > 0`, o índice está funcionando! 🎉

---

## 🚨 Troubleshooting

### Problema: Não aparece mensagem de erro no console

**Causa:** Pode estar silencioso ou a query pode estar falhando antes

**Solução:**
1. Ative logs verbosos: `flutter run -v`
2. Procure por mensagens do Firebase
3. Ou crie o índice manualmente (veja seção acima)

### Problema: Índice fica em "Building" por muito tempo

**Causa Normal:** Leva até 10 minutos mesmo

**Solução:**
- Aguarde pacientemente
- Se passar de 30 minutos, delete e recrie o índice

### Problema: Após criar índice, ainda não aparece nada

**Possíveis causas:**
1. **Índice ainda está sendo construído** (status: Building)
   - Solução: Aguarde mais alguns minutos

2. **Não existem horários cadastrados no Firestore**
   - Solução: Login como admin → Criar Horários

3. **Horários foram criados com data passada**
   - Solução: Criar novos horários com datas futuras

4. **Firebase não está conectado**
   - Solução: Verifique se `LoadingScreen` mostra sucesso

### Como testar se há dados no Firestore:

1. Firebase Console → Firestore Database → Data
2. Procure pela coleção `agendamentos`
3. Verifique se existem documentos
4. Clique em um documento e verifique:
   - Campo `data_iso` existe? Ex: `"2025-11-01"`
   - Campo `hora` existe? Ex: `"14:30"`
   - Data é >= hoje?

---

## 📝 Índices Necessários (Lista Completa)

Para o app funcionar perfeitamente, você precisa de **3 índices compostos**:

### Índice 1: Agenda Completa (Admin)
```
Collection: agendamentos
Fields: data_iso (Asc), hora (Asc)
```

### Índice 2: Horários Livres (Cliente)
```
Collection: agendamentos
Fields: status (Asc), data_iso (Asc), hora (Asc)
```

### Índice 3: Meus Agendamentos (Cliente)
```
Collection: agendamentos
Fields: cliente_cpf (Asc), status (Asc), data_iso (Asc), hora (Asc)
```

**💡 Dica:** Crie todos os 3 de uma vez para evitar problemas futuros!

---

## 🎯 Verificação Final

Após criar o(s) índice(s), teste:

- [ ] **Admin**: Login → Ver Agenda Completa → Lista de horários aparece
- [ ] **Cliente**: Login → Painel → Horários livres aparecem
- [ ] **Cliente**: Meus Agendamentos → Lista de agendamentos aparece
- [ ] **Console**: Sem mensagens de erro sobre índices

Se tudo estiver ✅, o problema está **RESOLVIDO**! 🎉

---

**Última atualização:** 2025-11-01
