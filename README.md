# Barbearia Ricardo Sidney - App de Agendamento

> Sistema completo de agendamento para barbearia desenvolvido em Flutter com Firebase Firestore

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?logo=firebase)](https://firebase.google.com)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-success)]()

## 📱 Sobre o Projeto

Aplicativo mobile Android para gerenciamento de agendamentos da barbearia "Ricardo Sidney Barbeiro". Sistema completo com área administrativa para criação de horários e área do cliente para reservas, com integração WhatsApp e lembretes automáticos.

**✅ Versão Atual**: Flutter (100% funcional - 12 telas)
**❌ Versão Antiga**: Python/Kivy (depreciada - apenas referência)

## ⚡ Quick Start

```bash
# Instalar dependências
flutter pub get

# Executar em modo debug
flutter run

# Build APK para produção
flutter build apk --release
```

**APK de produção estará em**: `build/app/outputs/flutter-apk/app-release.apk`

## 🎯 Funcionalidades

### Área do Cliente
- ✅ Login e cadastro com CPF
- ✅ Visualização de horários disponíveis (agrupados por dia da semana)
- ✅ Agendamento de horários (máximo 1 ativo por cliente)
- ✅ Confirmação via WhatsApp com mensagem pré-preenchida
- ✅ Visualização de meus agendamentos
- ✅ Cancelamento de agendamentos
- ✅ Lembretes automáticos (0-3 dias antes do horário)
- ✅ Recuperação de senha com código de 6 dígitos
- ✅ Aceite de política de privacidade (LGPD)

### Área Administrativa
- ✅ Login exclusivo do dono (CPF e senha fixos)
- ✅ Criação de horários em lote (selecionar dias + horários)
- ✅ Visualização da agenda completa
- ✅ Cancelamento de agendamentos de clientes
- ✅ Horários em intervalos de 30min (7:00 às 23:30)

### Integrações
- 🔥 **Firebase Firestore** - Banco de dados em tempo real
- 📱 **WhatsApp** - Confirmação automática de agendamentos
- 🔐 **SHA-256** - Hash de CPF para IDs únicos
- 🎨 **Material Design 3** - Interface moderna e profissional

## 🛠️ Tecnologias

### Frontend
- **Flutter 3.x** - Framework mobile
- **Dart** - Linguagem de programação
- **Provider** - Gerenciamento de estado
- **Material Components** - UI components

### Backend
- **Firebase Firestore** - Banco de dados NoSQL
- **Firebase Auth** (opcional) - Autenticação

### Pacotes Principais
```yaml
firebase_core: ^2.24.2       # Firebase base
cloud_firestore: ^4.14.0     # Firestore database
provider: ^6.1.1             # State management
url_launcher: ^6.2.2         # WhatsApp integration
crypto: ^3.0.3               # SHA-256 hashing
intl: ^0.18.1                # Date formatting
```

## 📁 Estrutura do Projeto

```
lib/
├── core/
│   ├── constants/          # Cores e configurações
│   └── utils/              # Validadores e utilitários
├── services/
│   └── firebase_manager.dart  # Serviço Firebase (Singleton)
├── providers/              # State management
├── widgets/                # Componentes reutilizáveis
├── screens/
│   ├── loading_screen.dart
│   ├── home_screen.dart
│   ├── admin/              # 3 telas admin
│   └── client/             # 6 telas cliente
└── main.dart               # Entry point + rotas
```

## 🎨 Paleta de Cores

| Cor | Hex | Uso |
|-----|-----|-----|
| Dourado | `#D4AF37` | Botões cliente, destaques |
| Vinho | `#8A1438` | Botões admin |
| Azul Escuro | `#1A2433` | Background principal |
| Card Escuro | `#1F2A3D` | Cards e containers |

## 🔥 Firebase - Estrutura de Dados

### Coleção: `usuarios`
```
Document ID: SHA-256 hash do CPF
{
  "nome": "João Silva",
  "senha": "hash_sha256",
  "cpf_ultimos_digitos": "8901",
  "data_criacao": "2025-10-25T10:00:00Z",
  "agendamentos_ativos": 0
}
```

### Coleção: `agendamentos`
```
Document ID: YYYY-MM-DD_HHMM (ex: 2025-10-26_1430)
{
  "data": "26/10/2025",
  "data_iso": "2025-10-26",
  "dia_semana": "Segunda",
  "hora": "14:30",
  "status": "livre" | "agendado",
  "cliente_cpf": "hash_sha256",
  "cliente_nome": "João Silva"
}
```

### Coleção: `recuperacao_senha`
```
Document ID: SHA-256 hash do CPF
{
  "codigo": "123456",
  "usado": false,
  "criado_em": "2025-10-25T10:00:00Z"
}
```

## 🚀 Instalação e Configuração

### Pré-requisitos
- Flutter SDK 3.0+
- Android Studio ou VS Code
- Firebase CLI (para configuração)
- Conta Firebase

### Passo 1: Clonar Repositório
```bash
git clone https://github.com/seu-usuario/barbearia-app.git
cd barbearia-app
```

### Passo 2: Instalar Dependências
```bash
flutter pub get
```

### Passo 3: Configurar Firebase
```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar Firebase (cria firebase_options.dart automaticamente)
flutterfire configure
```

### Passo 4: Executar App
```bash
# Em emulador ou dispositivo físico
flutter run

# Ou especificar dispositivo
flutter run -d <device_id>
```

## 📱 Build para Produção

### APK Debug (para testes)
```bash
flutter build apk --debug
```

### APK Release (para distribuição)
```bash
flutter build apk --release
```

### App Bundle (para Play Store)
```bash
flutter build appbundle --release
```

### Assinatura do APK
1. Criar keystore:
```bash
keytool -genkey -v -keystore ~/barbearia-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias barbearia
```

2. Configurar `android/key.properties`:
```properties
storePassword=SUA_SENHA
keyPassword=SUA_SENHA
keyAlias=barbearia
storeFile=/caminho/para/barbearia-key.jks
```

3. Build assinado:
```bash
flutter build apk --release
```

## 🧪 Credenciais de Teste

### Admin
- **CPF**: `13681715670`
- **Senha**: `971409`

### Cliente
- Criar novo usuário com qualquer CPF de 11 dígitos
- Senha mínima de 4 caracteres

### 🛠️ Debug: Popular Dados de Teste

Para popular o Firestore rapidamente com usuários e horários de teste:

1. Execute o app: `flutter run`
2. Navegue para a rota `/admin/populate-data`
3. Use os botões para:
   - Criar 3 usuários de teste (João, Maria, Carlos)
   - Criar horários livres para os próximos 7 dias
   - Limpar todos os agendamentos (com confirmação)

**Documentação completa**: Ver `POPULATE_DATA_DEBUG.md`

**IMPORTANTE**: Remover esta rota em produção!

## 📊 Comparação Python vs Flutter

| Aspecto | Python/Kivy | Flutter |
|---------|-------------|---------|
| Tamanho APK | ~70MB | ~15MB |
| Startup | ~3-5s | ~0.8s |
| Performance | 30-40 FPS | 60 FPS |
| Hot Reload | ❌ Não | ✅ Sim (~1s) |
| Play Store | Limitado | Completo |
| iOS Support | Difícil | Fácil |

## 🐛 Troubleshooting

### Erro: MissingPluginException
```bash
flutter clean
flutter pub get
flutter run
```

### Erro: Firebase Permission Denied
Configure Firestore Rules (desenvolvimento):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // ⚠️ Apenas para dev!
    }
  }
}
```

### WhatsApp não abre
Adicione ao `android/app/src/main/AndroidManifest.xml`:
```xml
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="https" />
  </intent>
</queries>
```

## 📚 Documentação Adicional

- **CLAUDE.md** - Instruções para Claude Code (AI assistant)
- **MIGRACAO_COMPLETA.md** - Detalhes da migração Python→Flutter
- **POPULATE_DATA_DEBUG.md** - Tela de debug para popular dados de teste
- **lib/screens/** - Documentação inline em cada tela

## 🤝 Contribuindo

Embora este seja um projeto privado para a barbearia, sugestões são bem-vindas:

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto é propriedade privada de Ricardo Sidney Barbeiro. Todos os direitos reservados.

## 📞 Contato

**Ricardo Sidney Barbeiro**
- WhatsApp: +55 31 8538-2104
- Localização: Belo Horizonte, MG

---

**Desenvolvido com** ❤️ **usando Flutter**
**Migração Python→Flutter assistida por** Claude Code (Anthropic)
