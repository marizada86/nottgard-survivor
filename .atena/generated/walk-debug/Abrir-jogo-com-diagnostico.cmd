@echo off
rem BUG-028 / SPEC-144: abre o jogo (codigo do projeto, nao o .exe exportado) com o diagnostico de caminhada.
rem O log (CSV) vai para: %APPDATA%\Godot\app_userdata\Nottgard Survivors\walk_trace\
rem Para breakpoints, abra o projeto no editor do Godot, em Depurar > Personalizar instancias de execucao...
rem coloque os mesmos argumentos em "Argumentos de execucao principal" e aperte F5.
setlocal
set ROOT=%~dp0..\..\..
set GODOT=%ROOT%\Godot_v4.7.2-stable_win64.exe
echo.
echo  1) Somente log (jogar normal)
echo  2) Log + congelar com F9 / avancar um tick com F10
echo  3) Log + forcar a tira SE (isola a arte do codigo de direcao)
echo  4) Log + suavizacao de direcao (testa troca de tira)
echo  5) Log + animacao de andar a 15 fps (testa o ritmo)
echo.
choice /c 12345 /n /m "Escolha 1-5: "
if errorlevel 5 set OPTS=--walk-debug --walk-fps=15 & goto run
if errorlevel 4 set OPTS=--walk-debug --walk-smooth & goto run
if errorlevel 3 set OPTS=--walk-debug --walk-force=se & goto run
if errorlevel 2 set OPTS=--walk-debug --walk-controls & goto run
set OPTS=--walk-debug
:run
echo Opcoes: %OPTS%
"%GODOT%" --path "%ROOT%" -- %OPTS%
echo.
echo Jogo fechado. Envie os arquivos .csv da pasta walk_trace.
start "" "%APPDATA%\Godot\app_userdata\Nottgard Survivors\walk_trace"
pause
