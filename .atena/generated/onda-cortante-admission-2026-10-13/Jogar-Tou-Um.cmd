@echo off
setlocal
cd /d "%~dp0..\..\.."
set "APPDATA=%~dp0qa-Jogar-Tou-Um"
echo Local QA build: 0.4.0/onda-cortante-admission-v01/a431fa9+local-7a192db2f9dc
"C:\Users\Higor Rossini\Desktop\Nottcard\Godot_v4.7.2-stable_win64.exe" --path . --log-file ".atena/generated/onda-cortante-admission-2026-10-13/Jogar-Tou-Um.log" %* res://.atena/generated/onda-cortante-admission-2026-10-13/playtest.tscn -- tempestade --tou-um
endlocal
