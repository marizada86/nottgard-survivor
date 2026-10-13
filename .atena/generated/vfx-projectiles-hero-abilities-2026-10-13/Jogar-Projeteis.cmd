@echo off
setlocal
cd /d "%~dp0..\..\.."
set "APPDATA=%~dp0qa-playtest"
echo QA local: orbes e onda cortante. Troque o heroi/armas editando os argumentos abaixo.
Godot_v4.7.2-stable_win64.exe --path . res://.atena/generated/vfx-projectiles-hero-abilities-2026-10-13/playtest.tscn -- leoric raio_de_luz luz_mais_pura raio_enfraquecedor lamina_trovejante tempestade
endlocal
