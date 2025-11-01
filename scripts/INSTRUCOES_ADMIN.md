# Como Adicionar o Administrador Inicial no Firestore

## Método 1: Via Script Dart (Recomendado)

Execute o script de população:

```bash
dart run scripts/populate_admin.dart
```

**Credenciais criadas:**
- CPF: `13681715670`
- Senha: `971409`
- Nome: `Ricardo Sidney`

---

## Método 2: Via Firebase Console (Manual)

### 1. Acesse o Firebase Console

1. Vá para: https://console.firebase.google.com/
2. Selecione o projeto: **barbearia-ricardo-sidney**
3. Clique em **Firestore Database** no menu lateral

### 2. Selecione o Banco de Dados Correto

⚠️ **IMPORTANTE**: Certifique-se de estar usando o banco **(default)**, não o "mododeproducao"

### 3. Criar a Coleção `admins`

1. Clique em **"Iniciar coleção"** (se for a primeira vez) ou **"Adicionar documento"**
2. Nome da coleção: `admins`

### 4. Adicionar Documento do Admin

**ID do Documento**: `bb8433535590ef3f568e41e826da914eb812ed54f34c68edb00662a3dd7945b5`

> ⚠️ Este é o hash SHA-256 do CPF `13681715670`

**Campos do documento:**

| Campo | Tipo | Valor |
|-------|------|-------|
| `nome` | string | `Ricardo Sidney` |
| `senha` | string | `f3226de215bcb4506bd0c00ed70bd2e089059d72a2373a46e64cf856bf81801f` |
| `cpf_ultimos_digitos` | string | `5670` |
| `data_criacao` | timestamp | (use "Data/hora atual") |
| `tipo` | string | `admin` |

> ⚠️ O hash de senha `f3226de215bcb4506bd0c00ed70bd2e089059d72a2373a46e64cf856bf81801f` corresponde à senha `971409`

### 5. Salvar

Clique em **"Salvar"** para criar o documento.

---

## Credenciais de Login

Após criar o admin, use estas credenciais no app:

- **CPF**: `13681715670`
- **Senha**: `971409`

---

## Como Gerar Novos Hashes (Opcional)

Se você quiser criar um admin com CPF ou senha diferente, use este código Dart para gerar os hashes:

```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashCpf(String cpf) {
  final bytes = utf8.encode(cpf);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

String hashSenha(String senha) {
  final bytes = utf8.encode(senha);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

void main() {
  final cpf = '13681715670';
  final senha = '971409';

  print('CPF Hash: ${hashCpf(cpf)}');
  print('Senha Hash: ${hashSenha(senha)}');
}
```

Ou use uma ferramenta online de SHA-256: https://emn178.github.io/online-tools/sha256.html

---

## Estrutura Completa do Documento

```json
{
  "nome": "Ricardo Sidney",
  "senha": "f3226de215bcb4506bd0c00ed70bd2e089059d72a2373a46e64cf856bf81801f",
  "cpf_ultimos_digitos": "5670",
  "data_criacao": "2025-10-31T12:00:00.000Z",
  "tipo": "admin"
}
```

**ID do Documento**: `bb8433535590ef3f568e41e826da914eb812ed54f34c68edb00662a3dd7945b5`

---

## Verificação

Após criar o admin, teste o login:

1. Abra o app
2. Vá para **Acesso Administrativo**
3. Digite CPF: `13681715670`
4. Digite Senha: `971409`
5. Clique em **ENTRAR**

Se tudo estiver correto, você será redirecionado para o painel de administração.

---

## Segurança

⚠️ **IMPORTANTE**:

1. Altere a senha padrão após o primeiro login
2. Mantenha as credenciais em local seguro
3. Não compartilhe o hash SHA-256 do CPF
4. Configure as regras de segurança do Firestore (veja firestore.rules)
