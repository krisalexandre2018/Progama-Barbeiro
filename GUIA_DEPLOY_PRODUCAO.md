# 🚀 GUIA DE DEPLOY PARA PRODUÇÃO
## App: Ricardo Sidney Barbeiro - Agendamento de Barbearia

**Data:** 01/11/2025
**Versão:** 1.0.1
**Cliente:** Ricardo Sidney

---

## ⚠️ CHECKLIST PRÉ-DEPLOY (CRÍTICO)

Antes de passar o app para o cliente, você **DEVE** completar estes passos:

### ✅ 1. Configurar Regras de Segurança do Firestore

**Status Atual:** ❌ **DESENVOLVIMENTO** (banco totalmente aberto - PERIGOSO!)
**Status Necessário:** ✅ **PRODUÇÃO** (regras de segurança ativas)

#### Como Aplicar:

**Opção A - Firebase Console (Recomendado):**

1. Acesse: https://console.firebase.google.com
2. Selecione o projeto: `barbearia-ricardo-sidney`
3. Vá em: **Firestore Database** > **Regras**
4. **Copie todo o conteúdo** do arquivo: `firestore.rules.production`
5. **Cole** no editor de regras do console
6. Clique em **"Publicar"**
7. ✅ Aguarde confirmação: "Regras publicadas com sucesso"

**Opção B - Firebase CLI:**

```bash
# Se tiver Firebase CLI instalado
cp firestore.rules.production firestore.rules
firebase deploy --only firestore:rules
```

#### ⚠️ Testar Regras:

No Firebase Console, vá em **"Rules Playground"** e teste:

```javascript
// Teste 1: Criar usuário (DEVE PERMITIR)
operation: create
path: /usuarios/abc123
data: {"nome": "Teste", "cpf_ultimos_digitos": "123", "senha": "hash"}

// Teste 2: Ler agendamentos (DEVE PERMITIR)
operation: read
path: /agendamentos/2025-11-01_1400

// Teste 3: Deletar agendamento (DEVE NEGAR)
operation: delete
path: /agendamentos/2025-11-01_1400
```

---

### ✅ 2. Configurar Dados Iniciais do Admin

O admin **Ricardo Sidney** precisa estar cadastrado no Firestore:

#### Coleção: `admins`

Crie um documento com ID = SHA-256 do CPF do Ricardo:

**No Firebase Console:**
1. Vá em **Firestore Database** > **Dados**
2. Crie coleção: `admins`
3. ID do documento: `[CALCULAR SHA-256 DO CPF]`
4. Campos:
   ```
   cpf_ultimos_digitos: "XXX" (últimos 3 dígitos do CPF)
   nome: "Ricardo Sidney"
   senha: "[HASH BCRYPT DA SENHA]"
   data_criacao: [TIMESTAMP ATUAL]
   ```

**Ou use o script** (se tiver Node.js):
```bash
cd scripts
node add_admins.js
```

---

### ✅ 3. Gerar APK Release Assinado

**Status Atual:** APK Debug (não aceito na Play Store)
**Necessário:** APK Release assinado com keystore

#### Passos:

1. **Leia:** `COMO_GERAR_APK_RELEASE.md`
2. **Gere keystore** (se ainda não tiver)
3. **Configure:** `android/key.properties`
4. **Execute:**
   ```bash
   flutter build apk --release
   ```
5. **APK estará em:** `build/app/outputs/flutter-apk/app-release.apk`

⚠️ **IMPORTANTE:**
- **Guarde o keystore em local seguro!**
- Sem o keystore, não conseguirá atualizar o app no futuro!
- **NUNCA commite o keystore no Git!**

---

### ✅ 4. Configurar Firebase App Check (Recomendado)

Protege contra bots e abuso:

1. No Firebase Console: **App Check**
2. Clique em **"Começar"**
3. Selecione: **Play Integrity** (Android)
4. Registre o app
5. Ative proteção para **Firestore**

---

### ✅ 5. Configurar Backup Automático

No Firebase Console:

1. **Firestore Database** > **Backups**
2. Clique em **"Configurar backup"**
3. Escolha frequência: **Diário**
4. Retenção: **7 dias**

---

## 📦 ENTREGA PARA O CLIENTE

### O que entregar:

#### 1. **APK Release Assinado**
- Arquivo: `app-release.apk`
- Versão: 1.0.1 ou superior
- Local: `build/app/outputs/flutter-apk/`

#### 2. **Credenciais Admin**
- CPF do admin configurado
- Senha do admin
- ⚠️ Entregar de forma segura (não por WhatsApp!)

#### 3. **Documentação**
- Este guia (GUIA_DEPLOY_PRODUCAO.md)
- BUILD_INSTRUCTIONS.md
- Manual do usuário (criar se necessário)

#### 4. **Acesso ao Firebase**
- Email do cliente adicionado como **Editor** no projeto Firebase
- Instruções de como acessar o console

#### 5. **Código-fonte** (Opcional)
- Repositório GitHub com acesso
- Ou ZIP do código completo

---

## 🔐 SEGURANÇA - IMPORTANTE!

### Informações Sensíveis:

#### ❌ NUNCA compartilhe publicamente:
- `google-services.json`
- `firebase-credentials.json`
- Keystores (`.jks`, `.keystore`)
- `key.properties`
- Senhas e CPFs

#### ✅ Mantenha em segurança:
- Keystore em cofre/backup seguro
- Senhas em gerenciador de senhas
- Credenciais Firebase em local protegido

---

## 📊 MONITORAMENTO PÓS-DEPLOY

Após entregar para o cliente, monitore:

### No Firebase Console:

1. **Firestore Database** > **Uso**
   - Leituras/escritas por dia
   - Alertar se uso anormal

2. **Analytics** (se configurado)
   - Usuários ativos
   - Crashes
   - Eventos

3. **Crashlytics** (se configurado)
   - Erros em produção
   - Stack traces

### Configurar Alertas:

1. **Firebase Console** > **Alertas**
2. Criar alerta para:
   - Uso acima de 50k leituras/dia
   - Mais de 10 crashes/hora
   - Falhas de autenticação

---

## 🆘 SUPORTE PÓS-ENTREGA

### Problemas Comuns:

#### 1. **App não abre**
- Verificar se google-services.json está no APK
- Verificar permissões de internet no AndroidManifest

#### 2. **Erro ao agendar**
- Verificar regras do Firestore
- Verificar conexão com internet
- Verificar se Firebase está online

#### 3. **Admin não consegue logar**
- Verificar se documento existe em `admins`
- Verificar CPF e senha corretos
- Verificar hash SHA-256 do CPF

---

## 📈 PRÓXIMOS PASSOS (Futuro)

### Melhorias Recomendadas:

1. **Firebase Authentication**
   - Migrar de SHA-256 para Firebase Auth
   - Aumenta segurança drasticamente

2. **Notificações Push**
   - Firebase Cloud Messaging
   - Lembrar clientes de agendamentos

3. **Google Play Store**
   - Publicar na Play Store
   - Atualizações automáticas

4. **Analytics Avançado**
   - Google Analytics
   - Acompanhar uso do app

5. **Cloud Functions**
   - Automações (ex: cancelar agendamentos antigos)
   - Envio de emails/SMS

6. **Versão iOS**
   - Publicar na App Store
   - Usar mesmo código Flutter

---

## 💰 CUSTOS ESTIMADOS

### Firebase (Plano Gratuito):
- **Firestore:** Até 50k leituras + 20k escritas/dia
- **Storage:** Até 1 GB
- **Hosting:** 10 GB/mês

### Se Exceder (Plano Blaze - pague conforme uso):
- **Firestore:** $0.06 por 100k leituras
- **Storage:** $0.026 por GB/mês
- **Cloud Functions:** $0.40 por milhão de invocações

**Estimativa para barbearia pequena:** $0-5/mês

### Google Play Store:
- **Registro único:** $25 (pagamento único)
- **Sem mensalidade**

---

## ✅ CHECKLIST FINAL DE ENTREGA

Antes de entregar, confirme:

- [ ] Regras de segurança do Firestore aplicadas
- [ ] Admin cadastrado no Firestore
- [ ] APK Release gerado e testado
- [ ] Keystore guardado em local seguro
- [ ] Firebase App Check configurado (opcional mas recomendado)
- [ ] Backup automático configurado
- [ ] Cliente adicionado como Editor no Firebase
- [ ] Documentação entregue
- [ ] Credenciais admin entregues de forma segura
- [ ] App testado em dispositivo físico
- [ ] Sem erros ou crashes
- [ ] Todas as 12 telas funcionando
- [ ] WhatsApp integration testada
- [ ] Recuperação de senha testada

---

## 📞 CONTATO PÓS-ENTREGA

Defina com o cliente:
- Período de suporte incluso
- Canais de comunicação (WhatsApp, email, telefone)
- Horário de atendimento
- Custo de manutenção/atualizações futuras

---

**✅ Boa sorte com a entrega!** 🚀

Em caso de dúvidas, consulte a documentação do Firebase ou entre em contato.
