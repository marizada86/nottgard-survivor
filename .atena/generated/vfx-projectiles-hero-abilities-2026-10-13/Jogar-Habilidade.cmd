@echo off
setlocal
cd /d "%~dp0..\..\.."
set "APPDATA=%~dp0qa-playtest"
if "%~1"=="" (echo Uso: Jogar-Habilidade.cmd ^<heroi^>   com durvall, brook, maelor, sylas, kayron, korrak, leoric, nyrelia, zynara ou bromnor & exit /b 1)
echo QA local: habilidade ativa de %~1 (tecla Q ou botao direito do mouse). Acrescente --reduced para o modo de impacto reduzido.
Godot_v4.7.2-stable_win64.exe --path . res://.atena/generated/vfx-projectiles-hero-abilities-2026-10-13/playtest.tscn -- %*
endlocal
