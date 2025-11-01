# 🔥 Scripts do Firebase

Este diretório contém scripts utilitários para gerenciar o Firebase Firestore.

## 📄 populate_firestore.dart

Script para popular automaticamente o Firestore com dados de teste.

### 🚀 Como Usar

#### Passo 1: Certifique-se de que o Firebase está configurado

```bash
# Se ainda não configurou, rode:
flutterfire configure
```

Isso criará o arquivo `lib/firebase_options.dart` necessário.

#### Passo 2: Execute o script

```bash
dart run scripts/populate_firestore.dart
```

#### Passo 3: Escolha uma opção

O script mostrará um menu:
```
O que você deseja fazer?
1 - Popular TUDO (usuarios + agendamentos)
2 - Popular apenas usuários
3 - Popular apenas agendamentos
4 - Limpar TUDO (CUIDADO!)
0 - Sair

Escolha uma opção:
```

---

## 📊 O Que o Script Cria

### 🔐 Opção 1 ou 2: Usuários de Teste

Cria 3 usuários na coleção `usuarios`:

| Nome | CPF | Senha | Hash CPF (ID do doc) |
|------|-----|-------|----------------------|
| João Silva | `12345678901` | `123456` | `254aa248acb47dd654ca3ea53f48c2c26d641d23d7e2e93a1ec56258df7674c4` |
| Maria Santos | `98765432100` | `senha123` | `0a5750798e6e569084ecd939dc48a3f847e05bd54ed89fd91f7e55d9a0bf061a` |
| Carlos Oliveira | `11122233344` | `1234` | `b9c9f4f8c4e6e3c3b0f7c1e8e4d5a2c9b8a7f6e5d4c3b2a1` |

### 📅 Opção 1 ou 3: Agendamentos

Cria **aproximadamente 35 horários livres** para os **próximos 7 dias**, distribuídos ao longo do dia:
- Horários: 07:00 às 23:30 (intervalos de 30 minutos)
- Status: `livre`
- Todos com `data_iso` >= hoje

### 🗑️ Opção 4: Limpar Tudo

**⚠️ CUIDADO!** Esta opção deleta TODOS os dados do Firestore:
- Todos os usuários
- Todos os agendamentos
- Todos os códigos de recuperação de senha

Você precisará digitar `SIM` para confirmar.

---

## 🧪 Testando o App Após Popular

Após executar o script, você pode testar o app com estas credenciais:

### Login como Cliente 1:
```
CPF: 12345678901
Senha: 123456
```

### Login como Cliente 2:
```
CPF: 98765432100
Senha: senha123
```

### Login como Cliente 3:
```
CPF: 11122233344
Senha: 1234
```

### Login como Admin:
```
CPF: 13681715670
Senha: 971409
```
*(Admin está hardcoded no app, não é criado pelo script)*

---

## 🔧 Solução de Problemas

### Erro: "firebase_options.dart not found"

**Solução**: Configure o Firebase primeiro:
```bash
flutterfire configure
```

### Erro: "Permission denied"

**Solução**: Configure as regras do Firestore para permitir escrita (durante desenvolvimento):

1. Acesse: https://console.firebase.google.com
2. Seu projeto → Firestore → Regras
3. Substitua por:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // ⚠️ Apenas para desenvolvimento!
    }
  }
}
```
4. Clique em "Publicar"

### Erro: "Cannot find package"

**Solução**: Instale as dependências primeiro:
```bash
flutter pub get
```

---

## 📝 Modificando o Script

Você pode editar o arquivo `populate_firestore.dart` para:

- **Adicionar mais usuários**: Edite a função `populateUsers()`
- **Mudar os horários**: Edite a lista `horarios` em `populateAppointments()`
- **Mudar quantos dias criar**: Edite o loop `for (int i = 1; i <= 7; i++)` (7 = próximos 7 dias)
- **Criar mais/menos horários por dia**: Edite `j += 6` para outro valor

---

## 🎯 Exemplo de Uso Completo

```bash
# 1. Configurar Firebase (se não fez ainda)
flutterfire configure

# 2. Instalar dependências
flutter pub get

# 3. Popular o Firestore
dart run scripts/populate_firestore.dart
# Escolha opção 1 (Popular TUDO)

# 4. Testar o app
flutter run

# 5. Fazer login com:
#    CPF: 12345678901
#    Senha: 123456
```

---

## ⚠️ IMPORTANTE

**Este script é para DESENVOLVIMENTO/TESTES apenas!**

Para produção:
- Não use senhas simples como "123456"
- Configure regras de segurança adequadas no Firestore
- Implemente validação de CPF real
- Use bcrypt ou similar para hashing de senhas (atualmente usa SHA-256)

---

**Criado por**: Claude Code
**Data**: Outubro 2025
