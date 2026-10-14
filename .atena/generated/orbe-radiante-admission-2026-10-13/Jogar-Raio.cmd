@echo off
setlocal
cd /d "%~dp0..\..\.."
set "APPDATA=%~dp0qa-Jogar-Raio"
echo Local QA build: 0.4.0/orbe-radiante-admission-v01/a431fa9+local-c9693f3da2cc
"C:\Users\Higor Rossini\Desktop\Nottcard\Godot_v4.7.2-stable_win64.exe" --path . --log-file ".atena/generated/orbe-radiante-admission-2026-10-13/Jogar-Raio.log" %* res://.atena/generated/orbe-radiante-admission-2026-10-13/playtest.tscn -- raio_de_luz
endlocal
