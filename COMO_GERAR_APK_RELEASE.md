# 🔑 Como Gerar o APK Release (Assinado)

## ⚠️ PROBLEMA ATUAL

O keystore está sendo gerado, mas com um problema de senha. Siga estas etapas:

---

## 📋 PASSO A PASSO CORRETO

### 1. Deletar o keystore atual (se existir)

Feche TODOS os programas que possam estar usando o arquivo (VS Code, Android Studio, etc.) e execute:

```powershell
Remove-Item "android\app\key.jks" -Force
```

### 2. Gerar o keystore NOVO

Execute este comando **EXATAMENTE como está**:

```powershell
& "C:\Program Files\Java\jre1.8.0_471\bin\keytool.exe" -genkey -v -keystore "android\app\key.jks" -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias barbershop -storepass barbeiro2024 -keypass barbeiro2024 -dname "CN=Ricardo Sidney, OU=Barbearia, O=Ricardo Sidney Barbeiro, L=Ouro Preto, ST=MG, C=BR"
```

**Aguarde** a mensagem de sucesso: `[Armazenando android\app\key.jks]`

### 3. Verificar se o arquivo foi criado

```powershell
Test-Path "android\app\key.jks"
```

Deve retornar: **True**

### 4. Build do APK Release

```bash
flutter build apk --release
```

### 5. Localizar o APK

O APK estará em:
```
build\app\outputs\flutter-apk\app-release.apk
```

---

## 🎯 APK DEBUG (PARA TESTAR AGORA)

Enquanto resolve o keystore, você pode usar o APK debug que JÁ FOI GERADO COM SUCESSO:

**Localização**: `build\app\outputs\flutter-apk\app-debug.apk`

Este APK:
- ✅ Funciona perfeitamente
- ✅ Tem todas as melhorias de UI/UX
- ✅ Pode ser instalado e testado
- ⚠️ É maior (não otimizado)
- ⚠️ Não pode ser publicado na Play Store

---

## 🔧 SOLUÇÃO ALTERNATIVA: Usar Android Studio

Se o comando não funcionar, use o Android Studio:

1. Abra o Android Studio
2. Vá em: **Build > Generate Signed Bundle / APK**
3. Selecione: **APK**
4. Clique em: **Create new...**
5. Preencha:
   - Key store path: `android/app/key.jks`
   - Password: `barbeiro2024`
   - Alias: `barbershop`
   - Key password: `barbeiro2024`
   - Validade: `10000` dias
   - Primeiro e último nome: `Ricardo Sidney`
   - Unidade organizacional: `Barbearia`
   - Organização: `Ricardo Sidney Barbeiro`
   - Cidade: `Ouro Preto`
   - Estado: `MG`
   - Código do país: `BR`

---

## 📊 RESUMO DO STATUS

### ✅ CONCLUÍDO:
- App Flutter 100% funcional
- Todas melhorias de UI/UX implementadas
- Botões de debug/migração removidos
- Cidade corrigida para Ouro Preto
- APK Debug gerado com sucesso
- Estrutura Android configurada

### ⏳ PENDENTE:
- Gerar keystore válido
- Build APK Release assinado

---

## 💡 DICA

**Para testar o app AGORA**, use o APK Debug:

```powershell
# Copiar para local fácil
Copy-Item "build\app\outputs\flutter-apk\app-debug.apk" "APK-Ricardo-Sidney-DEBUG.apk"
```

Depois transfira para o celular e instale!

---

## 🆘 PRECISA DE AJUDA?

Se continuar com erro, me avise qual mensagem aparece e eu te ajudo!
