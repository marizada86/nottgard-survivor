@echo off
setlocal
cd /d "%~dp0..\..\.."
set "APPDATA=%~dp0qa-Jogar-Leoric"
echo Local QA build: 0.4.0/assets-l002-admission-v01/2b96638+local-0c664cdc0023
"C:\Users\Higor Rossini\Desktop\Nottcard\Godot_v4.7.2-stable_win64.exe" --path . --log-file ".atena/generated/assets-l002-admission-2026-10-14/Jogar-Leoric.log" %* res://.atena/generated/assets-l002-admission-2026-10-14/playtest.tscn -- leoric
endlocal
