@echo off
REM Script de limpeza de arquivos obsoletos (Python/Kivy)
REM Execução: scripts\cleanup_legacy.bat

echo.
echo ========================================
echo  LIMPEZA DE ARQUIVOS OBSOLETOS
echo  Projeto: Barbearia Flutter
echo ========================================
echo.

REM Verificar se está no diretório correto
if not exist "lib\" (
    echo ERRO: Execute este script a partir da raiz do projeto!
    echo Uso: scripts\cleanup_legacy.bat
    pause
    exit /b 1
)

echo [1/5] Fazendo backup de credenciais...
if exist "firebase-credentials.json" (
    copy "firebase-credentials.json" "%USERPROFILE%\Desktop\firebase-credentials-BACKUP-%date:~-4,4%%date:~-10,2%%date:~-7,2%.json" >nul 2>&1
    if errorlevel 1 (
        echo AVISO: Nao foi possivel fazer backup de firebase-credentials.json
    ) else (
        echo   OK: firebase-credentials.json copiado para Desktop
    )
)

if exist ".env" (
    copy ".env" "%USERPROFILE%\Desktop\env-BACKUP-%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt" >nul 2>&1
    if errorlevel 1 (
        echo AVISO: Nao foi possivel fazer backup de .env
    ) else (
        echo   OK: .env copiado para Desktop
    )
)

echo.
echo [2/5] Removendo arquivos Python/Kivy...

if exist "main.py" del /F /Q "main.py" && echo   - main.py (82KB)
if exist "buildozer.spec" del /F /Q "buildozer.spec" && echo   - buildozer.spec
if exist "requirements.txt" del /F /Q "requirements.txt" && echo   - requirements.txt
if exist ".env" del /F /Q ".env" && echo   - .env
if exist ".env.example" del /F /Q ".env.example" && echo   - .env.example
if exist "log.txt" del /F /Q "log.txt" && echo   - log.txt

if exist ".venv\" (
    echo   - Removendo .venv\ (pode demorar...)
    rmdir /S /Q ".venv" 2>nul
    echo   OK: .venv\ removido
)

echo.
echo [3/5] Removendo arquivos temporarios...

if exist "bugreport-*.zip" del /F /Q "bugreport-*.zip" && echo   - bugreport-*.zip
if exist "nul" del /F /Q "nul" && echo   - nul
if exist "barbershop_app.iml" del /F /Q "barbershop_app.iml" && echo   - barbershop_app.iml

echo.
echo [4/5] Removendo documentacao obsoleta...

set "docs_to_remove=COMANDOS_RAPIDOS.md COMO_EXECUTAR.md DIAGNOSTICO_RAPIDO.md FIRESTORE_RULES.md HABILITAR_MODO_DESENVOLVEDOR.md HOW_TO_ADD_DEBUG_BUTTON.md MIGRACAO_BANCO_DEFAULT.md MIGRACAO_COMPLETA.md POPULATE_DATA_DEBUG.md QUICK_FIX.md QUICK_START_DEBUG.md SOLUCAO_FINAL.md SOLUCAO_MIGRACAO.md SOLUTION_SUMMARY.md"

for %%f in (%docs_to_remove%) do (
    if exist "%%f" (
        del /F /Q "%%f"
        echo   - %%f
    )
)

echo.
echo [5/5] Limpeza do cache Flutter...
call flutter clean >nul 2>&1
if errorlevel 1 (
    echo AVISO: flutter clean falhou ou Flutter nao esta instalado
) else (
    echo   OK: Cache limpo
)

echo.
echo ========================================
echo  LIMPEZA CONCLUIDA!
echo ========================================
echo.
echo Proximos passos:
echo   1. Revise os arquivos restantes
echo   2. Execute: flutter pub get
echo   3. Execute: flutter analyze
echo   4. Execute: flutter run
echo.
echo Backups salvos em: %USERPROFILE%\Desktop\
echo.

pause
