@echo off
setlocal
cd /d "%~dp0..\..\.."
set "APPDATA=%~dp0qa-playtest-reduzido"
echo Local QA build: 0.4.0/ampulheta-admission-v01/2ae8c48+local-1f69574d8a27
"C:\Users\Higor Rossini\Desktop\Nottcard\Godot_v4.7.2-stable_win64.exe" --path . --log-file ".atena/generated/ampulheta-admission-2026-10-13/playtest-reduzido.log" res://.atena/generated/ampulheta-admission-2026-10-13/playtest.tscn -- ampulheta --reduced
endlocal
