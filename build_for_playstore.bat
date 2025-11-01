@echo off
echo ============================================
echo  BUILD DO APP BUNDLE PARA GOOGLE PLAY STORE
echo  Ricardo Sidney Barbeiro v2.0.0
echo ============================================
echo.

echo [1/5] Verificando instalacao do Flutter...
flutter --version
if errorlevel 1 (
    echo ERRO: Flutter nao encontrado!
    pause
    exit /b 1
)
echo.

echo [2/5] Limpando cache do Flutter...
flutter clean
if errorlevel 1 (
    echo ERRO ao limpar cache!
    pause
    exit /b 1
)
echo.

echo [3/5] Instalando dependencias...
flutter pub get
if errorlevel 1 (
    echo ERRO ao instalar dependencias!
    pause
    exit /b 1
)
echo.

echo [4/5] Gerando App Bundle (.aab) para Play Store...
echo ATENCAO: Este processo pode demorar alguns minutos e requer espaco em disco!
echo.
flutter build appbundle --release
if errorlevel 1 (
    echo.
    echo ============================================
    echo ERRO AO GERAR APP BUNDLE!
    echo ============================================
    echo.
    echo Possiveis causas:
    echo - Espaco insuficiente no disco (libere pelo menos 5GB)
    echo - Erro de configuracao do keystore
    echo - Problemas com o Gradle
    echo.
    echo Tente:
    echo 1. Limpe cache manualmente: rmdir /s /q build
    echo 2. Limpe cache do Gradle: cd android ^&^& gradlew clean
    echo 3. Libere espaco em disco
    echo 4. Execute novamente este script
    echo.
    pause
    exit /b 1
)
echo.

echo [5/5] Verificando arquivos gerados...
echo.
if exist "build\app\outputs\bundle\release\app-release.aab" (
    echo ============================================
    echo  SUCESSO! APP BUNDLE GERADO COM SUCESSO!
    echo ============================================
    echo.
    echo Arquivo gerado:
    echo build\app\outputs\bundle\release\app-release.aab
    echo.
    echo Tamanho do arquivo:
    dir /b "build\app\outputs\bundle\release\app-release.aab"
    echo.
    echo PROXIMO PASSO:
    echo 1. Acesse: https://play.google.com/console
    echo 2. Faca upload do arquivo app-release.aab
    echo 3. Consulte PLAY_STORE_RELEASE_GUIDE.md para mais detalhes
    echo.
) else (
    echo ERRO: Arquivo AAB nao encontrado!
    echo Verifique os logs acima para identificar o problema.
    echo.
)

echo.
echo Pressione qualquer tecla para abrir a pasta de saida...
pause > nul
explorer "build\app\outputs\bundle\release"
