# 📱 Instruções para Build do APK - Ricardo Sidney Barbeiro

## ✅ Status do Projeto

**Todas as melhorias de UI/UX foram concluídas:**
- ✅ Gradientes e animações em todas as telas
- ✅ Splash screen profissional
- ✅ Máscara visual de CPF (000.000.000-00)
- ✅ Cards com elevação e sombras modernas
- ✅ Skeleton loaders
- ✅ Transições animadas
- ✅ Botão DEBUG removido da Home

## 🔑 Passo 1: Gerar o Keystore (IMPORTANTE!)

Você precisa gerar um keystore para assinar o APK. Execute este comando no terminal:

```bash
keytool -genkey -v -keystore android/app/key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias barbershop
```

**Quando solicitado, use estas informações:**
- Store password: `barbeiro2024`
- Key password: `barbeiro2024`
- Nome: `Ricardo Sidney`
- Unidade organizacional: `Barbearia`
- Organização: `Ricardo Sidney Barbeiro`
- Cidade: `Ouro Preto`
- Estado: `MG`
- Código do país: `BR`

⚠️ **IMPORTANTE**: Guarde o arquivo `android/app/key.jks` e as senhas em local seguro! Você precisará deles para atualizar o app no futuro.

## 🎨 Passo 2: Configurar Ícone do App (Opcional)

Se você quiser um ícone personalizado:

1. Crie uma imagem 512x512 pixels com o logo da barbearia
2. Salve como `assets/icon.png`
3. Execute: `flutter pub run flutter_launcher_icons`

**Se NÃO tiver um logo**, o app usará o ícone padrão do Flutter.

## 🏗️ Passo 3: Build do APK

### Opção A: APK Debug (para testar)
```bash
flutter build apk --debug
```
**Localização**: `build/app/outputs/flutter-apk/app-debug.apk`

### Opção B: APK Release (para publicar)
```bash
flutter build apk --release
```
**Localização**: `build/app/outputs/flutter-apk/app-release.apk`

### Opção C: App Bundle (para Play Store)
```bash
flutter build appbundle --release
```
**Localização**: `build/app/outputs/bundle/release/app-release.aab`

## 📲 Passo 4: Instalar no Celular

### Via USB:
```bash
flutter install
```

### Via APK:
1. Copie o APK para o celular
2. Ative "Fontes desconhecidas" nas configurações
3. Abra o APK e instale

## 🔧 Troubleshooting

### Erro: "Signing config not found"
→ Certifique-se de que gerou o keystore no Passo 1

### Erro: "Firebase initialization failed"
→ Verifique se o arquivo `google-services.json` está em `android/app/`

### Erro de dependências
```bash
flutter clean
flutter pub get
flutter build apk --release
```

## 📋 Checklist Final Antes de Publicar

- [ ] Keystore gerado e guardado em local seguro
- [ ] Ícone personalizado configurado (opcional)
- [ ] App testado em dispositivo real
- [ ] Versão atualizada em `pubspec.yaml` (atualmente 2.0.0+1)
- [ ] Firebase configurado e funcionando
- [ ] Build release gerado com sucesso

## 🚀 Para Publicar na Play Store

1. Crie uma conta no [Google Play Console](https://play.google.com/console)
2. Pague a taxa única de US$ 25
3. Faça upload do arquivo `.aab` (app bundle)
4. Preencha as informações do app:
   - Nome: "Ricardo Sidney Barbeiro"
   - Categoria: Produtividade / Estilo de vida
   - Screenshots (capture telas do app)
   - Descrição
   - Política de privacidade

## 📊 Informações do App

- **Nome do pacote**: `com.ricardosidney.barbearia`
- **Versão**: 2.0.0 (versionCode: 1)
- **SDK mínimo**: Android 5.0 (API 21)
- **Permissões**: Internet

## 🎯 Próximos Passos Sugeridos

1. **Teste o app** em diferentes dispositivos Android
2. **Capture screenshots** das telas principais
3. **Escreva descrição** para a Play Store
4. **Configure Google Analytics** (opcional)
5. **Adicione Firebase Cloud Messaging** para notificações push (futuro)

---

**Dúvidas?** Consulte a documentação do Flutter: https://docs.flutter.dev/deployment/android
