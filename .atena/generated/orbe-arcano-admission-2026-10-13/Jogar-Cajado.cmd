@echo off
setlocal
cd /d "%~dp0..\..\.."
set "APPDATA=%~dp0qa-Jogar-Cajado"
echo Local QA build: 0.4.0/orbe-arcano-admission-v01/a431fa9+local-498dd8dce1bb
"C:\Users\Higor Rossini\Desktop\Nottcard\Godot_v4.7.2-stable_win64.exe" --path . --log-file ".atena/generated/orbe-arcano-admission-2026-10-13/Jogar-Cajado.log" %* res://.atena/generated/orbe-arcano-admission-2026-10-13/playtest.tscn -- cajado_dos_desejos
endlocal
