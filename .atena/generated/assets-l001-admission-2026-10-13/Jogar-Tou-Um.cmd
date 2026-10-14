@echo off
setlocal
cd /d "%~dp0..\..\.."
set "APPDATA=%~dp0qa-Jogar-Tou-Um"
echo Local QA build: 0.4.0/assets-l001-admission-v01/1b0edb3+local-92c12e0ca1c7
"C:\Users\Higor Rossini\Desktop\Nottcard\Godot_v4.7.2-stable_win64.exe" --path . --log-file ".atena/generated/assets-l001-admission-2026-10-13/Jogar-Tou-Um.log" %* res://.atena/generated/assets-l001-admission-2026-10-13/playtest.tscn -- maelor "" --tou-um
endlocal
