@echo off
rem SPEC-176 S-005 (BUG-028): laboratorio de passada. Abre o jogo (codigo do projeto, nao o .exe) com um caminho de correcao por vez.
rem Compare os caminhos pelo olho, com o MESMO heroi e a mesma fase: andar de lado e nas diagonais.
rem Nada disto muda o jogo normal: as opcoes so valem com --walk-debug.
setlocal
set ROOT=%~dp0......
set GODOT=%ROOT%Godot_v4.7.2-stable_win64.exe
echo.
echo  1) C0  atual (10 fps, 190 px/s)
echo  2) C1a ritmo por heroi (fps = velocidade x 6 / (2 x 0,55 x altura)); velocidade igual
echo  3) C1b ritmo por heroi + velocidade 160 px/s
echo  4) C1c 15 fps fixo + velocidade 150 px/s
echo  5) C2  balanco e inclinacao sincronizados ao ciclo (2 px, 0,04 rad); ritmo atual
echo  6) C1a + C2
echo.
choice /c 123456 /n /m "Escolha 1-6: "
if errorlevel 6 set OPTS=--walk-debug --walk-fps=auto --walk-bob=2 --walk-lean=0.04 & goto run
if errorlevel 5 set OPTS=--walk-debug --walk-bob=2 --walk-lean=0.04 & goto run
if errorlevel 4 set OPTS=--walk-debug --walk-fps=15 --walk-speed=150 & goto run
if errorlevel 3 set OPTS=--walk-debug --walk-fps=auto --walk-speed=160 & goto run
if errorlevel 2 set OPTS=--walk-debug --walk-fps=auto & goto run
set OPTS=--walk-debug
:run
echo Opcoes: %OPTS%
"%GODOT%" --path "%ROOT%" -- %OPTS%
echo.
echo Jogo fechado. Anote qual caminho agradou (1 a 6) e em qual heroi.
pause
