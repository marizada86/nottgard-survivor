@echo off
rem SPEC-176 / PLAN-103 B-002 (S-009): laboratorio com a CANDIDATA COMPLETA do Durvall v03 (8 direcoes + ataque, sem espelho), 10 fps.
rem So existe em memoria: nada e gravado em assets/. Escolha o Durvall e ande nas 8 direcoes (use tambem o ataque).
rem move_sw vem do LOT17 (candidata a substituir a P9 retida); decida pelo olho se serve.
setlocal
set ROOT=%~dp0..\..\..
set GODOT=%ROOT%\Godot_v4.7.2-stable_win64.exe
set CAND=%ROOT%\.atena\generated\m1-movimento\piloto-durvall\candidata_v03
"%GODOT%" --path "%ROOT%" -- --walk-debug --walk-candidate=%CAND%
echo.
echo Jogo fechado. Anote por direcao (N, NE, E, SE, S, SW, W, NW): serve, serve com ajuste ou refazer.
pause
