# 🔧 CORREÇÃO DO CRASH AO ABRIR O APP

## ❌ Problemas Identificados

O app estava crashando (abrindo e fechando imediatamente) por **2 motivos críticos**:

### 1. ✅ **CORRIGIDO** - Falta de permissões de Internet
**Problema:** AndroidManifest.xml não tinha permissões de INTERNET
**Solução:** Adicionadas as permissões:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### 2. ⚠️ **PENDENTE** - Arquivo google-services.json ausente
**Problema:** Firebase precisa do arquivo `google-services.json` em `android/app/`
**Status:** Arquivo não encontrado no projeto

---

## 📋 Como Baixar o google-services.json

### Passo 1: Acesse o Firebase Console
1. Vá em: https://console.firebase.google.com
2. Selecione o projeto: **barbearia-ricardo-sidney**
3. Clique no ícone de **engrenagem** ⚙️ (ao lado de "Visão geral do projeto")
4. Clique em **Configurações do projeto**

### Passo 2: Configure o App Android
1. Role até a seção **"Seus apps"**
2. Clique no app Android (ícone do Android)
3. Se não existir, clique em **"Adicionar app"** > **Android**
   - **Nome do pacote:** `com.example.barbershop_app`
   - **Apelido do app:** Ricardo Sidney Barbeiro
   - Clique em **"Registrar app"**

### Passo 3: Baixe o google-services.json
1. Clique em **"Fazer o download do google-services.json"**
2. Salve o arquivo

### Passo 4: Coloque no Projeto
Copie o arquivo para:
```
android/app/google-services.json
```

**Caminho completo:**
```
E:\Todos os projetos\Progama Barbeiro\android\app\google-services.json
```

---

## 🔄 Depois de Adicionar o Arquivo

Execute estes comandos:

```bash
# Limpar build anterior
flutter clean

# Baixar dependências
flutter pub get

# Gerar novo APK
flutter build apk --debug
```

O novo APK estará em:
```
build/app/outputs/flutter-apk/app-debug.apk
```

---

## ✅ Checklist de Correção

- [x] Permissões INTERNET adicionadas ao AndroidManifest.xml
- [ ] google-services.json baixado do Firebase Console
- [ ] google-services.json colocado em `android/app/`
- [ ] Flutter clean executado
- [ ] Novo APK gerado
- [ ] APK testado no tablet

---

## 🚨 IMPORTANTE

**NUNCA** commite o arquivo `google-services.json` no Git!
Ele já está no `.gitignore` para sua segurança.

---

## 📞 Se Precisar de Ajuda

Se não conseguir acessar o Firebase Console ou tiver problemas:
1. Verifique se tem acesso ao projeto Firebase
2. Confira se o email está autorizado no projeto
3. Se necessário, crie um novo projeto Firebase e reconfigure

---

## 🎯 Após a Correção

O app vai:
- ✅ Abrir normalmente
- ✅ Mostrar splash screen animado
- ✅ Conectar ao Firebase
- ✅ Permitir login e agendamentos

**Boa sorte!** 🚀
